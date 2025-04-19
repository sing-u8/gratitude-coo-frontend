//
//  SignInView.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/16/25.
//

import SwiftUI
import SwiftData

struct SignInView: View {
    
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    @State private var email = ""
    @State private var password = ""
    @State private var showSignUp = false
    @State private var isSignInComplete = false
    
    private let validator = SignInValidator()
    
    private var isSignInButtonEnabled: Bool {
        validator.validate(email: email, password: password)
    }
    
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                // SignIn Title Group
                VStack(alignment: .leading) {
                    Text("SignIn")
                        .textStyle(size: .title1, weight: .bold, color: .txPrimary)
                        .padding(.top, 80)
                    
                    Text("Let your gratitude take wing. \nSign in to send messages that matter.")
                        .textStyle(size: .body, weight: .regular, color: .txPrimary)
                        .padding(.top, 4)
                }.padding(.horizontal, 16)
                
                // SignIn Form Group
                VStack {
                    // text fields
                    Section {
                        LabeledTextField(
                            label: "Email",
                            placeholder: "Enter your email",
                            text: $email
                        ).padding(.vertical, 12)
                        
                        LabeledTextField(
                            label: "Password",
                            placeholder: "Enter your password",
                            text: $password,
                            isSecure: true
                        ).padding(.bottom, 24)
                    }
                    .listRowSeparator(.hidden)
                    
                    GCButton(
                        title: "Sign In",
                        mode: .filled,
                        action: {
                            // Complete sign in and navigate to home
                            authViewModel.send(action: .login(email: email, password: password))
                            isSignInComplete = true
                        },
                        color: isSignInButtonEnabled ? Color.hlPri : Color.gray.opacity(0.8)
                    )
                    .frame(height: 56)
                    .disabled(!isSignInButtonEnabled)
                    
                    
                    Divider()
                        .padding(.vertical, 16)
                    
                    HStack() {
                        Text("No account yet?").textStyle(
                            size: .subheadline, weight: .semibold, color: .txPrimary)
                        
                        Button {
                            showSignUp = true
                        } label: {
                            Text("Sign Up")
                                .textStyle(size: .subheadline, weight: .semibold, color: .hlPri)
                        }.frame(maxWidth: .infinity, alignment: .leading)
                    }

                }
                .padding(.horizontal, 16)
                .padding(.top, 40)

                Spacer()
            }
            .padding()
            .background(Color.bg)
            .navigationDestination(isPresented: $showSignUp) {
                SignUpView()
            }
            .overlay {
                if authViewModel.isLoading {
                    ProgressView()
                }
            }
        }
    }
}

#Preview {
    
    let _container: DIContainer = .stub
    let _config = ModelConfiguration(isStoredInMemoryOnly: true)
    let _modelContainer = try! ModelContainer(for: User.self, configurations: _config)
        
    SignInView()
        .environmentObject(AuthenticationViewModel(container: .stub, modelContext: _modelContainer.mainContext))
    
    
    
}
