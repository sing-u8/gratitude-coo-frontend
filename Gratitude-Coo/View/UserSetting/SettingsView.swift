import SwiftUI

struct SettingsView: View {
    @State private var showingLogoutAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            Form {
                
                Section(header: Text("My Account").textStyle(size: .title3, weight: .bold)
                    .foregroundColor(Color.txPrimary)
                    .listRowInsets(EdgeInsets())
                    .padding(.vertical, 16)
                    .textCase(nil)
                ) {
                    HStack {
                        Text("닉네임")
                            .textStyle(size: .body, weight: .bold, color: Color.txPrimary)
                        Spacer()
                        Text("Brandnew")
                            .textStyle(size: .body, weight: .bold, color: Color.txPrimary)
                    }
                    .padding(.vertical, 8)
                    
                    HStack {
                        Text("이름")
                            .textStyle(size: .body, weight: .bold, color: Color.txPrimary)
                        Spacer()
                        Text("박신규")
                            .textStyle(size: .body, weight: .bold, color: Color.txPrimary)
                    }
                    .padding(.vertical, 8)
                }
                .listRowBackground(Color.itBgPri)
                .listRowSeparator(.hidden)
                
                GCButton(
                    title: "Logout",
                    mode: .outlined,
                    action: {
                        showingLogoutAlert = true
                    },
                    strokeWidth: 3
                )
                .frame(height: 48)
                .padding(.horizontal, 0)
                .background(Color.itBgPri)
                .listRowInsets(EdgeInsets())
                
            }.scrollContentBackground(.hidden)
            
        }
        .background(Color.bg)
        .navigationTitle("Settings")
        .alert("로그아웃", isPresented: $showingLogoutAlert) {
            Button("취소", role: .cancel) { }
            Button("로그아웃", role: .destructive) {
                // TODO: 로그아웃 처리
            }
        } message: {
            Text("정말 로그아웃 하시겠습니까?")
        }
        
    }
}

#Preview {
    NavigationView {
        SettingsView()
    }
}
