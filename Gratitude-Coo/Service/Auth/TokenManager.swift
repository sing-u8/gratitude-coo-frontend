//
//  TokenManager.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/18/25.
//

import Foundation
import Combine

protocol TokenManagerProtocol {
    func saveTokens(accessToken: String, refreshToken: String) throws
    func getAccessToken() throws -> String
    func getRefreshToken() throws -> String
    func clearTokens() throws
    func isAuthenticated() -> Bool
}

class TokenManager: TokenManagerProtocol {
    
    private enum Keys {
        static let accessToken = "accessToken"
        static let refreshToken = "refreshToken"
    }
    
    private let keychainService: KeychainServiceProtocol
    
    init(keychainService: KeychainServiceProtocol = KeychainService()) {
        self.keychainService = keychainService
    }
    
    func saveTokens(accessToken: String, refreshToken: String) throws {
        guard let accessData = accessToken.data(using: .utf8),
              let refreshData = refreshToken.data(using: .utf8) else {
            throw KeychainError.invalidItemFormat
        }
        
        try keychainService.save(key: Keys.accessToken, data: accessData)
        try keychainService.save(key: Keys.refreshToken, data: refreshData)
    }
    
    func getAccessToken() throws -> String {
        let data = try keychainService.read(key: Keys.accessToken)
        guard let token = String(data: data, encoding: .utf8) else {
            throw KeychainError.invalidItemFormat
        }
        return token
    }
    
    func getRefreshToken() throws -> String {
        let data = try keychainService.read(key: Keys.refreshToken)
        guard let token = String(data: data, encoding: .utf8) else {
            throw KeychainError.invalidItemFormat
        }
        return token
    }
    
    func clearTokens() throws {
        try keychainService.delete(key: Keys.accessToken)
        try keychainService.delete(key: Keys.refreshToken)
    }
    
    func isAuthenticated() -> Bool {
        do {
            _ = try getAccessToken()
            return true
        } catch {
            return false
        }
    }
}
