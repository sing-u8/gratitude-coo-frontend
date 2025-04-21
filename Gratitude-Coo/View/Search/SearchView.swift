//
//  SearchView.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/17/25.
//

import SwiftUI
import Combine

struct SearchView: View {
    private let container: DIContainer
    
    @StateObject private var viewModel: SearchViewModel
    
    @State private var selectedUser: Member?
    @State private var searchText = ""
    @State private var cancellables = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
        _viewModel = StateObject(wrappedValue: SearchViewModel(container: container))
    }
    
    private var searchTextPublisher: AnyPublisher<String, Never> {
        searchText
            .publisher
            .collect()
            .map { String($0) }
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main) // 0.5초 디바운스
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 검색 영역
            searchBar
                .padding(.top, 12)
            
            // 회원 목록
            memberListView
                .padding(.top, 8)
        }
        .padding(.horizontal, 16)
        .background(Color.bg)
        .navigationTitle("Search User")
        .onAppear {
            // onAppear에서 구독 설정
            searchTextPublisher
                .sink { debouncedText in
                    print("Debounced text: \(debouncedText)")
                    guard !debouncedText.isEmpty else {
                        viewModel.searchMember(keyword: "")
                        return
                    }
                    viewModel.searchMember(keyword: debouncedText)
                }
                .store(in: &cancellables)
        }
    }
    
    private var searchBar: some View {
        HStack(spacing: 0) {
            // 검색 아이콘
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading, 16)
                .padding(.trailing, 8)
            
            // 텍스트 필드 (LabeledTextField의 스타일 유지)
            TextField("Search user", text: $searchText)
                .padding(.vertical, 12)
                .foregroundColor(.txPrimary)
            
            // 삭제 버튼
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                    viewModel.searchMember(keyword: "")
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 16)
                }
            } else {
                // 텍스트가 비어있을 때 동일한 패딩 유지
                Spacer()
                    .frame(width: 16)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private var memberListView: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(viewModel.members, id: \.id) { member in
                    UserSearchItem(
                        userId: member.id,
                        nickname: member.nickname,
                        username: member.name,
                        image: nil,
                        onTap: {
                            selectedUser = member
                        }
                    )
                    .onAppear {
                        // 스크롤 시 자동 로드
                        viewModel.loadMoreIfNeeded(currentItem: member)
                    }
                }
                
                // 로딩 중이면 로딩 표시
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, minHeight: 50)
                }
                
                // 더 보기 버튼
                if !viewModel.members.isEmpty && viewModel.hasNext && !viewModel.isLoading {
                    loadMoreButton
                }
                
                // 데이터가 없는 경우
                if !viewModel.isLoading && viewModel.members.isEmpty {
                    emptyStateView
                }
            }
        }
        .scrollIndicators(.hidden)
        .refreshable {
            // 새로고침 시 전체 검색 결과 갱신
            viewModel.searchMember(keyword: searchText)
        }
        .onAppear {
            // 처음 화면이 나타날 때 전체 회원 조회
            if viewModel.members.isEmpty {
                viewModel.searchMember(keyword: searchText)
            }
        }
    }
    
    private var loadMoreButton: some View {
        Button {
            if let lastMember = viewModel.members.last {
                viewModel.loadMoreIfNeeded(currentItem: lastMember)
            }
        } label: {
            HStack {
                Text("더 보기")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.txPrimary)
                
                if viewModel.isLoading {
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
        .padding(.vertical, 8)
        .disabled(viewModel.isLoading)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.crop.circle.badge.questionmark")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("검색 결과가 없습니다")
                .font(.headline)
                .foregroundColor(.txPrimary)
            
            Text("다른 검색어를 입력해보세요")
                .font(.subheadline)
                .foregroundColor(.txPrimary)
        }
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity)
    }
}

