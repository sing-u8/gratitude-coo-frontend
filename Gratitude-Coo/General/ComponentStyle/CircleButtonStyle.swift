import SwiftUI

struct CircleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .background(Color.hlPri)
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == CircleButtonStyle {
    static var circle: CircleButtonStyle {
        CircleButtonStyle()
    }
} 