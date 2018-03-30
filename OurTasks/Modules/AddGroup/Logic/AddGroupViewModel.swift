//
//  AddGroupViewModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 13.11.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase
import RxSwift

class AddGroupViewModel {
    
    let db = Firestore.firestore()
    var ref: DocumentReference?
    let errorString = Variable<String>("")
    var groupModel: GroupModel?
    private var currentUser: User? = Auth.auth().currentUser
    
    func getCurrentUserUid() -> String {
        guard let uid = self.currentUser?.uid else { return "" }
        return uid
    }
    
    func addGroupToDatabase() {
        guard let groupData = groupModel.asDictionary() else { return }
        ref = self.db.collection(FirebaseModel.groups.rawValue).addDocument(data: groupData) { err in
            if let err = err {
                print("[ERROR_GROUP_ADD] Error adding document: \(err)")
            } else {
                print("[GROUP_ADD] Document added with ID: \(self.ref!.documentID)")
                self.addGroupToUser(id: self.ref!.documentID)
            }
        }
    }
    
    private func addGroupToUser(id: String) {
        guard let userUID = self.currentUser?.uid else { return }
        let groupInUserRef = self.db.collection(FirebaseModel.users.rawValue).document(userUID)
        
//        groupInUserRef.updateData(["groups":[self.ref!.documentID]], completion: { (err) in
//            if let err = err {
//                print("[ERROR_GROUP_ADD_TO_USER] Error adding document: \(err)")
//            } else {
//                print("[GROUP_ADD_TO_USER] Document added with ID: \(self.ref!.documentID)")
//            }
//        })
    }
    
    func getTodayDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let todayDate = dateFormatter.string(from: date)
        return todayDate
    }
}
