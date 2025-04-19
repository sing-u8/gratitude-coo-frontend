//
//  AuthenticatedView.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/17/25.
//

import SwiftUI
import SwiftData

struct AuthenticatedView: View {
    
    @EnvironmentObject var container: DIContainer
    @Environment(\.modelContext) var modelContext
    @StateObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack {
            switch authViewModel.authenticationState {
            case .unauthenticated:
                SignInView()
                    .environmentObject(authViewModel)
            case .authenticated:
                MainTabView()
                    .environmentObject(authViewModel)
            }
        }
        .onAppear {
            authViewModel.send(action: .checkAuthenticationState)
        }
    }
}

// Preview provider
struct AuthenticatedView_Previews: PreviewProvider {
    static let container: DIContainer = .stub
    
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: User.self, configurations: config)
        
        AuthenticatedView(authViewModel: .init(container: Self.container, modelContext: container.mainContext))
            .environmentObject(Self.container)
            .modelContainer(container)
    }
}
