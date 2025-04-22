//
//  SignUpView.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/16/25.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var onSignUp: ((_ email:String, _ password:String) -> Void)?
    
    // Computed property to check if form is valid
    private var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty
        && password == confirmPassword
    }
    
    var body: some View {
        ZStack {
            // 전체 화면 배경색
            Color.bg
                .ignoresSafeArea()
            
            NavigationStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        // SignUp Title Group
                        VStack(alignment: .leading) {
                            Text("Sign Up")
                                .textStyle(size: .title1, weight: .bold, color: .txPrimary)
                                .padding(.top, 24)
                            
                            Text(
                                "Join our community of gratitude. \nCreate an account to start your journey."
                            )
                            .textStyle(size: .body, weight: .regular, color: .txPrimary)
                            .padding(.top, 4)
                        }.padding(.horizontal, 16)
                        
                        // SignUp Form Group
                        VStack(spacing: 16) {
                            // Text fields
                            VStack(spacing: 16) {
                                LabeledTextField(
                                    label: "Email",
                                    placeholder: "Enter your email",
                                    text: $email
                                ).padding(.top, 8)
                                
                                LabeledTextField(
                                    label: "Password",
                                    placeholder: "Enter your password",
                                    text: $password,
                                    isSecure: true
                                )
                                
                                LabeledTextField(
                                    label: "Confirm Password",
                                    placeholder: "Confirm your password",
                                    text: $confirmPassword,
                                    isSecure: true
                                ).padding(.bottom, 8)
                                
                                if !confirmPassword.isEmpty && confirmPassword != password {
                                    Text("Passwords do not match")
                                        .foregroundColor(.red)
                                        .font(.system(size: 14))
                                        .padding(.bottom, 8)
                                }
                            }
                            .padding(16)
                            .background(Color.itBgPri)
                            .cornerRadius(12)
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                            
                            GCButton(
                                title: "Sign Up",
                                mode: .filled,
                                action: {
                                    onSignUp?(email,password)
                                },
                                color: (isFormValid ? .hlPri : .disabled)
                            )
                            .frame(height: 56)
                            .padding(.horizontal, 16)
                            .disabled(!isFormValid)
                            
                            Divider().padding(.horizontal, 16)
                            
                            HStack {
                                Text("Already have an account?").textStyle(
                                    size: .subheadline, weight: .semibold, color: .txPrimary)
                                
                                Button {
                                    dismiss()
                                } label: {
                                    Text("Sign In")
                                        .textStyle(
                                            size: .subheadline, weight: .semibold, color: .hlPri)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)
                        }
                    }
                    .padding(.vertical)
                }
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.txPrimary)
                        }
                    }
                }
                .toolbarBackground(Color.bg, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .background(Color.bg)
            }
        }
    }
}
