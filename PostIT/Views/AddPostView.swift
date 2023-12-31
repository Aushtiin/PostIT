//
//  AddPostView.swift
//  PostIT
//
//  Created by Austin  Tangban on 14/10/2023.
//

import SwiftUI
import FirebaseAuth

struct AddPostView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var postTitle = ""
    @State private var selectedImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var errorMessage = ""
    
    var addPostViewModel = AddPostViewModel()
    
    var body: some View {
        VStack {
            HStack(spacing: 15) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
                TextField("Share your thoughts...", text: $postTitle)
                    .padding(10)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            
            Button(action: {
                isShowingImagePicker.toggle()
            }, label: {
                VStack {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                            .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray, lineWidth: 1)
                            )
                    } else {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 50))
                            .frame(width: 300, height: 300)
                            .cornerRadius(10)
                            .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                }
            })
            .padding()
            
            Text(errorMessage)
                .bold()
                .foregroundColor(.red)
            
            Button(action: {
                if selectedImage == nil {
                    errorMessage = "You must select an iage first"
                    return
                }
                
                guard let email = Auth.auth().currentUser?.email else {
                    print("Current user not authenticated")
                    return
                }
                
                let name = email.components(separatedBy: "@").first ?? ""
                
                addPostViewModel.addPost(name: name, postTitle: postTitle, image: selectedImage, date: Date())
                dismiss()
            }, label: {
                Text("Share")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(.blue)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            })
        }
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .padding(.vertical, 25)
        .sheet(isPresented: $isShowingImagePicker, content: {
            ImagePicker(image: $selectedImage)
        })
    }
}

#Preview {
    AddPostView()
}
