//
//  AuthenticationViewModel.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/17/25.
//

import Foundation
import Combine
import AuthenticationServices

enum AuthenticationState {
    case unauthenticated
    case authenticated
}

// todo: DI container에서 주입받기
class AuthenticationViewModel: ObservableObject {
    
    // 필요에 따라 프로퍼티를 더 추가할 수 있습니다.
    enum Action {
        case checkAuthenticationState
        case login(email: String, password: String)
        case register(email: String, password: String)
        case logout
    }
    
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var isLoading: Bool = false
    @Published var error: AuthError?
    
    var userId: String?
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
        case .checkAuthenticationState:
            if let userId = container.service.authService.checkAuthenticationState() {
                self.userId = userId
                authenticationState = .authenticated
            } else {
                authenticationState = .unauthenticated
            }
        case .login(let email, let password):
            isLoading = true
            
            container.service.authService.login(email: email, password: password)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.error = error
                    }
                } receiveValue: { [weak self] user in
                    print("userId: \(user.id), email: \(user.email), name: \(String(describing: user.name))")
                    self?.userId = "\(user.id)"
                    self?.authenticationState = .authenticated
                }
                .store(in: &subscriptions)
        case .register(let email, let password):
            isLoading = true
            
            container.service.authService.register(email: email, password: password)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.error = error
                    }
                } receiveValue: { [weak self] _ in
                    // 회원가입 후 자동 로그인 또는 로그인 화면으로 이동
                    self?.send(action: .login(email: email, password: password))
                }
                .store(in: &subscriptions)
        case .logout:
            isLoading = true
            
            container.service.authService.logout()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.error = error
                    }
                } receiveValue: { [weak self] _ in
                    self?.userId = nil
                    self?.authenticationState = .unauthenticated
                }
                .store(in: &subscriptions)
        }
    }
    
}
