//
//  AuthenticatedView.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/17/25.
//

import SwiftUI

struct AuthenticatedView: View {
    
    @EnvironmentObject var container: DIContainer
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

struct AuthenticatedView_Previews: PreviewProvider {
    static let container: DIContainer = .stub
    
    static var previews: some View {
        AuthenticatedView(authViewModel: .init(container: Self.container))
            .environmentObject(Self.container)
    }
}
