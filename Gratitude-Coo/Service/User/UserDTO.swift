import Foundation

struct UpdateMemberDto: Codable {
    let email: String?
    let password: String?
    let name: String?
    let nickname: String?
    let profile: String?
}

struct UpdateMemberProfileDto: Codable {
    let profile: String?
    let name: String?
    let nickname: String?
}

struct SearchMemberDto: Codable {
    let search: String?
    let cursor: String?
    let order: [String]
    let take: Int
}

struct SearchMemberResponseDto: Codable {
    let members: [Member]
    let nextCursor: String?
    let count: Int
}

struct Member: Codable {
    let id: Int
    let email: String
    let name: String
    let nickname: String
    let profile: String?
    
    enum CodingKeys: String, CodingKey {
        case id, email, name, nickname, profile
    }
} 
