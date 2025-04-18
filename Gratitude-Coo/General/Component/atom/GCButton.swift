import SwiftUI

struct GCButton: View {
    enum ButtonMode {
        case filled
        case outlined
    }
    
    let title: String
    let mode: ButtonMode
    let action: () -> Void
    var color: Color = .hlPri
    var fontSize: CGFloat = 17
    var strokeWidth: CGFloat = 1
    
    var body: some View {
        Button(action: action) {
            Text(title)
        }
        .buttonStyle(
            mode == .filled ?
            BtStyle(
                textColor: .itBgPri,
                borderColor: color,
                backgroundColor: color,
                fontSize: fontSize
            ) :
            BtStyle(
                textColor: color,
                borderColor: color,
                backgroundColor: .clear,
                fontSize: fontSize,
                strokeWidth: strokeWidth
            )
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        // Filled button example (red button with white text)
        GCButton(
            title: "저장하기",
            mode: .filled,
            action: {}
        )
        .frame(height: 56)
        
        // Outlined button example (red outline and text with clear background)
        GCButton(
            title: "로그아웃",
            mode: .outlined,
            action: {},
            strokeWidth: 2
        )
        .frame(height: 56)
        
        // Custom color example
        GCButton(
            title: "Custom Color",
            mode: .filled,
            action: {},
            color: .blue
        )
        .frame(height: 56)
        
        // Custom font size example
        GCButton(
            title: "Smaller Text",
            mode: .outlined,
            action: {},
            fontSize: 14
        )
        .frame(height: 48)
    }
    .padding()
} 
