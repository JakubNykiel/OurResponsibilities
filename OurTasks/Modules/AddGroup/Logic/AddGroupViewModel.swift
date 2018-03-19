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
    
    private let ref = Database.database().reference()
    let errorString = Variable<String>("")
    var groupModel: GroupModel?
    private var currentUser: User? = Auth.auth().currentUser
    
    func getCurrentUserUid() -> String {
        guard let uid = self.currentUser?.uid else { return "" }
        return uid
    }
    
    func addGroupToDatabase() {
        let groupData = groupModel.asDictionary()
        let groupRefID = self.ref.child(FirebaseModel.groups.rawValue).childByAutoId()
        guard let userUID = self.currentUser?.uid else { return }
        groupRefID.setValue(groupData) { (error, ref) in
            guard let error = error else { return }
            self.errorString.value = error.localizedDescription
        }
        self.ref.child(FirebaseModel.users.rawValue).child(userUID).child(FirebaseModel.groups.rawValue).updateChildValues([groupRefID.key:true]) { (error, ref) in
            guard let error = error else { return }
            self.errorString.value = error.localizedDescription
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
