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
    let colors = [AppColor.appleBlue, AppColor.appleGreen, AppColor.appleOrange, AppColor.applePink, AppColor.applePurple, AppColor.appleRed, AppColor.appleTealBlue, AppColor.appleYellow]
    var users: [String:Int] = [:]
    
    func getCurrentUserUid() -> String {
        guard let uid = self.currentUser?.uid else { return "" }
        return uid
    }
    
    func addGroupToDatabase() {
        let batch = db.batch()
        guard let groupData = groupModel.asDictionary() else { return }
        
        let groupRef = self.db.collection(FirebaseModel.groups.rawValue).document()
        batch.setData(groupData, forDocument: groupRef)
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write succeeded.")
                self.addGroupToUser(groupId: groupRef.documentID)
            }
        }
        
    }
    
    private func addGroupToUser(groupId: String) {
        
        _ = self.groupModel?.users?.compactMap({
            let userRef = self.db.collection(FirebaseModel.users.rawValue).document($0.key)
            userRef.setData([FirebaseModel.groups.rawValue : [groupId]], merge: true)
            userRef.setData([FirebaseModel.groups.rawValue : [groupId]], merge: true, completion: { (err) in
                if let error = err {
                    print(error.localizedDescription)
                } else {
                    self.groupAdded.onNext(true)
                }
            })
            
        })
    }
    
    func getTodayDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let todayDate = dateFormatter.string(from: date)
        return todayDate
    }
    
    func prepareColorForGroup(_ index: Int) -> String {
        return colors[index].hexString
    }
    
    func addUserUid(email: String) {
        self.db.collection("users").whereField("email", isEqualTo: email).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.users[document.documentID] = 0
                }
            }
        }
    }
}
