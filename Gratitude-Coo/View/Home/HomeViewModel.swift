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
    
    // 현재 선택된 메시지 타입
    @Published var selectedType: MessageType = .fromSelfToSelf
    
    // 페이지네이션 관련
    private var selfToSelfNextCursor: String?
    private var selfToOtherNextCursor: String?
    private var otherToSelfNextCursor: String?
    
    // 더 로드할 데이터가 있는지 여부
    private var hasSelfToSelfMoreData = true
    private var hasSelfToOtherMoreData = true
    private var hasOtherToSelfMoreData = true
    
    // 기본 take 값
    private let defaultTake = 5
    
    // MARK: - Initialization
    init(container: DIContainer, modelContext: ModelContext) {
        self.container = container
        self.modelContext = modelContext
        
        // 현재 사용자 정보를 로드
        fetchCurrentUserId()
        
        // selectedType이 변경될 때마다 메시지 로드
        setupTypeObserver()
    }
    
    // MARK: - Setup
    private func setupTypeObserver() {
        // selectedType 변경 시 해당 타입의 메시지가 비어있다면 로드
        $selectedType
            .dropFirst() // 초기값 무시
            .sink { [weak self] newType in
                guard let self = self else { return }
                
                // 선택된 탭에 따른 메시지 로드
                switch newType {
                case .fromSelfToSelf:
                    if self.selfToSelfMessages.isEmpty && self.hasSelfToSelfMoreData {
                        self.loadSelfToSelfMessages(forceRefresh: true)
                    }
                case .fromSelfToOther:
                    if self.selfToOtherMessages.isEmpty && self.hasSelfToOtherMoreData {
                        self.loadSelfToOtherMessages(forceRefresh: true)
                    }
                case .fromOtherToSelf:
                    if self.otherToSelfMessages.isEmpty && self.hasOtherToSelfMoreData {
                        self.loadOtherToSelfMessages(forceRefresh: true)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Methods
    private func fetchCurrentUserId() {
        // SwiftData를 사용하여 현재 사용자 ID를 가져오는 로직
        let descriptor = FetchDescriptor<User>()
        if let existingUsers = try? modelContext.fetch(descriptor).first {
            self.currentUserId = existingUsers.id
        }
        print("Current User ID in HomeViewModel: \(self.currentUserId)")
        // 초기 데이터 로드 (현재 선택된 탭만)
        loadMessagesForCurrentType()
    }
    
    // 현재 선택된 탭에 해당하는 메시지만 로드
    func loadMessagesForCurrentType() {
        switch selectedType {
        case .fromSelfToSelf:
            loadSelfToSelfMessages(forceRefresh: true)
        case .fromSelfToOther:
            loadSelfToOtherMessages(forceRefresh: true)
        case .fromOtherToSelf:
            loadOtherToSelfMessages(forceRefresh: true)
        }
    }
    
    func loadInitialData() {
        loadSelfToSelfMessages()
        loadSelfToOtherMessages()
        loadOtherToSelfMessages()
    }
    
    // MARK: - Self to Self Messages
    func loadSelfToSelfMessages(forceRefresh: Bool = false) {
        if isSelfToSelfLoading { return }
        
        // 더 로드할 데이터가 없다면 API 호출 중단
        if !hasSelfToSelfMoreData && !forceRefresh { return }
        
        if forceRefresh {
            selfToSelfMessages = []
            selfToSelfNextCursor = nil
            hasSelfToSelfMoreData = true
        }
        
        isSelfToSelfLoading = true
        
        let dto = GetGratitudeDto(
            memberId: currentUserId,
            postType: .fromMe,  // API에 맞게 조정 필요
            cursor: selfToSelfNextCursor,
            order: ["createdAt_DESC"],
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
                    
                    print("Received messages: \(response.gratitudeList)")
                    
                    // 받아온 메시지 추가
                    self.selfToSelfMessages.append(contentsOf: response.gratitudeList)
                    
                    // 다음 페이지 커서 설정
                    self.selfToSelfNextCursor = response.nextCursor
                    
                    // 메시지가 없거나 기본 take보다 적은 경우 더 이상 데이터가 없는 것으로 간주
                    if response.gratitudeList.isEmpty || response.gratitudeList.count < self.defaultTake {
                        self.hasSelfToSelfMoreData = false
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Self to Other Messages
    func loadSelfToOtherMessages(forceRefresh: Bool = false) {
        if isSelfToOtherLoading { return }
        
        // 더 로드할 데이터가 없다면 API 호출 중단
        if !hasSelfToOtherMoreData && !forceRefresh { return }
        
        if forceRefresh {
            selfToOtherMessages = []
            selfToOtherNextCursor = ""
            hasSelfToOtherMoreData = true
        }
        
        isSelfToOtherLoading = true
        
        let dto = GetGratitudeDto(
            memberId: currentUserId,
            postType: .toOther,  // API에 맞게 조정 필요
            cursor: selfToOtherNextCursor,
            order: ["createdAt_DESC"],
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
                    
                    // 받아온 메시지 추가
                    self.selfToOtherMessages.append(contentsOf: response.gratitudeList)
                    
                    // 다음 페이지 커서 설정
                    self.selfToOtherNextCursor = response.nextCursor
                    
                    // 메시지가 없거나 기본 take보다 적은 경우 더 이상 데이터가 없는 것으로 간주
                    if response.gratitudeList.isEmpty || response.gratitudeList.count < self.defaultTake {
                        self.hasSelfToOtherMoreData = false
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Other to Self Messages
    func loadOtherToSelfMessages(forceRefresh: Bool = false) {
        if isOtherToSelfLoading { return }
        
        // 더 로드할 데이터가 없다면 API 호출 중단
        if !hasOtherToSelfMoreData && !forceRefresh { return }
        
        if forceRefresh {
            otherToSelfMessages = []
            otherToSelfNextCursor = nil
            hasOtherToSelfMoreData = true
        }
        
        isOtherToSelfLoading = true
        
        let dto = GetGratitudeDto(
            memberId: currentUserId,
            postType: .fromOther,  // API에 맞게 조정 필요
            cursor: otherToSelfNextCursor,
            order: ["createdAt_DESC"],
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
                    
                    // 받아온 메시지 추가
                    self.otherToSelfMessages.append(contentsOf: response.gratitudeList)
                    
                    // 다음 페이지 커서 설정
                    self.otherToSelfNextCursor = response.nextCursor
                    
                    // 메시지가 없거나 기본 take보다 적은 경우 더 이상 데이터가 없는 것으로 간주
                    if response.gratitudeList.isEmpty || response.gratitudeList.count < self.defaultTake {
                        self.hasOtherToSelfMoreData = false
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Load More (for pagination)
    func loadMoreIfNeeded(for type: MessageType, currentItem: GratitudeResponse) {
        switch type {
        case .fromSelfToSelf:
            if isLastItem(currentItem, in: selfToSelfMessages) && hasSelfToSelfMoreData {
                loadSelfToSelfMessages()
            }
        case .fromSelfToOther:
            if isLastItem(currentItem, in: selfToOtherMessages) && hasSelfToOtherMoreData {
                loadSelfToOtherMessages()
            }
        case .fromOtherToSelf:
            if isLastItem(currentItem, in: otherToSelfMessages) && hasOtherToSelfMoreData {
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
    
    // 선택된 타입만 새로고침
    func refreshCurrentType() {
        switch selectedType {
        case .fromSelfToSelf:
            loadSelfToSelfMessages(forceRefresh: true)
        case .fromSelfToOther:
            loadSelfToOtherMessages(forceRefresh: true)
        case .fromOtherToSelf:
            loadOtherToSelfMessages(forceRefresh: true)
        }
    }
    
    // 선택된 타입 변경
    func setSelectedType(_ type: MessageType) {
        selectedType = type
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
    
    func hasNextPage(for type: MessageType) -> Bool {
        switch type {
        case .fromSelfToSelf:
            return hasSelfToSelfMoreData
        case .fromSelfToOther:
            return hasSelfToOtherMoreData
        case .fromOtherToSelf:
            return hasOtherToSelfMoreData
        }
    }
} 
