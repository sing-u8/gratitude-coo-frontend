import Foundation

enum UserEndpoint {
    case findAllMembers
    case findOneMember(id: Int)
    case updateMember(id: Int, dto: UpdateMemberDto, accessToken: String)
    case removeMember(id: Int, accessToken: String)
    case searchMembers(SearchMemberDto)
}

extension UserEndpoint: APIEndpoint {
    var path: String {
        switch self {
        case .findAllMembers:
            return "/member/all"
        case .findOneMember(let id):
            return "/member/\(id)"
        case .updateMember(let id, _, _):
            return "/member/\(id)"
        case .removeMember(let id, _):
            return "/member/\(id)"
        case .searchMembers:
            return "/member"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .findAllMembers, .findOneMember, .searchMembers:
            return .get
        case .updateMember:
            return .put
        case .removeMember:
            return .delete
        }
    }
    
    var body: [String: Any]? {
        switch self {
        case .updateMember(_, let dto, _):
            var body: [String: Any] = [:]
            if let email = dto.email { body["email"] = email }
            if let password = dto.password { body["password"] = password }
            if let name = dto.name { body["name"] = name }
            if let nickname = dto.nickname { body["nickname"] = nickname }
            if let profile = dto.profile { body["profile"] = profile }
            return body
        default:
            return nil
        }
    }
    
    var queryParameters: [String: Any]? {
        switch self {
        case .searchMembers(let dto):
            var params: [String: Any] = [
                "take": dto.take,
                "order": dto.order
            ]
            if let search = dto.search { params["search"] = search }
            if let cursor = dto.cursor { params["cursor"] = cursor }
            return params
        default:
            return nil
        }
    }
    
    var headers: [String: String]? {
        var headers: [String: String] = [:]
        
        switch self {
        case .updateMember(_, _, let accessToken), .removeMember(_, let accessToken):
            headers["Authorization"] = "Bearer \(accessToken)"
        default:
            break
        }
        
        return headers.isEmpty ? nil : headers
    }
}
