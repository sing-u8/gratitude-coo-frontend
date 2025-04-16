//
//  SignInView.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/16/25.
//

import SwiftUI

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            // SignIn Title Group
            Group {
                Text("SignIn")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.txPrimary)
                    .padding(.top, 80)
                
                Text("Let your gratitude take wing. Sign in to send messages that matter.")
                    .font(.system(size: 16))
                    .foregroundColor(.txPrimary)
                    .padding(.top, 4)
            }
            
            // SignIn Form Group
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.system(size: 14))
                            .foregroundColor(.txPrimary)
                        TextField("Enter your email", text: $email)
                            .textContentType(.emailAddress)
                            .autocapitalization(.none)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.system(size: 14))
                            .foregroundColor(.txPrimary)
                        SecureField("Enter your password", text: $password)
                            .textContentType(.password)
                    }
                }
                
                Button {
                    // todo: SignIn Action
                } label: {
                    Text("Sign In")
                }.buttonStyle(BtStyle(textColor: .itBgPri, borderColor: .hlPri, backgroundColor: .hlPri))
                
            }
            
            
                
            
        }
        .padding()
        .background(Color.bg)
    }
}

#Preview {
    SignInView()
}
