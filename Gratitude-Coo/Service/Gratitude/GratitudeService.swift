import Foundation
import Combine

protocol GratitudeServiceProtocol {
    func createGratitude(_ dto: CreateGratitudeDto) -> AnyPublisher<GratitudeResponse, GratitudeError>
    func updateGratitude(id: Int, dto: UpdateGratitudeDto) -> AnyPublisher<UpdateGratitudeResponse, GratitudeError>
    func deleteGratitude(id: Int) -> AnyPublisher<Int, GratitudeError>
    func getGratitudeList(_ dto: GetGratitudeDto) -> AnyPublisher<GetGratitudeResponse, GratitudeError>
    func toggleGratitudeLike(id: Int) -> AnyPublisher<GratitudeLikeResponse, GratitudeError>
    func getGratitudeLikeCount(id: Int) -> AnyPublisher<GratitudeLikeCountResponse, GratitudeError>
    func getGratitudeCount(id: Int) -> AnyPublisher<GratitudeCountResponse, GratitudeError>
}

class GratitudeService: GratitudeServiceProtocol {
    private let networkService: NetworkServiceProtocol
    private let tokenManager: TokenManagerProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService(),
         tokenManager: TokenManagerProtocol = TokenManager()) {
        self.networkService = networkService
        self.tokenManager = tokenManager
    }
    
    func createGratitude(_ dto: CreateGratitudeDto) -> AnyPublisher<GratitudeResponse, GratitudeError> {
        guard let accessToken = try? tokenManager.getAccessToken() else {
            return Fail(error: GratitudeError.unauthorized).eraseToAnyPublisher()
        }
        
        let endpoint = GratitudeEndpoint.createGratitude(dto: dto, accessToken: accessToken)
        return networkService.request(endpoint)
            .mapError { GratitudeError.mapFromNetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    func updateGratitude(id: Int, dto: UpdateGratitudeDto) -> AnyPublisher<UpdateGratitudeResponse, GratitudeError> {
        guard let accessToken = try? tokenManager.getAccessToken() else {
            return Fail(error: GratitudeError.unauthorized).eraseToAnyPublisher()
        }
        
        let endpoint = GratitudeEndpoint.updateGratitude(id: id, dto: dto, accessToken: accessToken)
        return networkService.request(endpoint)
            .mapError { GratitudeError.mapFromNetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    func deleteGratitude(id: Int) -> AnyPublisher<Int, GratitudeError> {
        guard let accessToken = try? tokenManager.getAccessToken() else {
            print("GratitudeService - 토큰 없음 오류")
            return Fail(error: GratitudeError.unauthorized).eraseToAnyPublisher()
        }
        
        print("GratitudeService - 삭제 요청: ID \(id)")
        let endpoint = GratitudeEndpoint.deleteGratitude(id: id, accessToken: accessToken)
        
        return networkService.request(endpoint)
            .mapError { error in 
                print("GratitudeService - 네트워크 에러: \(error)")
                return GratitudeError.mapFromNetworkError(error)
            }
            .handleEvents(receiveOutput: { success in
                print("GratitudeService - 삭제 성공: \(success)")
            })
            .eraseToAnyPublisher()
    }
    
    func getGratitudeList(_ dto: GetGratitudeDto) -> AnyPublisher<GetGratitudeResponse, GratitudeError> {
        guard let accessToken = try? tokenManager.getAccessToken() else {
            return Fail(error: GratitudeError.unauthorized).eraseToAnyPublisher()
        }
        
        print("getGratitudeList -- dto: \(dto.memberId) \(String(describing: dto.cursor)) \(dto.order) \(dto.take) \(String(describing: dto.postType?.rawValue))")
        
        let endpoint = GratitudeEndpoint.getGratitudeList(dto: dto, accessToken: accessToken)
        return networkService.request(endpoint)
            .mapError { GratitudeError.mapFromNetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    func toggleGratitudeLike(id: Int) -> AnyPublisher<GratitudeLikeResponse, GratitudeError> {
        guard let accessToken = try? tokenManager.getAccessToken() else {
            return Fail(error: GratitudeError.unauthorized).eraseToAnyPublisher()
        }
        
        let endpoint = GratitudeEndpoint.toggleGratitudeLike(id: id, accessToken: accessToken)
        return networkService.request(endpoint)
            .mapError { GratitudeError.mapFromNetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    func getGratitudeLikeCount(id: Int) -> AnyPublisher<GratitudeLikeCountResponse, GratitudeError> {
        guard let accessToken = try? tokenManager.getAccessToken() else {
            return Fail(error: GratitudeError.unauthorized).eraseToAnyPublisher()
        }
        
        let endpoint = GratitudeEndpoint.getGratitudeLikeCount(id: id, accessToken: accessToken)
        return networkService.request(endpoint)
            .mapError { GratitudeError.mapFromNetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    func getGratitudeCount(id: Int) -> AnyPublisher<GratitudeCountResponse, GratitudeError> {
        guard let accessToken = try? tokenManager.getAccessToken() else {
            return Fail(error: GratitudeError.unauthorized).eraseToAnyPublisher()
        }
        let endpoint = GratitudeEndpoint.getGratitudeCount(id: id, accessToken: accessToken)
        return networkService.request(endpoint)
            .mapError { GratitudeError.mapFromNetworkError($0) }
            .eraseToAnyPublisher()
            
    }
}

// MARK: - Stub
class StubGratitudeService: GratitudeServiceProtocol {
    func createGratitude(_ dto: CreateGratitudeDto) -> AnyPublisher<GratitudeResponse, GratitudeError> {
        let stubMember = Member(id: 1, email: "test@example.com", name: "Test User", nickname: "Test", profile: nil)
        
        return Just(GratitudeResponse(
            id: 1,
            contents: dto.contents,
            recipient: stubMember,
            author: stubMember,
            isAnonymous: dto.isAnonymous,
            visibility: dto.visibility,
            createdAt: "2023-10-01T12:00:00Z",
        ))
        .setFailureType(to: GratitudeError.self)
        .eraseToAnyPublisher()
    }
    
    func updateGratitude(id: Int, dto: UpdateGratitudeDto) -> AnyPublisher<UpdateGratitudeResponse, GratitudeError> {
        
        return Just(UpdateGratitudeResponse(
            id: id,
            contents: dto.contents ?? "감사합니다",
            isAnonymous: dto.isAnonymous ?? false,
            visibility: dto.visibility ?? .PRIVATE
        ))
        .setFailureType(to: GratitudeError.self)
        .eraseToAnyPublisher()
    }
    
    func deleteGratitude(id: Int) -> AnyPublisher<Int, GratitudeError> {
        return Just(1)
            .setFailureType(to: GratitudeError.self)
            .eraseToAnyPublisher()
    }
    
    func getGratitudeList(_ dto: GetGratitudeDto) -> AnyPublisher<GetGratitudeResponse, GratitudeError> {
        return Just(GetGratitudeResponse(
            gratitudeList: [],
            nextCursor: nil,
            count: 0
        ))
        .setFailureType(to: GratitudeError.self)
        .eraseToAnyPublisher()
    }
    
    func toggleGratitudeLike(id: Int) -> AnyPublisher<GratitudeLikeResponse, GratitudeError> {
        return Just(GratitudeLikeResponse(isLiked: true))
            .setFailureType(to: GratitudeError.self)
            .eraseToAnyPublisher()
    }
    
    func getGratitudeLikeCount(id: Int) -> AnyPublisher<GratitudeLikeCountResponse, GratitudeError> {
        return Just(GratitudeLikeCountResponse(count: 0))
            .setFailureType(to: GratitudeError.self)
            .eraseToAnyPublisher()
    }
    
    func getGratitudeCount(id: Int) -> AnyPublisher<GratitudeCountResponse, GratitudeError> {
        return Just(GratitudeCountResponse(sentCount: 0, receivedCount: 0))
            .setFailureType(to: GratitudeError.self)
            .eraseToAnyPublisher()
    }
}
