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
        case login
        case logout
    }
    
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var isLoading: Bool = false
    
    var userId: String?
    
    private var conatiner: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.conatiner = container
    }
    
    func send(action: Action) {
        switch action {
        case .checkAuthenticationState:
            return
        case .login:
            return
        case .logout:
            return
        }
    }
    
}
