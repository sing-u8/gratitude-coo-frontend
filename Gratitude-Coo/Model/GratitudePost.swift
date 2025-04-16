//
//  GratitudePost.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/16/25.
//

import Foundation

enum Visibility: String, CaseIterable {
    case PRIVATE  =  "isPrivate"
    case PUBLIC   =  "isPublic"
}

struct GratitudePost: Identifiable, Hashable {
    var id: Int
    var contents: String
    var recipientId: Int
    var authorId: Int
    var isAnonymous: Bool
    var visibility: Visibility
}
