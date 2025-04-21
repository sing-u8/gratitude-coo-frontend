import SwiftUI

struct UserSearchItem: View {
    let userId: Int
    let nickname: String
    let username: String
    let image: UIImage?
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
                    size: .mediumSmall,
                )
                
                // User info
                VStack(alignment: .leading, spacing: 2) {
                    // Nickname
                    Text(nickname)
                        .textStyle(size: .title3, weight: .bold, color: .txPrimary)
                    
                    // Username (optional)
                    Text(username)
                        .textStyle(size: .body, weight: .regular, color: .txPrimary)
                }
                
                Spacer()
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
            LazyVStack(spacing: 8) {
                ForEach(users) { user in
                    UserSearchItem(
                        userId: user.id,
                        nickname: user.nickname,
                        username: user.username,
                        image: user.image,
                        onTap: {
                            selectedUser = user
                        }
                    )
                }
            }
        }
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
        UserSearchItem(
            userId: 1,
            nickname: "Nickname",
            username: "Username",
            image: nil
        )
        .background(Color.itBgPri)
        .cornerRadius(8)
        
        // Single selected item
        UserSearchItem(
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
