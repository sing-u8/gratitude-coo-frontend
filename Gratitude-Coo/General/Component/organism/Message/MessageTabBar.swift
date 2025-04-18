import SwiftUI

struct MessageTabBar: View {
    @Binding var selectedType: MessageType
    @Namespace private var animation
    
    // 추후에 에니메이션 부분 학습하기
    var body: some View {
        HStack(spacing: 0) {
            ForEach(MessageType.allCases, id: \.self) { type in
                VStack(spacing: 0) {
                    Button {
                        withAnimation(.spring()) {
                            selectedType = type
                        }
                    } label: {
                        Text(type.title)
                            .textStyle(size: .body, weight: .semibold, color: selectedType == type ? .txPrimary : .txPrimary.opacity(0.5))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    
                    // 선택 표시 바
                    ZStack {
                        if selectedType == type {
                            Rectangle()
                                .fill(Color.hlPri)
                                .frame(height: 2)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        } else {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: 2)
                        }
                    }
                }
            }
        }
        .background(Color.bg)
    }
}

#Preview {
    MessageTabBar(selectedType: .constant(.fromSelfToSelf))
}
