import Foundation
import Combine

protocol UserServiceProtocol {
    func findAllMembers() -> AnyPublisher<[Member], UserError>
    func findOneMember(id: Int) -> AnyPublisher<Member, UserError>
    func updateMember(id: Int, dto: UpdateMemberDto) -> AnyPublisher<Member, UserError>
    func removeMember(id: Int) -> AnyPublisher<Bool, UserError>
    func searchMembers(_ dto: SearchMemberDto) -> AnyPublisher<SearchMemberResponseDto, UserError>
    func updateProfile(id: Int, dto: UpdateMemberProfileDto) -> AnyPublisher<Member, UserError>
}

class UserService: UserServiceProtocol {
    private let networkService: NetworkServiceProtocol
    private let tokenManager: TokenManagerProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService(),
         tokenManager: TokenManagerProtocol = TokenManager()) {
        self.networkService = networkService
        self.tokenManager = tokenManager
    }
    
    func findAllMembers() -> AnyPublisher<[Member], UserError> {
        let endpoint = UserEndpoint.findAllMembers
        return networkService.request(endpoint)
            .mapError { UserError.mapFromNetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    func findOneMember(id: Int) -> AnyPublisher<Member, UserError> {
        let endpoint = UserEndpoint.findOneMember(id: id)
        return networkService.request(endpoint)
            .mapError { UserError.mapFromNetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    func updateMember(id: Int, dto: UpdateMemberDto) -> AnyPublisher<Member, UserError> {
        guard let accessToken = try? tokenManager.getAccessToken() else {
            return Fail(error: UserError.unauthorized).eraseToAnyPublisher()
        }
        
        let endpoint = UserEndpoint.updateMember(id: id, dto: dto, accessToken: accessToken)
        return networkService.request(endpoint)
            .mapError { UserError.mapFromNetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    func removeMember(id: Int) -> AnyPublisher<Bool, UserError> {
        guard let accessToken = try? tokenManager.getAccessToken() else {
            return Fail(error: UserError.unauthorized).eraseToAnyPublisher()
        }
        
        let endpoint = UserEndpoint.removeMember(id: id, accessToken: accessToken)
        return networkService.request(endpoint)
            .map { (_: [String: Never]) in true }
            .mapError { UserError.mapFromNetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    func searchMembers(_ dto: SearchMemberDto) -> AnyPublisher<SearchMemberResponseDto, UserError> {
        let endpoint = UserEndpoint.searchMembers(dto)
        return networkService.request(endpoint)
            .mapError { UserError.mapFromNetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    func updateProfile(id: Int, dto: UpdateMemberProfileDto) -> AnyPublisher<Member, UserError> {
        let updateDto = UpdateMemberDto(
            email: nil,
            password: nil,
            name: dto.name,
            nickname: dto.nickname,
            profile: dto.profile
        )
        return updateMember(id: id, dto: updateDto)
    }
}

// MARK: - Stub
class StubUserService: UserServiceProtocol {
    func findAllMembers() -> AnyPublisher<[Member], UserError> {
        return Just([])
            .setFailureType(to: UserError.self)
            .eraseToAnyPublisher()
    }
    
    func findOneMember(id: Int) -> AnyPublisher<Member, UserError> {
        return Just(Member(id: id, email: "", name: "", nickname: "", profile: ""))
            .setFailureType(to: UserError.self)
            .eraseToAnyPublisher()
    }
    
    func updateMember(id: Int, dto: UpdateMemberDto) -> AnyPublisher<Member, UserError> {
        return Just(Member(id: id, email: "", name: "", nickname: "", profile: ""))
            .setFailureType(to: UserError.self)
            .eraseToAnyPublisher()
    }
    
    func removeMember(id: Int) -> AnyPublisher<Bool, UserError> {
        return Just(true)
            .setFailureType(to: UserError.self)
            .eraseToAnyPublisher()
    }
    
    func searchMembers(_ dto: SearchMemberDto) -> AnyPublisher<SearchMemberResponseDto, UserError> {
        return Just(SearchMemberResponseDto(members: [], nextCursor: nil, count: 0))
            .setFailureType(to: UserError.self)
            .eraseToAnyPublisher()
    }
    
    func updateProfile(id: Int, dto: UpdateMemberProfileDto) -> AnyPublisher<Member, UserError> {
        return Just(Member(id: id, email: "", name: "", nickname: "", profile: ""))
            .setFailureType(to: UserError.self)
            .eraseToAnyPublisher()
    }
}
