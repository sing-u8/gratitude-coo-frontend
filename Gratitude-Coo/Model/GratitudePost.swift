//
//  GratitudePost.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/16/25.
//

import Foundation
import SwiftData

@Model
final class GratitudePost: Identifiable, Hashable {
    @Attribute(.unique)
    var id: Int
    var contents: String
    var recipient: User
    var author: User
    var isAnonymous: Bool
    var visibility: Visibility
    
    init(id: Int, contents: String, recipient: User, author: User, isAnonymous: Bool, visibility: Visibility) {
        self.id = id
        self.contents = contents
        self.recipient = recipient
        self.author = author
        self.isAnonymous = isAnonymous
        self.visibility = visibility
    }
}

extension GratitudePost {
    
}

extension GratitudePost {
    static var stub1: GratitudePost {
        GratitudePost(id: 1, contents: "감사합니다", recipient: User.stub1, author: User.stub2, isAnonymous: false, visibility: .PUBLIC)
    }
}
