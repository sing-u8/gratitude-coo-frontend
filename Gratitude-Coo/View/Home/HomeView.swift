//
//  HomeView.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/17/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @EnvironmentObject private var container: DIContainer
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedType: MessageType = .fromSelfToSelf
    @State private var showWriteMessage = false
    @State private var showSettings = false
    @State private var showProfileEdit = false
    
    @Query private var currentUser: [User]
    
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
            MessageTabBar(selectedType: $selectedType)
            
            TabView(selection: $selectedType) {
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
                ForEach(0..<10) { index in
                    GratitudeMessage(
                        userName: "Brandnew",
                        userImage: nil,
                        message: "오늘 회사에서 도움을 준 지민이에게 감사해요. 항상 친절하게 대해주셔서 감사합니다.",
                        likeCount: 999,
                        //            commentCount: 999,
                        date: Date(),
                        messageType: type
                    )
                }
            }
            .padding(16)
        }
        .tag(type)
    }
}

#Preview {
    HomeView()
}
