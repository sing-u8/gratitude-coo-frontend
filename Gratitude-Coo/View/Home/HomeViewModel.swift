import Foundation
import Combine
import SwiftUI
import SwiftData

class HomeViewModel: ObservableObject {
    // MARK: - Properties
    private let container: DIContainer
    private let modelContext: ModelContext
    private var cancellables = Set<AnyCancellable>()
    
    // 현재 사용자 ID
    private var currentUserId: Int = 0
    
    // 메시지 타입별 상태 관리
    @Published var selfToSelfMessages: [GratitudeResponse] = []
    @Published var selfToOtherMessages: [GratitudeResponse] = []
    @Published var otherToSelfMessages: [GratitudeResponse] = []
    
    // 로딩 상태
    @Published var isSelfToSelfLoading = false
    @Published var isSelfToOtherLoading = false
    @Published var isOtherToSelfLoading = false
    
    // 에러 상태
    @Published var errorMessage: String?
    
    // 페이지네이션 관련
    private var selfToSelfNextCursor: String?
    private var selfToOtherNextCursor: String?
    private var otherToSelfNextCursor: String?
    
    // 기본 take 값
    private let defaultTake = 5
    
    // MARK: - Initialization
    init(container: DIContainer, modelContext: ModelContext) {
        self.container = container
        self.modelContext = modelContext
        
//        fetchCurrentUserId()
    }
    
    // MARK: - Methods
    private func fetchCurrentUserId() {
        // SwiftData를 사용하여 현재 사용자 ID를 가져오는 로직
        // 실제 구현에서는 로그인된 사용자의 ID를 가져와야 함
        // 임시로 하드코딩
        self.currentUserId = 1
        
        // 초기 데이터 로드
        loadInitialData()
    }
    
    func loadInitialData() {
        loadSelfToSelfMessages()
        loadSelfToOtherMessages()
        loadOtherToSelfMessages()
    }
    
    // MARK: - Self to Self Messages
    func loadSelfToSelfMessages(forceRefresh: Bool = false) {
        if isSelfToSelfLoading { return }
        
        if forceRefresh {
            selfToSelfMessages = []
            selfToSelfNextCursor = nil
        }
        
        isSelfToSelfLoading = true
        
        let dto = GetGratitudeDto(
            memberId: currentUserId,
            postType: .fromMe,  // API에 맞게 조정 필요
            cursor: selfToSelfNextCursor,
            order: ["createdAt:desc"],
            take: defaultTake
        )
        
        container.service.gratitudeService.getGratitudeList(dto)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    self.isSelfToSelfLoading = false
                    
                    if case .failure(let error) = completion {
                        self.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self = self else { return }
                    self.selfToSelfMessages.append(contentsOf: response.gratitudeList)
                    self.selfToSelfNextCursor = response.nextCursor
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Self to Other Messages
    func loadSelfToOtherMessages(forceRefresh: Bool = false) {
        if isSelfToOtherLoading { return }
        
        if forceRefresh {
            selfToOtherMessages = []
            selfToOtherNextCursor = nil
        }
        
        isSelfToOtherLoading = true
        
        let dto = GetGratitudeDto(
            memberId: currentUserId,
            postType: .toOther,  // API에 맞게 조정 필요
            cursor: selfToOtherNextCursor,
            order: ["createdAt:desc"],
            take: defaultTake
        )
        
        container.service.gratitudeService.getGratitudeList(dto)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    self.isSelfToOtherLoading = false
                    
                    if case .failure(let error) = completion {
                        self.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self = self else { return }
                    self.selfToOtherMessages.append(contentsOf: response.gratitudeList)
                    self.selfToOtherNextCursor = response.nextCursor
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Other to Self Messages
    func loadOtherToSelfMessages(forceRefresh: Bool = false) {
        if isOtherToSelfLoading { return }
        
        if forceRefresh {
            otherToSelfMessages = []
            otherToSelfNextCursor = nil
        }
        
        isOtherToSelfLoading = true
        
        let dto = GetGratitudeDto(
            memberId: currentUserId,
            postType: .fromOther,  // API에 맞게 조정 필요
            cursor: otherToSelfNextCursor,
            order: ["createdAt:desc"],
            take: defaultTake
        )
        
        container.service.gratitudeService.getGratitudeList(dto)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    self.isOtherToSelfLoading = false
                    
                    if case .failure(let error) = completion {
                        self.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self = self else { return }
                    self.otherToSelfMessages.append(contentsOf: response.gratitudeList)
                    self.otherToSelfNextCursor = response.nextCursor
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Load More (for pagination)
    func loadMoreIfNeeded(for type: MessageType, currentItem: GratitudeResponse) {
        switch type {
        case .fromSelfToSelf:
            if isLastItem(currentItem, in: selfToSelfMessages) && selfToSelfNextCursor != nil {
                loadSelfToSelfMessages()
            }
        case .fromSelfToOther:
            if isLastItem(currentItem, in: selfToOtherMessages) && selfToOtherNextCursor != nil {
                loadSelfToOtherMessages()
            }
        case .fromOtherToSelf:
            if isLastItem(currentItem, in: otherToSelfMessages) && otherToSelfNextCursor != nil {
                loadOtherToSelfMessages()
            }
        }
    }
    
    private func isLastItem(_ item: GratitudeResponse, in array: [GratitudeResponse]) -> Bool {
        guard let lastItem = array.last else { return false }
        return item.id == lastItem.id
    }
    
    // MARK: - Refresh All
    func refreshAll() {
        loadSelfToSelfMessages(forceRefresh: true)
        loadSelfToOtherMessages(forceRefresh: true)
        loadOtherToSelfMessages(forceRefresh: true)
    }
    
    // MARK: - Helper Methods
    func isLoading(for type: MessageType) -> Bool {
        switch type {
        case .fromSelfToSelf:
            return isSelfToSelfLoading
        case .fromSelfToOther:
            return isSelfToOtherLoading
        case .fromOtherToSelf:
            return isOtherToSelfLoading
        }
    }
    
    func messages(for type: MessageType) -> [GratitudeResponse] {
        switch type {
        case .fromSelfToSelf:
            return selfToSelfMessages
        case .fromSelfToOther:
            return selfToOtherMessages
        case .fromOtherToSelf:
            return otherToSelfMessages
        }
    }
} 
