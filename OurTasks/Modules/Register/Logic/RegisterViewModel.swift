//
//  RegisterViewModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 13.09.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import Foundation
import Firebase
import RxSwift
import RxCocoa

class RegisterViewModel {
    let ref = Database.database().reference()
    let error = Variable<String>("")
    var currentUser: UserModel?
    private let jsonEncoder: JSONEncoder = JSONEncoder()
    
    func createUser(email: String, password: String, username: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("Error with create user: \(error.localizedDescription)")
                self.error.value = error.localizedDescription
            }
            if let user = user {
                self.currentUser = UserModel(email: email, username: username, groups: nil, invites: nil, uid: user.uid)
                self.saveUser()
            }
        }
    }
    
    private func saveUser() {
        guard let user = self.currentUser else { return }
        guard let userData = user.asDictionary() else { return }
        self.ref.child(FirebaseModel.users.rawValue).child(user.uid).setValue(userData) { (error, ref) -> Void in
            guard let error = error else { return }
            print(error.localizedDescription)
        }
        
    }
}

