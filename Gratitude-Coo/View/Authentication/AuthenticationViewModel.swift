//
//  AuthenticationViewModel.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/17/25.
//

import Foundation
import Combine
import SwiftData


enum AuthenticationState {
    case unauthenticated
    case authenticated
}

class AuthenticationViewModel: ObservableObject {
    
    enum Action {
        case checkAuthenticationState
        case login(email: String, password: String)
        case register(email: String, password: String)
        case logout
    }
    
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var isLoading: Bool = false
    @Published var error: AuthError?
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    private var modelContext: ModelContext
    
    init(container: DIContainer, modelContext: ModelContext) {
        self.container = container
        self.modelContext = modelContext
    }
    
    private func saveUser(_ user: User) {
        // 기존 사용자 데이터 삭제
        let descriptor = FetchDescriptor<User>()
        if let existingUsers = try? modelContext.fetch(descriptor) {
            existingUsers.forEach { modelContext.delete($0) }
        }
        
        // 새 사용자 데이터 저장
        modelContext.insert(user)
        try? modelContext.save()
    }
    
    private func clearUserData() {
        let descriptor = FetchDescriptor<User>()
        if let existingUsers = try? modelContext.fetch(descriptor) {
            existingUsers.forEach { modelContext.delete($0) }
            try? modelContext.save()
        }
    }
    
    func send(action: Action) {
        switch action {
        case .checkAuthenticationState:
            if container.service.authService.checkAuthenticationState() != nil {
                let descriptor = FetchDescriptor<User>()
                if let _ = try? modelContext.fetch(descriptor).first {
                    authenticationState = .authenticated
                }
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
                    guard let self = self else { return }
                    
                    let userModel = User(
                        id: user.id,
                        email: user.email,
                        name: user.name,
                        nickname: user.nickname,
                        profileImage: user.profileImage
                    )
                    self.saveUser(userModel)
                    self.authenticationState = .authenticated
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
                    self?.clearUserData()
                    self?.authenticationState = .unauthenticated
                }
                .store(in: &subscriptions)
        }
    }
    
}
