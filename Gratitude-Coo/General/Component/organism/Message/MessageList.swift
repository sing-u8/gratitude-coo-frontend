import SwiftUI

struct MessageList: View {
    @State private var selectedType: MessageType = .fromSelfToSelf
    
    var body: some View {
        VStack(spacing: 0) {
            MessageTabBar(selectedType: $selectedType)
            
            TabView(selection: $selectedType) {
                ForEach(MessageType.allCases, id: \.self) { type in
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            // TODO: 각 타입에 맞는 메시지 리스트 표시
                            ForEach(0..<10) { index in
                                Text("\(type.title) \(index)")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.itBgPri)
                                    .cornerRadius(12)
                            }
                        }
                        .padding(16)
                    }
                    .tag(type)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .background(Color.bg)
    }
}

#Preview {
    MessageList()
} 
