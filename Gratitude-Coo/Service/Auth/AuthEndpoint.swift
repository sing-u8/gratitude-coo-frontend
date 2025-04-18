//
//  AuthEndpoint.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/18/25.
//

import Foundation

enum AuthEndpoint: APIEndpoint {
    case register(email: String, password: String)
    case login(email: String, password: String)
    
    var path: String {
        switch self {
        case .register:
            return "/auth/register"
        case .login:
            return "/auth/login"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .register, .login:
            return .post
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .register(let email, let password),
             .login(let email, let password):
            let credentials = "\(email):\(password)".toBase64()
            return [
                "Authorization": "Basic \(credentials)"
            ]
        }
    }
    
    var body: [String: Any]? {
        return nil // 요청 본문 없음
    }
}
