import SwiftUI
import SwiftData

struct CreateGratitudeView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: CreateGratitudeViewModel
    
    // 사용자 입력
    @State private var isRecipientSelectionShown = false
    @State private var isVisibilitySheetPresented = false
    
    // 현재 날짜
    private let currentDate = Date()
    
    init(container: DIContainer, modelContext: ModelContext, recipient: Member? = nil) {
        _viewModel = StateObject(wrappedValue: CreateGratitudeViewModel(
            container: container,
            modelContext: modelContext,
            recipient: recipient
        ))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 타이틀 및 닫기 버튼
            topBar
            
            ScrollView {
                VStack(spacing: 0) {
                    // 날짜 표시
                    dateSection
                    
                    // 수신자 정보
                    recipientSection
                    
                    // 메시지 영역
                    messageSection
                    
                    // 메시지 설정 영역
                    messageSettingSection
                    
                    // 저장 버튼
                    composeSendButton
                }
                .padding(.horizontal, 16)
            }
        }
        .background(Color.bg)
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: Binding<Bool>(
            get: {
                if case .failure = viewModel.sendState { return true }
                return false
            },
            set: { _ in }
        )) {
            let errorMessage = if case let .failure(message) = viewModel.sendState {
                message
            } else {
                "오류가 발생했습니다."
            }
            
            return Alert(
                title: Text("전송 실패"),
                message: Text(errorMessage),
                dismissButton: .default(Text("확인")) {
                    viewModel.sendState = .idle
                }
            )
        }
        .onChange(of: viewModel.sendState) { oldValue, newValue in
            if case .success = newValue {
                dismiss()
            }
        }
        .onAppear {
            // 수신자가 없으면 자기 자신으로 설정
            if viewModel.recipient == nil {
                viewModel.setSelfAsRecipient()
            }
        }
    }
    
    // MARK: - UI Components
    
    private var topBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.txPrimary)
                    .font(.system(size: 20))
                    .padding(8)
            }
            
            Spacer()
            
            Text("Compose Gratitude")
                .font(.headline)
                .foregroundColor(.txPrimary)
            
            Spacer()
            
            // 균형을 맞추기 위한 투명 버튼
            Button {} label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.clear)
                    .font(.system(size: 20))
                    .padding(8)
            }
        }
        .padding()
        .background(Color.bg)
    }
    
    private var dateSection: some View {
        HStack {
            Text(formattedDate)
                .textStyle(size: .title3, weight: .regular, color: .txPrimary)
            
            Spacer()
        }
        .padding(.top, 16)
        .padding(.bottom, 8)
    }
    
    private var recipientSection: some View {
        HStack(spacing: 8) {
            Text("To")
                .textStyle(size: .subheadline, weight: .medium, color: .txPrimary)
                .padding(.trailing, 0)
            
            if let recipient = viewModel.recipient {
                HStack(spacing: 4) {
                    // 수신자 프로필 아이콘
                    Avatar(
                        userName: recipient.nickname,
                        image: nil,
                        size: .small,
                        borderColor: .limeGr
                    )
                    Text(recipient.nickname)
                        .textStyle(size: .subheadline, weight: .medium, color: .txPrimary)
                }
                .padding(.vertical, 4)
            } else {
                Text("Select Recipient")
                    .font(.body)
                    .foregroundColor(.txSecondary)
            }
            
            Spacer()
        }
        .padding(.bottom, 8)
    }
    
    private var messageSection: some View {
        VStack(spacing: 0) {
            // 메시지 입력 영역
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.itBgSec)
                
                TextEditor(text: $viewModel.messageContent)
                    .font(.body)
                    .foregroundColor(.txPrimary)
                    .scrollContentBackground(.hidden) // 스크롤 배경 숨기기
                    .background(Color.clear) // 배경 투명하게
                    .padding(16) // 텍스트 패딩
                    .frame(maxHeight: 200) // 최대 높이 제한
            }
            .frame(minHeight: 150)
            .padding(8)
            .onChange(of: viewModel.messageContent) {
                if viewModel.messageContent.count > viewModel.maxCharacterCount {
                    viewModel.messageContent = String(viewModel.messageContent.prefix(viewModel.maxCharacterCount))
                }
            }
            
            // 글자 수 카운터
            HStack {
                Spacer()
                Text("\(viewModel.messageContent.count) / \(viewModel.maxCharacterCount)")
                    .textStyle(size: .footnote, weight: .regular, color: Color.caption)
            }
            .padding(.top, 4)
            .padding(.bottom, 16)
        }
    }
    
    private var messageSettingSection: some View {
        VStack(spacing: 0) {
            Text("Message Settings")
                .textStyle(size: .subheadline, weight: .bold, color: .txPrimary)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 8)
            
            VStack(spacing: 0) {
                // 익명으로 보내기 토글
                HStack {
                    Text("Send Anonymously")
                        .font(.body)
                        .foregroundColor(.txPrimary)
                    
                    Spacer()
                    
                    Toggle("", isOn: $viewModel.isAnonymous)
                        .toggleStyle(SwitchToggleStyle(tint: .hlPri))
                }
                .padding(.vertical, 12)
                
                Divider()
                
                // 공개 범위 설정
                Button {
                    isVisibilitySheetPresented = true
                } label: {
                    HStack {
                        Text("Visibility")
                            .textStyle(size: .subheadline, weight: .regular, color: .txPrimary)
                        
                        Spacer()
                        
                        Text(viewModel.visibility == .PRIVATE ? "Private" : "Public")
                            .textStyle(size: .subheadline, weight: .regular, color: .txPrimary)
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14))
                            .foregroundColor(.txPrimary)
                    }
                    .padding(.vertical, 12)
                }
                .sheet(isPresented: $isVisibilitySheetPresented) {
                    NavigationStack {
                        List {
                            ForEach(Visibility.allCases, id: \.self) { visibility in
                                Button {
                                    viewModel.visibility = visibility
                                    isVisibilitySheetPresented = false
                                } label: {
                                    HStack {
                                        Text(visibility == .PRIVATE ? "Private" : "Public")
                                            .foregroundColor(.txPrimary)
                                        
                                        Spacer()
                                        
                                        if visibility == viewModel.visibility {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.hlPri)
                                        }
                                    }
                                }
                            }
                        }
                        .navigationTitle("Set Visibility")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Done") {
                                    isVisibilitySheetPresented = false
                                }
                            }
                        }
                        .background(Color.bg)
                    }
                    .background(Color.bg)
                    .presentationBackground(Color.bg)
                }
            }
            .padding(.horizontal, 16)
            .background(Color.itBgPri)
            .cornerRadius(8)
            .padding(.bottom, 24)
        }
    }
    
    private var composeSendButton: some View {
        GCButton(
            title: "Send Message",
            mode: .filled,
            action: {
                viewModel.sendGratitudeMessage()
            },
            color: viewModel.canSendMessage ? .hlPri : .gray.opacity(0.5)
        )
        .frame(height: 56)
        .padding(.bottom, 32)
        .disabled(!viewModel.canSendMessage)
    }
    
    // MARK: - Helper Methods
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: currentDate)
    }
}
