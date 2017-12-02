//
//  FirebaseManager.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 14.09.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import Foundation
import Firebase

enum FirebaseModel: String {
    case users
}

class FirebaseManager {
    static let sharedInstance = FirebaseManager()
    let ref = Database.database().reference()
    
    //TODO: completion block
    func saveUser(user: UserModel) {
        let userJSON = user.toJSON()
        self.ref.child(FirebaseModel.users.rawValue).child(user.uid).setValue(userJSON) { (error, ref) -> Void in
            guard let error = error else { return }
            print(error.localizedDescription)
        }
    }
}
