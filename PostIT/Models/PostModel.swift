//
//  PostsModel.swift
//  PostIT
//
//  Created by Austin  Tangban on 19/10/2023.
//

import Foundation
import Firebase

struct Post: Decodable, Identifiable {
    var id: String
    var postTitle: String
    var timeStamp: Date
    var name: String
    var userUID: String
    var imageURL: String
    
    init(data: [String: Any]) {
        self.id = data["id"] as? String ?? ""
        self.postTitle = data["title"] as? String ?? ""
        self.timeStamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
        self.name = data["name"] as? String ?? ""
        self.userUID = data["useruid"] as? String ?? ""
        self.imageURL = data["imageurl"] as? String ?? ""
    }
}
