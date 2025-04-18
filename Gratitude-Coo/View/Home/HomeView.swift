//
//  HomeView.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/17/25.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedType: MessageType = .fromSelfToSelf
    @State private var showWriteMessage = false
    
    var body: some View {
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
    }
    
    private var profileSection: some View {
        MainUserProfile(
            userName: "Nickname",
            image: nil,
            sentGratitude: 9999,
            receivedGratitude: 9999
        )
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
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
                    // TODO: 프로필 편집 화면으로 이동
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
