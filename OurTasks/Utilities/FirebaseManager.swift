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
    
    let ref: DatabaseReference = Database.database().reference()
    static let sharedInstance = FirebaseManager()
    var currentUser: User?
    
    init() {
        self.currentUser = Auth.auth().currentUser
    }
    
    func makeGroupModel(groupId: String) -> GroupModel? {
        let jsonDecoder = JSONDecoder()
        var groupModel: GroupModel?
        
        self.ref.child(FirebaseModel.groups.rawValue).child(groupId).observeSingleEvent(of: .value) { (group) in
            guard let jsonData = try? JSONSerialization.data(withJSONObject: group, options: .prettyPrinted),
                let groupDecode = try? jsonDecoder.decode(GroupModel.self, from: jsonData) else { return }
            groupModel = groupDecode
        }
        
        return groupModel
    }
   
}
