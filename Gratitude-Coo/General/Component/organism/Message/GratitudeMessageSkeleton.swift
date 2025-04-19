import SwiftUI

struct GratitudeMessageSkeleton: View {
    let messageType: MessageType
    
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
                
                // User profile skeleton
                HStack(spacing: 8) {
                    // Avatar skeleton (small size)
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 32, height: 32)
                    
                    // User name skeleton
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 80, height: 16)
                        .cornerRadius(4)
                }
                
                Spacer()
                
                // Options button skeleton (only for messages written by the user)
                if messageType == .fromSelfToSelf || messageType == .fromSelfToOther {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 24, height: 24)
                }
            }
            
            // Message content skeleton
            VStack(alignment: .leading, spacing: 8) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 16)
                    .cornerRadius(4)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 16)
                    .cornerRadius(4)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 200, height: 16)
                    .cornerRadius(4)
            }
            
            // Footer with date skeleton
            HStack {
                Spacer()
                
                // Date skeleton
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 80, height: 12)
                    .cornerRadius(4)
            }
        }
        .padding(16)
        .background(Color.itBgPri)
        .cornerRadius(12)
        .shimmering() // 애니메이션 효과 적용 (구현 필요)
    }
}

// 애니메이션 효과를 위한 Shimmering 수정자
extension View {
    func shimmering() -> some View {
        modifier(ShimmeringEffect())
    }
}

struct ShimmeringEffect: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    Color.white.opacity(0.3)
                        .mask(
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.7), Color.clear]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .rotationEffect(.degrees(30))
                                .offset(x: -geometry.size.width + (phase * geometry.size.width * 3))
                        )
                }
            )
            .onAppear {
                withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

#Preview {
    VStack(spacing: 16) {
        GratitudeMessageSkeleton(messageType: .fromSelfToSelf)
        GratitudeMessageSkeleton(messageType: .fromSelfToOther)
        GratitudeMessageSkeleton(messageType: .fromOtherToSelf)
    }
    .padding()
    .background(Color.bg)
} 