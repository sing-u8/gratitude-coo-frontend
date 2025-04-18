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
}

extension User {
    
}

extension User {
    static var stub1: User {
        .init(id: 1, email: "test@gmail.com")
    }
    static var stub2: User {
        .init(id: 2, email: "test@naver.com")
    }
}
