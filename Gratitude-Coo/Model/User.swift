//
//  Member.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/16/25.
//

import Foundation

struct User: Identifiable, Hashable {
    var id: Int
    var email: String
    var name: String?
    var nickname: String?
    var profileImage: String?
    
    var acessToken: String
    var refreshToken: String
}

extension User {
    
}

extension User {
    static var stub1: User {
        .init(id: 1, email: "test@gmail.com", acessToken: "accessToken1", refreshToken: "refreshToken1")
    }
    static var stub2: User {
        .init(id: 2, email: "test@naver.com", acessToken: "accessToken2", refreshToken: "refreshToken2")
    }
}
