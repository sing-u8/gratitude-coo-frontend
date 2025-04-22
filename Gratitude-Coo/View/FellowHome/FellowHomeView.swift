//
//  HomeView.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/17/25.
//

import SwiftUI
import SwiftData
import Combine

struct FellowHomeView: View {
    private let container: DIContainer
    private let modelContext: ModelContext
    private var fellowUser: User
    
    @StateObject private var viewModel: FellowHomeViewModel
    
    @State private var showWriteMessage = false
    
    @State private var messageToDelete: Int? = nil
    @State private var messageToEdit: GratitudeResponse? = nil
    
    @Query private var currentUser: [User]
    
    init(container: DIContainer, modelContext: ModelContext, fellowUser: User) {
        self.container = container
        self.modelContext = modelContext
        _viewModel = StateObject(wrappedValue: FellowHomeViewModel(container: container, fellowUser: fellowUser))
        self.fellowUser = fellowUser
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                profileSection
                buttonSection
                messageSection
            }
            .background(Color.bg)
            .refreshable {
                viewModel.refreshCurrentType()
                viewModel.refreshGratitudeCount()
            }
            .sheet(isPresented: $showWriteMessage) {
                CreateGratitudeView(container: container, modelContext: modelContext, recipient: fellowUser)
                    .onDisappear {
                        viewModel.refreshCurrentType()
                        viewModel.refreshGratitudeCount()
                    }
            }
            .sheet(item:$messageToEdit) { message in
                UpdateGratitudeView(container: container, modelContext: modelContext, gratitudeMessage: message)
                    .onDisappear {
                        viewModel.refreshCurrentType()
                        viewModel.refreshGratitudeCount()
                    }
            }
            
            .onAppear {
                viewModel.refreshGratitudeCount()
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
            .alert(
                "메시지 삭제",
                isPresented: .init(
                    get: { messageToDelete != nil },
                    set: { if !$0 { messageToDelete = nil } }
                ),
                actions: {
                    Button("취소", role: .cancel) {
                        messageToDelete = nil
                    }
                    Button("삭제", role: .destructive) {
                        if let id = messageToDelete {
                            viewModel.deleteGratitudeMessage(id: id)
                        }
                        messageToDelete = nil
                    }
                },
                message: {
                    Text("정말 이 메시지를 삭제하시겠습니까?")
                }
            )
        }
    }
    
    private var profileSection: some View {
        MainUserProfile(
            userName: fellowUser.nickname ?? "Nickname",
            image: nil,
            sentGratitude: viewModel.gratitudeCount.sentCount,
            receivedGratitude: viewModel.gratitudeCount.receivedCount
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
    }
    
    private var buttonSection: some View {
        HStack(spacing: 16) {
            GCButton(
                title: "Send Gratitude",
                mode: .filled,
                action: {
                    showWriteMessage = true
                }
            )
            .frame(maxWidth: .infinity)
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
                        .tag(type)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
    
    private func messageList(for type: MessageType) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                // 로딩 중이고 메시지가 없는 경우 스켈레톤 표시
                if viewModel.isLoading(for: type) && viewModel.messages(for: type).isEmpty {
                    ForEach(0..<3, id: \.self) { _ in
                        GratitudeMessageSkeleton(messageType: type)
                    }
                } else {
                    // 메시지 목록 표시
                    ForEach(viewModel.messages(for: type), id: \.id) { message in
                        
                        GratitudeMessage(
                            id: message.id,
                            userName: message.isAnonymous ? "익명" : (type == .fromSelfToOther ? message.recipient.nickname : message.author.nickname),
                            userImage: nil,
                            message: message.contents,
                            date: message.createdAt,
                            messageType: type,
                            viewingUserId: fellowUser.id,
                            currentUserId: currentUser.first?.id ?? 0,
                            authorId: message.author.id,
                            onEdit: {
                                if type == .fromOtherToSelf {
                                    messageToEdit = message
                                }
                            },
                            onDelete: {
                                deleteMessage(id: message.id)
                            }
                        )
                    }
                    
                    // 더 로드 중인 경우 하단에 스켈레톤 표시
                    if viewModel.isLoading(for: type) && !viewModel.messages(for: type).isEmpty {
                        GratitudeMessageSkeleton(messageType: type)
                    }
                    
                    // 데이터가 없는 경우 표시
                    if !viewModel.isLoading(for: type) && viewModel.messages(for: type).isEmpty {
                        emptyStateView(for: type)
                    }
                    
                    // 더 보기 버튼
                    if !viewModel.messages(for: type).isEmpty && viewModel.hasNextPage(for: type) {
                        loadMoreButton(for: type)
                    }
                }
            }
            .padding(16)
        }
    }
    
    // 더 보기 버튼
    private func loadMoreButton(for type: MessageType) -> some View {
        Button {
            if let lastMessage = viewModel.messages(for: type).last {
                viewModel.loadMoreIfNeeded(for: type, currentItem: lastMessage)
            }
        } label: {
            HStack {
                Text("더 보기")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.txPrimary)
                
                if viewModel.isLoading(for: type) {
                    ProgressView()
                        .tint(.txPrimary)
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.txPrimary)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.txPrimary.opacity(0.3), lineWidth: 1)
            )
        }
        .padding(.top, 8)
        .disabled(viewModel.isLoading(for: type))
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
    
    // 메시지 삭제 함수
    private func deleteMessage(id: Int) {
        messageToDelete = id
    }
}

//#Preview {
//    HomeView()
//}
