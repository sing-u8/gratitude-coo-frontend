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
            VStack(alignment: .leading) {
                Text("SignIn")
                    .textStyle(size: .title1, weight: .bold, color: .txPrimary)
                    .padding(.top, 80)
                
                Text("Let your gratitude take wing. \nSign in to send messages that matter.")
                    .textStyle(size: .body, weight: .regular, color: .txPrimary)
                    .padding(.top, 4)
            }.padding(.horizontal, 16)
            
            // SignIn Form Group
            Form {
                // text fields
                Section {
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
                    ).padding(.bottom, 8)
                }
                .background(Color.itBgPri)
                .listRowSeparator(.hidden)
                
                Button {
                    // todo: SignIn Action
                } label: {
                    Text("Sign In")
                }.buttonStyle(BtStyle(textColor: .itBgPri, borderColor: .hlPri, backgroundColor: .hlPri)).listRowBackground(Color.clear).listRowInsets(EdgeInsets())
                
                Divider().listRowBackground(Color.clear).listRowInsets(EdgeInsets())
                
                HStack() {
                    Text("No account yet?").textStyle(size: .subheadline, weight: .semibold, color: .txPrimary)
                    
                    Text("Sign Up")
                        .textStyle(size: .subheadline, weight: .semibold, color: .txPrimary)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
            }
            .listRowInsets(EdgeInsets())
            .scrollContentBackground(.hidden)
        }
        .padding()
        .background(Color.bg)
    }
}

#Preview {
    SignInView()
}
