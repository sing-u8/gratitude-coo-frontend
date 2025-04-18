import SwiftUI

struct ProfileEditView: View {
    @State private var nickname: String = "N"
    @State private var name: String = ""
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        VStack(spacing: 8) {
            // Profile Image Section
            VStack {
                Avatar(userName:nickname, image: selectedImage, size: .large)
                    .overlay(alignment: .bottomTrailing) {
                        Button {
                            isShowingImagePicker = true
                        } label: {
                            Image(systemName: "camera.fill")
                                .foregroundColor(.white)
                                .frame(width: 24, height: 24)
                        }
                        .buttonStyle(.circle)
                    }
            }
            .padding(.top, 32)
            
            Form {
                Section() {
                    LabeledTextField(
                        label: "Nickname",
                        placeholder: "Enter your nickname",
                        text: $nickname
                    ).padding(.top, 8)
                    
                    LabeledTextField(
                        label: "Name",
                        placeholder: "Enter your name",
                        text: $name
                    ).padding(.bottom, 8)
                }
                .listRowBackground(Color.itBgPri)
                .listRowSeparator(.hidden)
                
                GCButton(
                    title: "Save Changes",
                    mode: .filled,
                    action: {
                        
                    }
                )
                .frame(height: 56)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
                
            }.scrollContentBackground(.hidden)
            
            // Profile Info Section
            VStack(spacing: 16) {
                
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            
        }
        .background(Color.bg)
        .navigationTitle("프로필 편집")
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
}

// Image Picker
// todo: 해당 코드부분 학습하기
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    NavigationView {
        ProfileEditView()
    }
}
