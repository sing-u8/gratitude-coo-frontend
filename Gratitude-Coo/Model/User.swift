//
//  Member.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/16/25.
//

import Foundation
import SwiftData

@Model
final class User: Identifiable, Hashable {
    @Attribute(.unique)
    var id: Int
    
    @Attribute(.unique)
    var email: String
    
    var name: String?
    
    var nickname: String?
    
    var profileImage: String?
    
    init(id: Int, email: String, name: String? = nil, nickname: String? = nil, profileImage: String? = nil) {
        self.id = id
        self.email = email
        self.name = name
        self.nickname = nickname
        self.profileImage = profileImage
    }
    
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
