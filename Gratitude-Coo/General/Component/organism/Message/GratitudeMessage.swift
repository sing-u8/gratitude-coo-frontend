import SwiftUI
import SwiftData

struct GratitudeMessage: View {
    
    // Message data
    let id: Int
    let userName: String
    let userImage: UIImage?
    let message: String
    //    let likeCount: Int
    //    let commentCount: Int
    let date: String
    let messageType: MessageType
    
    var viewingUserId: Int
    var currentUserId: Int
    
    // Action closures
    var onEdit: (() -> Void)?
    var onDelete: (() -> Void)?
    var onLike: (() -> Void)?
    var onComment: (() -> Void)?
    
    // State for option menu
    @State private var showOptions = false
    
    private var isCurrentUserViewing: Bool {
        return currentUserId == viewingUserId && (messageType == .fromSelfToSelf || messageType == .fromSelfToOther)
    }
    private var isOtherUserViewing: Bool {
        return currentUserId != viewingUserId && (messageType == .fromOtherToSelf)
    }
    
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
                if isCurrentUserViewing || isOtherUserViewing {
                    messageOptionButton()
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
    
    private func messageOptionButton() -> some View {
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
    
    // Format date as YYYY.MM.DD
    private var formattedDate: String {
        
        let formatter1 = ISO8601DateFormatter()
        formatter1.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let transformedDate = formatter1.date(from: date) {
            print("Converted date: \(date) -- > \(transformedDate)")
            let formatter2 = DateFormatter()
            formatter2.dateFormat = "YYYY.MM.dd"
            return formatter2.string(from: transformedDate)
        } else {
            print("Invalid date format: \(date)")
            return formatter1.string(from: Date())
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        // Message from self to self
        GratitudeMessage(
            id: 1,
            userName: "Brandnew",
            userImage: nil,
            message: "오늘 회사에서 도움을 준 지민이에게 감사해요. 항상 친절하게 대해주셔서 감사합니다.",
            //            likeCount: 999,
            //            commentCount: 999,
            date: "2023-10-02T12:00:00Z",
            messageType: .fromSelfToSelf,
            viewingUserId: 1,
            currentUserId: 1,
        )
        
        // Message from self to other user
        GratitudeMessage(
            id: 2,
            userName: "Brandnew",
            userImage: nil,
            message: "오늘 회사에서 도움을 준 지민이에게 감사해요. 항상 친절하게 대해주셔서 감사합니다.",
            //            likeCount: 999,
            //            commentCount: 999,
            date: "2023-10-01T12:00:00Z",
            messageType: .fromSelfToOther,
            viewingUserId: 2,
            currentUserId: 1,
        )
        
        // Message from other user to self
        GratitudeMessage(
            id: 3,
            userName: "Brandnew",
            userImage: nil,
            message: "오늘 회사에서 도움을 준 지민이에게 감사해요. 항상 친절하게 대해주셔서 감사합니다.",
            //            likeCount: 999,
            //            commentCount: 999,
            date: "2023-09-23T12:00:00Z",
            messageType: .fromOtherToSelf,
            viewingUserId: 1,
            currentUserId: 1,
        )
    }
    .padding()
    .background(Color.bg)
}
