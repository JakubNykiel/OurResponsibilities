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
    let errorString: Variable<String> = Variable("")
    var groupModel: GroupModel?
    private var currentUser: User? = Auth.auth().currentUser
    var groupAdded: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    func getCurrentUserUid() -> String {
        guard let uid = self.currentUser?.uid else { return "" }
        return uid
    }
    
    func addGroupToDatabase() {
        let batch = db.batch()
        guard let groupData = groupModel.asDictionary() else { return }
        guard let userUID = self.currentUser?.uid else { return }
        
        let groupRef = self.db.collection(FirebaseModel.groups.rawValue).document()
        batch.setData(groupData, forDocument: groupRef)
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write succeeded.")
                self.addGroupToUser(id: groupRef.documentID)
            }
        }
        
    }
    
    private func addGroupToUser(id: String) {
        guard let userUID = self.currentUser?.uid else { return }
        let groupInUserRef = self.db.collection(FirebaseModel.users.rawValue).document(userUID)

        let userRef = self.db.collection(FirebaseModel.users.rawValue).document(userUID)
        userRef.getDocument { (document,error) in
            if let document = document {
                print("Document data: \(document.data())")
                guard let data = document.data() else { return }
                guard var groups: [String] = data[FirebaseModel.groups.rawValue] as? [String] else { return }
                groups.append(id)
                userRef.updateData([FirebaseModel.groups.rawValue : groups])
                self.groupAdded.onNext(true)
            } else {
                print("Document does not exist")
            }
            
        }
    }
    
    func getTodayDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let todayDate = dateFormatter.string(from: date)
        return todayDate
    }
}
