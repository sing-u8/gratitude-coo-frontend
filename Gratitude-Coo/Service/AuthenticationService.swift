//
//  AuthenticationService.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/17/25.
//

import Foundation
import Combine
import AuthenticationServices

enum AuthenticationError: Error {
    case clientIDError
    case tokenError
    case invalidError
}

protocol AuthenticationServiceType {
    func checkAuthenticationState() -> String?
    func signIn() -> AnyPublisher<User, ServiceError>
    func logout() -> AnyPublisher<Void, ServiceError>
}

class AuthenticationServiceImpl: AuthenticationServiceType {
    
    func checkAuthenticationState() -> String? {
        return "userId"
    }
    
    func signIn() -> AnyPublisher<User, ServiceError> {
        Empty().eraseToAnyPublisher()
        //Future { [weak self] promise in
        //    self?.signIn { result in
        //        switch result {
        //        case let .success(user):
        //            promise(.success(user))
        //        case let .failure(error):
        //            promise(.failure(.error(error)))
        //        }
        //    }
        //}.eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, ServiceError> {
        return Just(()).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
}

extension AuthenticationServiceImpl {
    
    private func signIn(completion: @escaping (Result<User, Error>) -> Void) {
        
        
        
    }
    
}

// MARK: - Stub
class StubAuthenticationService: AuthenticationServiceType {
    func checkAuthenticationState() -> String? {
        return nil
    }
    
    func signIn() -> AnyPublisher<User, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    
    func logout() -> AnyPublisher<Void, ServiceError>  {
        Empty().eraseToAnyPublisher()
    }
}
