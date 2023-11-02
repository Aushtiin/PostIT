//
//  ProfileView.swift
//  PostIT
//
//  Created by Austin  Tangban on 14/10/2023.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import Kingfisher

struct ProfilePostComponent: View {
    let post: Post
    
    var body: some View {
        VStack {
            Divider()
                .padding(.horizontal)
            
            HStack {
                Text(post.name)
                    .padding(.vertical, 2)
                    .padding(.horizontal)
                    .foregroundColor(.blue)
            }
            
            HStack {
                Text(post.postTitle)
                    .bold()
                
                Spacer()
                Text(post.timeStamp.formatted())
                    .font(.caption2)
            }
            .padding()
            
            if let url = URL(string: post.imageURL) {
                KFImage(url)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 300, maxHeight: 200)
            } else {
                ProgressView()
            }
        }
    }
}


struct ProfileView: View {
    @ObservedObject var loginViewModel: LoginViewModel
    @StateObject var profileViewModel = ProfileViewModel()
    
    @State private var showLogOutOptions = false
    
    @State private var showAddPostView = false
    @State private var profileImage: UIImage?
    @State private var isLoadingProfileImage = false
    @State private var isRefreshing = false
    @State private var isInitialized = false
    
    var email: String? {
        Auth.auth().currentUser?.email
    }
    
    var uid: String? {
        Auth.auth().currentUser?.uid
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(uiImage: profileImage ?? UIImage(systemName: "person.circle")!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .clipped()
                        .cornerRadius(50)
                        .overlay {
                            RoundedRectangle(cornerRadius: 44)
                                .stroke(Color(.label), lineWidth: 1)
                        }
                        .padding()
                    
                    VStack {
                        Text((email ?? "").components(separatedBy: "@").first ?? "")
                            .font(.largeTitle)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                }
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        showLogOutOptions.toggle()
                    }, label: {
                        Image(systemName: "gear")
                            .font(.system(size: 24))
                            .bold()
                            .foregroundColor(.black)
                    })
                }
            }
            .actionSheet(isPresented: $showLogOutOptions, content: {
                ActionSheet(title: Text("Settings"),
                            message: Text("What do you want to do"),
                            buttons: [
                                .destructive(Text("Sign Out"), action: {
                                    loginViewModel.handleSignOut()
                                    
                                }), .cancel()
                            ])
            })
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showAddPostView.toggle()
                    }, label: {
                        Image(systemName: "plus")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                    })
                }
            }
            .sheet(isPresented: $showAddPostView, content: {
                AddPostView()
            })
            .onAppear{
                profileViewModel.posts = [Post]()
                profileViewModel.getUserPosts()
                
                if !isInitialized {
                    isLoadingProfileImage = true
                    getProfileImage()
                    isInitialized = true
                }
            }
        }
    }
    
    func getProfileImage() {
        guard let uid = uid else { return }
        
        let storageRef = Storage.storage().reference(withPath: uid)
        storageRef.getData(maxSize: 3 * 1024 * 1024) { data, error in
            if let error = error {
                print("error while downloading profile image, \(error.localizedDescription)")
                return
            }
            
            guard let imageData = data, let image = UIImage(data: imageData) else { return }
            DispatchQueue.main.sync {
                profileImage = image
                isLoadingProfileImage = false
            }
        }
    }
}

#Preview {
    ProfileView(loginViewModel: LoginViewModel())
}
