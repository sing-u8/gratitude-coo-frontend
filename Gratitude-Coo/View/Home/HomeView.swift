//
//  HomeView.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/17/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    private let container: DIContainer
    private let modelContext: ModelContext
    
    @StateObject private var viewModel: HomeViewModel
    
    @State private var showWriteMessage = false
    @State private var showSettings = false
    @State private var showProfileEdit = false
    
    @Query private var currentUser: [User]
    
    init(container: DIContainer, modelContext: ModelContext) {
        self.container = container
        self.modelContext = modelContext
        _viewModel = StateObject(wrappedValue: HomeViewModel(container: container, modelContext: modelContext))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                profileSection
                buttonSection
                messageSection
            }
            .background(Color.bg)
            .sheet(isPresented: $showWriteMessage) {
                // TODO: 감사메시지 작성 화면
                Text("감사메시지 작성 화면")
            }
            .navigationDestination(isPresented: $showSettings) {
                UserSettingsView()
            }
            .navigationDestination(isPresented: $showProfileEdit) {
                UserProfileEditView(viewModel: .init(container: container, modelContext: modelContext))
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                            .foregroundColor(.txPrimary)
                            .font(.system(size:20))
                            .padding(8)
                            .background(Circle().fill(Color.clear))
                    }
                }
            }
            .refreshable {
                viewModel.refreshCurrentType()
            }
            .alert(
                "오류",
                isPresented: .init(
                    get: { viewModel.errorMessage != nil },
                    set: { if !$0 { viewModel.errorMessage = nil } }
                ),
                actions: {
                    Button("확인") {
                        viewModel.errorMessage = nil
                    }
                },
                message: {
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                    }
                }
            )
        }
    }
    
    private var profileSection: some View {
        MainUserProfile(
            userName: currentUser.first?.nickname ?? "Nickname",
            image: nil,
            sentGratitude: 9999,
            receivedGratitude: 9999
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
    }
    
    private var buttonSection: some View {
        HStack(spacing: 16) {
            GCButton(
                title: "감사메시지 작성",
                mode: .filled,
                action: {
                    showWriteMessage = true
                }
            )
            
            GCButton(
                title: "프로필 편집",
                mode: .outlined,
                action: {
                    showProfileEdit = true
                }
            )
        }
        .frame(height: 48)
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
    }
    
    private var messageSection: some View {
        VStack(spacing: 0) {
            MessageTabBar(selectedType: $viewModel.selectedType)
            
            TabView(selection: $viewModel.selectedType) {
                ForEach(MessageType.allCases, id: \.self) { type in
                    messageList(for: type)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
    
    private func messageList(for type: MessageType) -> some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 16) {
                // 로딩 중이고 메시지가 없는 경우 스켈레톤 표시
                if viewModel.isLoading(for: type) && viewModel.messages(for: type).isEmpty {
                    ForEach(0..<3, id: \.self) { _ in
                        GratitudeMessageSkeleton(messageType: type)
                    }
                } else {
                    // 메시지 목록 표시
                    ForEach(viewModel.messages(for: type), id: \.id) { message in
                        GratitudeMessage(
                            userName: message.isAnonymous ? "익명" : (type == .fromSelfToOther ? message.recipient.nickname : message.author.nickname),
                            userImage: nil,
                            message: message.contents,
                            date: Date(), // API 응답에 날짜 필드가 없으므로 현재 날짜 사용
                            messageType: type
                        )
                        .onAppear {
                            // 페이지네이션: 마지막 아이템이 보이면 다음 페이지 로드
                            viewModel.loadMoreIfNeeded(for: type, currentItem: message)
                        }
                    }
                    
                    // 더 로드 중인 경우 하단에 스켈레톤 표시
                    if viewModel.isLoading(for: type) && !viewModel.messages(for: type).isEmpty {
                        GratitudeMessageSkeleton(messageType: type)
                    }
                    
                    // 데이터가 없는 경우 표시
                    if !viewModel.isLoading(for: type) && viewModel.messages(for: type).isEmpty {
                        emptyStateView(for: type)
                    }
                }
            }
            .padding(16)
        }
        .tag(type)
    }
    
    // 데이터가 없는 경우 표시할 뷰
    private func emptyStateView(for type: MessageType) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("메시지가 없습니다")
                .font(.headline)
                .foregroundColor(.txPrimary)
            
            Text(emptyStateMessage(for: type))
                .font(.subheadline)
                .foregroundColor(.txPrimary)
                .multilineTextAlignment(.center)
            
        }
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity)
    }
    
    // 메시지 타입별 빈 상태 메시지
    private func emptyStateMessage(for type: MessageType) -> String {
        switch type {
        case .fromSelfToSelf:
            return "자신에게 감사 메시지를 보내보세요.\n오늘 하루를 돌아보고 감사함을 표현해보세요."
        case .fromSelfToOther:
            return "다른 사람에게 감사 메시지를 보내보세요.\n감사함을 표현하면 모두가 행복해집니다."
        case .fromOtherToSelf:
            return "아직 받은 감사 메시지가 없습니다.\n다른 사람에게 먼저 감사 메시지를 보내보세요."
        }
    }
}

//#Preview {
//    HomeView()
//}
