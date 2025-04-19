import Foundation

enum GratitudeEndpoint {
    case createGratitude(dto: CreateGratitudeDto, accessToken: String)
    case updateGratitude(id: Int, dto: UpdateGratitudeDto, accessToken: String)
    case deleteGratitude(id: Int, accessToken: String)
    case getGratitudeList(dto: GetGratitudeDto, accessToken: String)
    case toggleGratitudeLike(id: Int, accessToken: String)
    case getGratitudeLikeCount(id: Int, accessToken: String)
}

extension GratitudeEndpoint: APIEndpoint {
    var path: String {
        switch self {
        case .createGratitude:
            return "/gratitude"
        case .updateGratitude(let id, _, _):
            return "/gratitude/\(id)"
        case .deleteGratitude(let id, _):
            return "/gratitude/\(id)"
        case .getGratitudeList(let dto, _):
            var pathWithQuery = "/gratitude?memberId=\(dto.memberId)&take=\(dto.take)"
            
            let orderString = dto.order.joined(separator: ",")
            pathWithQuery += "&order=\(orderString)"
            
            if let postType = dto.postType {
                pathWithQuery += "&postType=\(postType.rawValue)"
            }
            
            if let cursor = dto.cursor, !cursor.isEmpty {
                pathWithQuery += "&cursor=\(cursor)"
            }
            
            return pathWithQuery
        case .toggleGratitudeLike(let id, _):
            return "/gratitude/\(id)/like"
        case .getGratitudeLikeCount(let id, _):
            return "/gratitude/\(id)/like/count"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createGratitude:
            return .post
        case .updateGratitude:
            return .put
        case .deleteGratitude:
            return .delete
        case .getGratitudeList, .getGratitudeLikeCount:
            return .get
        case .toggleGratitudeLike:
            return .post
        }
    }
    
    var body: [String: Any]? {
        switch self {
        case .createGratitude(let dto, _):
            return [
                "recipientId": dto.recipientId,
                "authorId": dto.authorId,
                "contents": dto.contents,
                "isAnonymous": dto.isAnonymous,
                "visibility": dto.visibility.rawValue
            ]
        case .updateGratitude(_, let dto, _):
            var body: [String: Any] = [:]
            if let recipientId = dto.recipientId { body["recipientId"] = recipientId }
            if let authorId = dto.authorId { body["authorId"] = authorId }
            if let contents = dto.contents { body["contents"] = contents }
            if let isAnonymous = dto.isAnonymous { body["isAnonymous"] = isAnonymous }
            if let visibility = dto.visibility { body["visibility"] = visibility.rawValue }
            return body
        default:
            return nil
        }
    }
    
    var queryParameters: [String: Any]? {
        return nil
    }
    
    var headers: [String: String]? {
        var headers: [String: String] = [:]
        
        switch self {
        case .createGratitude(_, let accessToken),
             .updateGratitude(_, _, let accessToken),
             .deleteGratitude(_, let accessToken),
             .getGratitudeList(_, let accessToken),
             .toggleGratitudeLike(_, let accessToken),
             .getGratitudeLikeCount(_, let accessToken):
            headers["Authorization"] = "Bearer \(accessToken)"
        }
        
        return headers.isEmpty ? nil : headers
    }
} 
