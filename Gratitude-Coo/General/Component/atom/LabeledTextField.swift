import SwiftUI

struct LabeledTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Label
            Text(label)
                .textStyle(size: .subheadline, weight: .semibold, color: .txPrimary)
            
            // Text Field
            if isSecure {
                SecureField(placeholder, text: $text)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    )
                    .foregroundColor(.txPrimary)
            } else {
                TextField(placeholder, text: $text)
                    
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    )
                    .foregroundColor(.txPrimary)
            }
        }
    }
}

#Preview {
    VStack {
        LabeledTextField(
            label: "Nickname",
            placeholder: "Brandnew",
            text: .constant("")
        )
        .padding()
        
        LabeledTextField(
            label: "Password",
            placeholder: "Enter password",
            text: .constant("password123"),
            isSecure: true
        )
        .padding()
    }
    .background(Color.bg)
}
