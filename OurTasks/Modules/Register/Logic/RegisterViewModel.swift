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
    let db = Firestore.firestore()
    var ref: DocumentReference?
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
                self.currentUser = UserModel(email: email, username: username, groups: nil, invites: nil)
                self.saveUser()
            }
        }
    }
    
    private func saveUser() {
        guard let user = self.currentUser else { return }
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        guard let userData = user.asDictionary() else { return }
        let userRef = self.db.collection(FirebaseModel.users.rawValue).document(currentUserUid)
        userRef.setData(userData) { (err) in
            if let err = err {
                print("[ERROR_USER_ADDED] Error adding document: \(err)")
            } else {
                print("[USER_ADDED] Document added with ID: \(userRef.documentID)")
            }
        }
    }
}

