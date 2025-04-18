//
//  AuthResponse.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/18/25.
//

import Foundation


struct AuthUserResponse: Decodable {
    let id: Int
    let email: String
    let name: String?
    let nickname: String?
    let profile: String?
}

struct AuthRegisterResponse: Decodable {
    let id: Int
    let email: String
    let name: String?
    let nickname: String?
    let profile: String?
}

struct AuthLoginResponse: Decodable {
    let refreshToken: String
    let accessToken: String
    let member: AuthUserResponse
}
