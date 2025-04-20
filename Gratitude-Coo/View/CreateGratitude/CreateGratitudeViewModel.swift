import Foundation
import Combine
import SwiftData
import SwiftUI

class CreateGratitudeViewModel: ObservableObject {
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
    
    // 메시지 보낼 수 있는지 여부
    var canSendMessage: Bool {
        return !messageContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // 글자 수 제한
    let maxCharacterCount = 1000
    
    // MARK: - Initialization
    init(container: DIContainer, modelContext: ModelContext, recipient: Member? = nil) {
        self.container = container
        self.modelContext = modelContext
        self.recipient = recipient
        
        loadCurrentUser()
    }
    
    private func loadCurrentUser() {
        let descriptor = FetchDescriptor<User>()
        if let user = try? modelContext.fetch(descriptor).first {
            self.currentUserId = user.id
            self.currentUserName = user.nickname ?? "사용자"
            // 여기서 사용자 이미지를 로드할 수 있습니다 (있는 경우)
        }
    }
    
    // MARK: - Methods
    func sendGratitudeMessage() {
        guard canSendMessage else { return }
        guard let recipient = recipient else {
            self.sendState = .failure("수신자를 선택해주세요")
            return
        }
        
        sendState = .sending
        
        let dto = CreateGratitudeDto(
            recipientId: recipient.id,
            authorId: currentUserId,
            contents: messageContent,
            isAnonymous: isAnonymous,
            visibility: visibility
        )
        
        container.service.gratitudeService.createGratitude(dto)
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
        messageContent = ""
        isAnonymous = false
        visibility = .PRIVATE
        sendState = .idle
    }
    
    // 자기 자신에게 메시지 보내기
    func setSelfAsRecipient() {
        let descriptor = FetchDescriptor<User>()
        if let user = try? modelContext.fetch(descriptor).first {
            // 실제 API에서는 Member 객체를 사용하여 recipient로 설정
            self.recipient = Member(
                id: user.id,
                email: user.email,
                name: user.name ?? "",
                nickname: user.nickname ?? "",
                profile: user.profileImage
            )
        }
    }
} 
