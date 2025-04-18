import SwiftUI

struct GPUserProfile: View {
    enum Alignment {
        case horizontal
        case vertical
    }
    
    let userName: String
    let image: UIImage?
    var alignment: Alignment = .horizontal
    var borderColor: Color = .limeGr
    
    var body: some View {
        Group {
            if alignment == .horizontal {
                horizontalLayout
            } else {
                verticalLayout
            }
        }
    }
    
    private var horizontalLayout: some View {
        HStack(spacing: 8) {
            // Avatar
            Avatar(
                userName: userName,
                image: image,
                size: .small,
                borderColor: borderColor
            )
            
            Text(userName)
                .textStyle(size: .body, weight: .medium, color: .txPrimary)
        }
    }
    
    private var verticalLayout: some View {
        VStack(spacing: 8) {
            Avatar(
                userName: userName,
                image: image,
                size: .small,
                borderColor: borderColor
            )
            
            Text(userName)
                .textStyle(size: .body, weight: .medium, color: .txPrimary)
        }
    }
}

// Example of usage in a gratitude message
struct GratitudeMessageViewExample: View {
    let message: String
    let userName: String
    let userImage: UIImage?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // User profile
            GPUserProfile(
                userName: userName,
                image: userImage
            )
            
            // Message content
            Text(message)
                .textStyle(size: .body, weight: .regular, color: .txPrimary)
                .padding(.leading, 40) // Align with the text, not the avatar
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.itBgSec)
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        // Basic horizontal
        GPUserProfile(
            userName: "Brandnew",
            image: nil
        )
        
        // Horizontal with different border
        GPUserProfile(
            userName: "Jane Doe",
            image: nil,
            borderColor: .hlPri
        )
        
        // Horizontal with Brandnew label
        GPUserProfile(
            userName: "John Smith",
            image: nil,
        )
        
        // Vertical layout
        GPUserProfile(
            userName: "Brandnew",
            image: nil,
            alignment: .vertical
        )
        
        // Complete message example
        GratitudeMessageViewExample(
            message: "Thank you for your help yesterday. It really made a difference!",
            userName: "Brandnew",
            userImage: nil
        )
    }
    .padding()
    .background(Color.bg)
} 
