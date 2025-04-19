//
//  MainTabView.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/17/25.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var container: DIContainer
    @State private var selectedTab: MainTabType = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(MainTabType.allCases, id: \.self) { tab in
                Group {
                    switch tab {
                    case .home:
                        HomeView()
                    case .search:
                        SearchView()
                    }
                }
                .tabItem {
                    Label {
                        Text(tab.title)
                            .font(.system(size: 16))
                            .fontWeight(.bold)
                    } icon: {
                        switch tab {
                        case .home:
                            Image(systemName: "house")
                        case .search:
                            Image(systemName: "magnifyingglass")
                        }
                    }
                }
                .tag(tab)
            }
        }
        .tint(.hlPri)
    }
}

#Preview {
    MainTabView()
}
