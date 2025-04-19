import SwiftUI

struct GratitudeMessage: View {
    
    
    // Message data
    let userName: String
    let userImage: UIImage?
    let message: String
    //    let likeCount: Int
    //    let commentCount: Int
    let date: Date
    let messageType: MessageType
    
    // Action closures
    var onEdit: (() -> Void)?
    var onDelete: (() -> Void)?
    var onLike: (() -> Void)?
    var onComment: (() -> Void)?
    
    // State for option menu
    @State private var showOptions = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with user info
            HStack {
                // Conditional prefix (From/To) based on message type
                if messageType != .fromSelfToSelf {
                    Text(messageType.prefix)
                        .textStyle(size: .body, weight: .medium, color: .txPrimary)
                        .padding(.trailing, 0)
                }
                
                // User profile
                GPUserProfile(
                    userName: userName,
                    image: userImage
                )
                
                Spacer()
                
                // Options button (only for messages written by the user)
                if messageType == .fromSelfToSelf || messageType == .fromSelfToOther {
                    Button {
                        showOptions = true
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.txPrimary)
                            .font(.system(size: 20))
                            .padding(8)
                            .background(Circle().fill(Color.clear))
                    }
                    .confirmationDialog(
                        "Message Options",
                        isPresented: $showOptions,
                        titleVisibility: .hidden
                    ) {
                        Button("Edit") {
                            onEdit?()
                        }
                        
                        Button("Delete", role: .destructive) {
                            onDelete?()
                        }
                        
                        Button("Cancel", role: .cancel) {
                            showOptions = false
                        }
                    }
                }
            }
            
            // Message content
            Text(message)
                .textStyle(size: .body, weight: .regular, color: .txPrimary)
                .padding(.leading, 0)
            
            // Footer with engagement counts and date
            HStack {
                // Like button
                //                Button {
                //                    onLike?()
                //                } label: {
                //                    HStack(spacing: 4) {
                //                        Image(systemName: "heart")
                //                            .foregroundColor(.red)
                //                            .font(.system(size: 20))
                //                        Text("\(likeCount)")
                //                            .textStyle(size: .footnote, weight: .regular, color: .txPrimary)
                //                    }
                //                }
                
                /*
                 Spacer().frame(width: 16)
                 
                 // Comment button
                 Button {
                 onComment?()
                 } label: {
                 HStack(spacing: 4) {
                 Image(systemName: "bubble.left")
                 .font(.system(size: 20))
                 .foregroundColor(.txSecondary)
                 Text("\(commentCount)")
                 .textStyle(size: .footnote, weight: .regular, color: .txPrimary)
                 }
                 }
                 */
                
                Spacer()
                
                // Date
                Text(formattedDate)
                    .textStyle(size: .footnote, weight: .medium, color: .caption)
            }
        }
        .padding(16)
        .background(Color.itBgPri)
        .cornerRadius(12)
    }
    
    // Format date as YYYY.MM.DD
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM.dd"
        return formatter.string(from: date)
    }
}

// For the purpose of this example, assume GPUserProfile is already defined
// but let's create a simple placeholder here
struct GPUserProfileE: View {
    let userName: String
    let image: UIImage?
    
    var body: some View {
        HStack(spacing: 8) {
            // Avatar (small size)
            Avatar(
                userName: userName,
                image: image,
                size: .small,
                borderColor: .limeGr
            )
            
            // User name
            Text(userName)
                .textStyle(size: .body, weight: .medium, color: .txPrimary)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        // Message from self to self
        GratitudeMessage(
            userName: "Brandnew",
            userImage: nil,
            message: "오늘 회사에서 도움을 준 지민이에게 감사해요. 항상 친절하게 대해주셔서 감사합니다.",
            //            likeCount: 999,
            //            commentCount: 999,
            date: Date(),
            messageType: .fromSelfToSelf
        )
        
        // Message from self to other user
        GratitudeMessage(
            userName: "Brandnew",
            userImage: nil,
            message: "오늘 회사에서 도움을 준 지민이에게 감사해요. 항상 친절하게 대해주셔서 감사합니다.",
            //            likeCount: 999,
            //            commentCount: 999,
            date: Date(),
            messageType: .fromSelfToOther
        )
        
        // Message from other user to self
        GratitudeMessage(
            userName: "Brandnew",
            userImage: nil,
            message: "오늘 회사에서 도움을 준 지민이에게 감사해요. 항상 친절하게 대해주셔서 감사합니다.",
            //            likeCount: 999,
            //            commentCount: 999,
            date: Date(),
            messageType: .fromOtherToSelf
        )
    }
    .padding()
    .background(Color.bg)
}
