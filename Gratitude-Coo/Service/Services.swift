//
//  Services.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/17/25.
//

import Foundation

protocol ServiceType {
    
    var authService: AuthenticationServiceType { get set }
    
}

class ServiceImpl: ServiceType {
    
    var authService: AuthenticationServiceType
    
    init() {
        self.authService = AuthenticationServiceImpl()
    }
    
}

class StubService: ServiceType {
    
    var authService: AuthenticationServiceType
    
    init() {
        self.authService = StubAuthenticationService()
    }
}


