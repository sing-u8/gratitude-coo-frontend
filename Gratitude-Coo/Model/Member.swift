//
//  Member.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/16/25.
//

import Foundation

struct Member: Identifiable, Hashable {
    var id: Int
    var email: String
    var name: String?
    var nickname: String?
    var profileImage: String?
    
    var acessToken: String
    var refreshToken: String
}

extension Member {
    
}

extension Member {
    static var stub1: Member {
        .init(id: 1, email: "test@gmail.com", acessToken: "accessToken1", refreshToken: "refreshToken1")
    }
    static var stub2: Member {
        .init(id: 2, email: "test@naver.com", acessToken: "accessToken2", refreshToken: "refreshToken2")
    }
}
