import Foundation
import Combine
import SwiftData
import SwiftUI

class UpdateGratitudeViewModel: ObservableObject {
    enum SendState: Equatable {
        case idle
        case sending
        case success
        case failure(String)
    }
    
    // MARK: - Properties
    private let container: DIContainer
    private let modelContext: ModelContext
    private var cancellables = Set<AnyCancellable>()
    
    // 현재 사용자 정보
    @Published var currentUserName: String = ""
    @Published var currentUserImage: UIImage?
    private var currentUserId: Int = 0
    
    // 수신자 정보
    @Published var recipient: Member?
    
    // 메시지 내용
    @Published var messageContent: String = ""
    
    // 설정
    @Published var isAnonymous: Bool = false
    @Published var visibility: Visibility = .PRIVATE
    
    // 상태
    @Published var sendState: SendState = .idle
    
    // 수정할 메시지 ID
    private let gratitudeId: Int
    
    // 메시지 보낼 수 있는지 여부
    var canSendMessage: Bool {
        return !messageContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // 글자 수 제한
    let maxCharacterCount = 1000
    
    // MARK: - Initialization
    init(container: DIContainer, modelContext: ModelContext, gratitudeMessage: GratitudeResponse) {
        self.container = container
        self.modelContext = modelContext
        self.gratitudeId = gratitudeMessage.id
        
        // 기존 메시지 데이터로 초기화
        self.messageContent = gratitudeMessage.contents
        self.isAnonymous = gratitudeMessage.isAnonymous
        self.visibility = gratitudeMessage.visibility
        self.recipient = gratitudeMessage.recipient
        
        loadCurrentUser()
    }
    
    private func loadCurrentUser() {
        let descriptor = FetchDescriptor<User>()
        if let user = try? modelContext.fetch(descriptor).first {
            self.currentUserId = user.id
            self.currentUserName = user.nickname ?? "User"
        }
    }
    
    // MARK: - Methods
    func updateGratitudeMessage() {
        guard canSendMessage else { return }
        
        sendState = .sending
        
        let dto = UpdateGratitudeDto(
            contents: messageContent,
            isAnonymous: isAnonymous,
            visibility: visibility
        )
        
        container.service.gratitudeService.updateGratitude(id: gratitudeId, dto: dto)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    
                    if case .failure(let error) = completion {
                        self.sendState = .failure(error.localizedDescription)
                    }
                },
                receiveValue: { [weak self] _ in
                    guard let self = self else { return }
                    self.sendState = .success
                }
            )
            .store(in: &cancellables)
    }
    
    func reset() {
        sendState = .idle
    }
} 
