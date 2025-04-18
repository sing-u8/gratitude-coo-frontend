import SwiftUI

struct Avatar: View {
    enum Size {
        case small    // For messages
        case mediumSmall
        case mediumLarge   // For home screen
        case large    // For profile editing
        
        var diameter: CGFloat {
            switch self {
            case .small: return 32
            case .mediumSmall: return 64
            case .mediumLarge: return 104
            case .large: return 144
            }
        }
        
        var fontSize: CGFloat {
            switch self {
            case .small: return 17
            case .mediumSmall: return 32
            case .mediumLarge: return 48
            case .large: return 72
            }
        }
        
        var fontWeight: TextStyle.WeightType {
            switch self {
            case .small: return .medium
            case .mediumSmall: return .semibold
            case .mediumLarge: return .semibold
            case .large: return .bold
            }
        }
        
        var strokeWidth: CGFloat {
            switch self {
            case .small: return 2
            case .mediumSmall: return 2
            case .mediumLarge: return 3
            case .large: return 4
            }
        }
    }
    
    let userName: String
    let image: UIImage?
    let size: Size
    var borderColor: Color = .limeGr
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.itBgPri)
                .overlay(
                    Circle()
                        .stroke(borderColor, lineWidth: size.strokeWidth)
                )
                .frame(width: size.diameter, height: size.diameter)
            
            if let image = image {
                // todo: image modifier 공부하기
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.diameter - (size.strokeWidth * 2), 
                           height: size.diameter - (size.strokeWidth * 2))
                    .clipShape(Circle())
            } else {
                Text(String(userName.prefix(1).uppercased()))
                    .font(.system(size: size.fontSize, weight: size.fontWeight.weight))
                    .foregroundColor(.txPrimary)
            }
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        // Small avatar (for messages)
        HStack(spacing: 20) {
            Avatar(userName: "John", image: nil, size: .small)
            Avatar(userName: "B", image: nil, size: .small, borderColor: .hlPri)
        }
        
        // Medium small avatar (for home screen)
        HStack(spacing: 30) {
            Avatar(userName: "John", image: nil, size: .mediumSmall)
            Avatar(userName: "B", image: nil, size: .mediumSmall, borderColor: .hlPri)
        }
        
        // Medium large avatar (for home screen)
        HStack(spacing: 30) {
            Avatar(userName: "John", image: nil, size: .mediumLarge)
            Avatar(userName: "B", image: nil, size: .mediumLarge, borderColor: .hlPri)
        }
        
        // Large avatar (for profile editing)
        Avatar(userName: "B", image: nil, size: .large)
    }
    .padding()
    .background(Color.bg)
} 
