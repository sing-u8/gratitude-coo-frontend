//
//  AuthenticationService.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/17/25.
//

import Foundation
import Combine

protocol AuthenticationServiceProtocol {
    func register(email: String, password: String) -> AnyPublisher<Void, AuthError>
    func login(email: String, password: String) -> AnyPublisher<User, AuthError>
    func checkAuthenticationState() -> String?
    func logout() -> AnyPublisher<Void, AuthError>
}

class AuthenticationService: AuthenticationServiceProtocol {
    
    private let networkService: NetworkServiceProtocol
    private let tokenManager: TokenManagerProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService(),
         tokenManager: TokenManagerProtocol = TokenManager()) {
        self.networkService = networkService
        self.tokenManager = tokenManager
    }
    
    func register(email: String, password: String) -> AnyPublisher<Void, AuthError> {
        return networkService.request(AuthEndpoint.register(email: email, password: password))
            .map { (_: AuthRegisterResponse) in () }
            .mapError { error in
                switch error {
                case .unauthorized:
                    return .invalidCredentials
                default:
                    return .networkError(error)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func login(email: String, password: String) -> AnyPublisher<User, AuthError> {
        return networkService.request(AuthEndpoint.login(email: email, password: password))
            .tryMap { [weak self] (response: AuthLoginResponse) -> User in
                guard let self = self else {
                    throw AuthError.unknown
                }
                
                try self.tokenManager.saveTokens(
                    accessToken: response.accessToken,
                    refreshToken: response.refreshToken
                )
                
                return User(
                    id: response.member.id,
                    email: response.member.email,
                    name: response.member.name,
                    nickname: response.member.nickname,
                    profileImage: response.member.profile
                )
            }
            .mapError { error in
                if let authError = error as? AuthError {
                    return authError
                }
                if let networkError = error as? NetworkError {
                    if case .unauthorized = networkError {
                        return .invalidCredentials
                    }
                    return .networkError(networkError)
                }
                return .unknown
            }
            .eraseToAnyPublisher()
    }
    
    func checkAuthenticationState() -> String? {
        do {
            let accessToken = try tokenManager.getAccessToken()
            // 가지고 있는 토큰이 유효한 토큰인지 확인이 필요함.
            return accessToken
        } catch {
            return nil
        }
    }
    
    func logout() -> AnyPublisher<Void, AuthError> {
        return Future<Void, AuthError> { [weak self] promise in
            do {
                try self?.tokenManager.clearTokens()
                promise(.success(()))
            } catch {
                promise(.failure(.unknown))
            }
        }.eraseToAnyPublisher()
    }
}

// MARK: - Stub
class StubAuthenticationService: AuthenticationServiceProtocol {
    func register(email: String, password: String) -> AnyPublisher<Void, AuthError> {
        return Just(()).setFailureType(to: AuthError.self).eraseToAnyPublisher()
    }
    
    func login(email: String, password: String) -> AnyPublisher<User, AuthError> {
        return Just(User.stub1).setFailureType(to: AuthError.self).eraseToAnyPublisher()
    }
    
    func checkAuthenticationState() -> String? {
        return nil
    }
    
    func logout() -> AnyPublisher<Void, AuthError>  {
        return Just(()).setFailureType(to: AuthError.self).eraseToAnyPublisher()
    }
}
