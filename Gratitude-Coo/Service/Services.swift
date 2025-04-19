//
//  Services.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/17/25.
//

import Foundation

protocol ServiceProtocol {
    var authService: AuthenticationServiceProtocol { get set }
    var userService: UserServiceProtocol { get set }
    var gratitudeService: GratitudeServiceProtocol { get set }
}

class ServiceImpl: ServiceProtocol {
    
    private let networkService: NetworkServiceProtocol
    private let tokenManager: TokenManagerProtocol
    
    var authService: AuthenticationServiceProtocol
    var userService: UserServiceProtocol
    var gratitudeService: GratitudeServiceProtocol
    
    init() {
        self.networkService = NetworkService()
        self.tokenManager = TokenManager()
        self.authService = AuthenticationService(
            networkService: networkService,
            tokenManager: tokenManager
        )
        self.userService = UserService(
            networkService: networkService,
            tokenManager: tokenManager
        )
        self.gratitudeService = GratitudeService(
            networkService: networkService,
            tokenManager: tokenManager
        )
    }
}

class StubService: ServiceProtocol {
    var authService: AuthenticationServiceProtocol
    var userService: UserServiceProtocol
    var gratitudeService: GratitudeServiceProtocol
    
    init() {
        self.authService = StubAuthenticationService()
        self.userService = StubUserService()
        self.gratitudeService = StubGratitudeService()
    }
}

