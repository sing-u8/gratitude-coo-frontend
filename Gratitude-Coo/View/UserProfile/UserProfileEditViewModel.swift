import Foundation
import Combine
import SwiftData
import UIKit

class UserProfileEditViewModel: ObservableObject {
    
    enum Action {
        case updateProfile(name: String, nickname: String, image: UIImage?)
    }
    
    @Published var isLoading: Bool = false
    @Published var error: UserError?
    @Published var isSuccessful: Bool = false
    
    private var container: DIContainer
    private var modelContext: ModelContext
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer, modelContext: ModelContext) {
        self.container = container
        self.modelContext = modelContext
    }
    
    func send(action: Action) {
        switch action {
        case .updateProfile(let name, let nickname, let image):
            updateProfile(name: name, nickname: nickname, image: image)
        }
    }
    
    private func updateProfile(name: String, nickname: String, image: UIImage?) {
        guard let user = try? modelContext.fetch(FetchDescriptor<User>()).first else {
            self.error = .memberNotFound
            return
        }
        
        isLoading = true
        
        // 이미지 처리 로직 (실제로는 이미지를 서버에 업로드한 후 URL을 받아야 함)
        var profileImageUrl: String? = user.profileImage
        
        // 여기서는 간단하게 이미지가 있으면 "image_url"로 설정
        if image != nil {
            profileImageUrl = ""
        }
        
        let dto = UpdateMemberProfileDto(
            profile: profileImageUrl,
            name: name,
            nickname: nickname
        )
        
        container.service.userService.updateProfile(id: user.id, dto: dto)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error
                }
            } receiveValue: { [weak self] member in
                guard let self = self else { return }
                
                // SwiftData에 저장된 User 업데이트
                user.name = member.name
                user.nickname = member.nickname
                user.profileImage = member.profile
                
                try? self.modelContext.save()
                self.isSuccessful = true
            }
            .store(in: &subscriptions)
    }
} 
