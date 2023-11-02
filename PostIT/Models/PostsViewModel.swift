//
//  PostsViewodel.swift
//  PostIT
//
//  Created by Austin  Tangban on 19/10/2023.
//

import Foundation
import UIKit

class PostsViewModel: ObservableObject {
   @Published var posts = [Post]()
    
    init() {
        fetchAllPosts()
    }
    
    func fetchAllPosts() {
        FirebaseManager.shared.firestore
            .collection("posts")
            .getDocuments { documentsSnapshot, error in
                if let error = error {
                    print("failed to fetch posts \(error)")
                    return
                }
                
                documentsSnapshot?.documents.forEach({ snapshot in
                    let data = snapshot.data()
                    let post = Post(data: data)
                    self.posts.append(post)
                    self.posts.sort { $0.timeStamp > $1.timeStamp }
                })
            }
    }
    
    func getUserProfileImage(userUID: String, completion: @escaping (UIImage?) -> Void) {
        let ref = FirebaseManager.shared.storage.reference(withPath: userUID)
        ref.getData(maxSize: 3 * 1024 * 1024) { data, error in
            if let error = error {
                print ("error getting user image \(error.localizedDescription)")
                completion(nil)
            } else {
                if let data = data {
                    let image = UIImage(data: data)
                    completion(image)
                }
            }
        }
    }
}


