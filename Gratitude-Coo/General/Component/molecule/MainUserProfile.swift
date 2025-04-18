import SwiftUI

struct MainUserProfile: View {
    
    let userName: String
    let image: UIImage?
    let sentGratitude: Int
    let receivedGratitude: Int
    var borderColor: Color = .limeGr
    
    var body: some View {
        HStack(spacing: 20) {
            // Avatar - medium size for main screen
            Avatar(
                userName: userName,
                image: image,
                size: .mediumLarge,
                borderColor: borderColor
            )
            
            // User info
            VStack(alignment: .leading, spacing: 8) {
                // User name
                Text(userName)
                    .textStyle(size: .title3, weight: .bold, color: .txPrimary)
                
                // Gratitude stats
                HStack(spacing: 24) {
                    // Sent gratitude
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(sentGratitude)")
                            .textStyle(size: .headline, weight: .semibold, color: .hlPri)
                        Text("Sent")
                            .textStyle(size: .subheadline, weight: .semibold, color: .txPrimary)
                    }
                    
                    // Received gratitude
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(receivedGratitude)")
                            .textStyle(size: .headline, weight: .semibold, color: .hlPri)
                        Text("Received")
                            .textStyle(size: .subheadline, weight: .semibold, color: .txPrimary)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    VStack(spacing: 20) {
        // English version
        MainUserProfile(
            userName: "Nickname",
            image: nil,
            sentGratitude: 9999,
            receivedGratitude: 9999
        )
        .background(Color.itBgPri)
        .cornerRadius(12)
        
        // Korean version
        MainUserProfile(
            userName: "Nickname",
            image: nil,
            sentGratitude: 9999,
            receivedGratitude: 9999,
        )
        .background(Color.itBgPri)
        .cornerRadius(12)
        
        // Example with a small number
        MainUserProfile(
            userName: "New User",
            image: nil,
            sentGratitude: 3,
            receivedGratitude: 5
        )
        .background(Color.itBgPri)
        .cornerRadius(12)
    }
    .padding()
    .background(Color.bg)
} 
