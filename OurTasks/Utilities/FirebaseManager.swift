//
//  FirebaseManager.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 14.09.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import Foundation
import Firebase
import RxSwift

enum FirebaseModel: String {
    case users
    case groups
    case admins
}

class FirebaseManager {
    
    let db = Firestore.firestore()
    let ref: DatabaseReference = Database.database().reference()
    static let sharedInstance = FirebaseManager()
    var currentUser: User?
    
    init() {
        self.currentUser = Auth.auth().currentUser
    }
    
    func makeGroupModel(groupId: String) -> GroupModel? {
        let jsonDecoder = JSONDecoder()
        var groupModel: GroupModel?
        
        let groupRef = self.db.collection(FirebaseModel.groups.rawValue).document(groupId)
        groupRef.getDocument { (document, error) in
            if let document = document {
                guard let jsonData = try? JSONSerialization.data(withJSONObject: document.data(), options: .prettyPrinted),
                    let groupDecode = try? jsonDecoder.decode(GroupModel.self, from: jsonData) else { return }
                groupModel = groupDecode
            } else {
                print("Document does not exist")
            }
        }
        
        return groupModel
    }
   
}
