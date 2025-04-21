import Foundation
import Combine

class SearchViewModel: ObservableObject {
    // MARK: - 프로퍼티
    @Published var members: [Member] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // 페이지네이션 관련
    private var nextCursor: String?
    private var hasMoreData = true
    
    // 검색 관련
    private var currentKeyword = ""
    private var cancellables = Set<AnyCancellable>()
    
    // 서비스 및 설정
    private let container: DIContainer
    private let defaultTake = 10
    
    // 다음 페이지 존재 여부 (외부에서 접근 가능)
    var hasNext: Bool {
        return hasMoreData && nextCursor != nil
    }
    
    // MARK: - 초기화
    init(container: DIContainer) {
        self.container = container
    }
    
    // MARK: - 회원 검색
    func searchMember(keyword: String, forceRefresh: Bool = false) {
        // 이미 로딩 중이면 중복 호출 방지
        if isLoading { return }
        
        // 더 로드할 데이터가 없고 강제 새로고침이 아니면 리턴
        if !hasMoreData && !forceRefresh { return }
        
        // 새 검색어이거나 강제 새로고침이면 상태 초기화
        if currentKeyword != keyword || forceRefresh {
            members = []
            nextCursor = nil
            hasMoreData = true
            currentKeyword = keyword
        }
        
        isLoading = true
        
        let searchDto = SearchMemberDto(
            search: keyword.isEmpty ? nil : keyword,
            cursor: nextCursor,
            order: ["createdAt_DESC"],
            take: defaultTake
        )
        
        container.service.userService.searchMembers(searchDto)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    self.isLoading = false
                    
                    if case .failure(let error) = completion {
                        self.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self = self else { return }
                    
                    // 받아온 회원 추가
                    self.members.append(contentsOf: response.members)
                    
                    // 다음 페이지 커서 설정
                    self.nextCursor = response.nextCursor
                    
                    // 다음 페이지 존재 여부 체크
                    self.hasMoreData = response.nextCursor != nil
                    
                    // 결과가 없거나 기본 take 값보다 적게 받아왔다면 더 이상 데이터가 없다고 판단
                    if response.members.isEmpty || response.members.count < self.defaultTake {
                        self.hasMoreData = false
                    }
                    
                    self.isLoading = false
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - 추가 데이터 로드 (직접 호출)
    func loadMoreMembers() {
        if !isLoading && hasNext {
            searchMember(keyword: currentKeyword)
        }
    }
    
    // MARK: - 스크롤 시 자동 로드
    func loadMoreIfNeeded(currentItem: Member) {
        if isLastItem(currentItem) && hasNext && !isLoading {
            loadMoreMembers()
        }
    }
    
    // MARK: - 마지막 아이템 확인
    private func isLastItem(_ item: Member) -> Bool {
        guard let lastItem = members.last else { return false }
        return lastItem.id == item.id
    }
    
    // MARK: - 현재 검색 결과 새로고침
    func refreshCurrentSearch() {
        searchMember(keyword: currentKeyword, forceRefresh: true)
    }
}
