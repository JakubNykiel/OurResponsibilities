//
//  RegisterViewModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 13.09.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import Foundation
import Firebase

class RegisterViewModel {
    
    let currentUser = UserModel()
    var ref: DatabaseReference!
    
    func createUser(email: String, password: String, username: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("Error with create user: \(error)")
            }
            if let user = user {
                self.currentUser.email = email
                self.currentUser.username = username
                self.currentUser.uid = user.uid
                FirebaseManager.sharedInstance.saveUser(user: self.currentUser)
            }
        }
    }
}
