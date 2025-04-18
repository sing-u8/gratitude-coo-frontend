import SwiftUI

struct UserSearchItemView: View {
    let userId: Int
    let nickname: String
    let username: String
    let image: UIImage?
    var isSelected: Bool = false
    var onTap: (() -> Void)?
    
    var body: some View {
        Button {
            onTap?()
        } label: {
            HStack(spacing: 12) {
                // User avatar
                Avatar(
                    userName: nickname,
                    image: image,
                    size: .small,
                    borderColor: isSelected ? .hlPri : .limeGr
                )
                
                // User info
                VStack(alignment: .leading, spacing: 2) {
                    // Nickname
                    Text(nickname)
                        .textStyle(size: .body, weight: .medium, color: .txPrimary)
                    
                    // Username (optional)
                    Text(username)
                        .textStyle(size: .subheadline, weight: .regular, color: .txSecondary)
                }
                
                Spacer()
                
                // Selection indicator (if needed)
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.hlPri)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .contentShape(Rectangle()) // Make the entire row tappable
        }
        .buttonStyle(PlainButtonStyle()) // Remove default button styling
    }
}

struct UserSearchListViewExample: View {
    let users: [UserSearchData]
    @Binding var selectedUser: UserSearchData?
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(users) { user in
                    UserSearchItemView(
                        userId: user.id,
                        nickname: user.nickname,
                        username: user.username,
                        image: user.image,
                        isSelected: selectedUser?.id == user.id,
                        onTap: {
                            selectedUser = user
                        }
                    )
                    
                    if user.id != users.last?.id {
                        Divider()
                            .padding(.leading, 60)
                    }
                }
            }
        }
        .background(Color.itBgPri)
        .cornerRadius(12)
    }
}

// Sample data structure
struct UserSearchData: Identifiable {
    let id: Int
    let nickname: String
    let username: String
    let image: UIImage?
}

#Preview {
    let sampleUsers = [
        UserSearchData(id: 1, nickname: "Nickname", username: "Username", image: nil),
        UserSearchData(id: 2, nickname: "Jane Doe", username: "@janedoe", image: nil),
        UserSearchData(id: 3, nickname: "John Smith", username: "@johnsmith", image: nil),
        UserSearchData(id: 4, nickname: "Sara Parker", username: "@sara_p", image: nil)
    ]
    
    VStack(spacing: 20) {
        // Single item
        UserSearchItemView(
            userId: 1,
            nickname: "Nickname",
            username: "Username",
            image: nil
        )
        .background(Color.itBgPri)
        .cornerRadius(8)
        
        // Single selected item
        UserSearchItemView(
            userId: 2,
            nickname: "Jane Doe",
            username: "@janedoe",
            image: nil,
            onTap: {}
        )
        .background(Color.itBgPri)
        .cornerRadius(8)
        
        // Full list
        UserSearchListViewExample(
            users: sampleUsers,
            selectedUser: .constant(sampleUsers[1])
        )
    }
    .padding()
    .background(Color.bg)
}
