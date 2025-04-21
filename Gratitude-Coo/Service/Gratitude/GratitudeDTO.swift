import Foundation

enum Visibility: String, CaseIterable, Codable {
    case PRIVATE  =  "isPrivate"
    case PUBLIC   =  "isPublic"
}

enum PostType: String, Codable {
    case fromMe = "FromMe"
    case fromOther = "FromOther"
    case toOther = "ToOther"
}

struct CreateGratitudeDto: Codable {
    let recipientId: Int
    let authorId: Int
    let contents: String
    let isAnonymous: Bool
    let visibility: Visibility
}

struct UpdateGratitudeDto: Codable {
    let contents: String?
    let isAnonymous: Bool?
    let visibility: Visibility?
}

struct GratitudeResponse: Codable, Hashable {
    var id: Int
    var contents: String
    var recipient: Member
    var author: Member
    var isAnonymous: Bool
    var visibility: Visibility
    var createdAt: String
}

struct UpdateGratitudeResponse: Codable, Hashable {
    var id: Int
    var contents: String
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

struct GetGratitudeResponse: Codable {
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

struct GratitudeCountResponse: Codable {
    let sentCount: Int
    let receivedCount: Int
}
