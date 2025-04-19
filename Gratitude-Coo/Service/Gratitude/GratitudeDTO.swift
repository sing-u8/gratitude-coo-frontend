import Foundation

enum Visibility: String, CaseIterable, Codable {
    case PRIVATE  =  "isPrivate"
    case PUBLIC   =  "isPublic"
}

enum PostType: String, Codable {
    case fromMe
    case fromOther
    case toOther
}

struct CreateGratitudeDto: Codable {
    let recipientId: Int
    let authorId: Int
    let contents: String
    let isAnonymous: Bool
    let visibility: Visibility
}

struct UpdateGratitudeDto: Codable {
    let recipientId: Int?
    let authorId: Int?
    let contents: String?
    let isAnonymous: Bool?
    let visibility: Visibility?
}

struct GratitudeResponse: Codable {
    var id: Int
    var contents: String
    var recipient: Member
    var author: Member
    var isAnonymous: Bool
    var visibility: Visibility
}

struct GetGratitudeDto: Codable {
    let memberId: Int
    let postType: PostType?
    let cursor: String?
    let order: [String]
    let take: Int
}

struct GetGratitudeResponseDto: Codable {
    let gratitudeList: [GratitudeResponse]
    let nextCursor: String?
    let count: Int
}

struct GratitudeLikeResponse: Codable {
    let isLiked: Bool
}

struct GratitudeLikeCountResponse: Codable {
    let count: Int
} 
