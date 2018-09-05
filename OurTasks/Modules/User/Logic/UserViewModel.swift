//
//  UserViewModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 04/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase
import RxSwift

class UserViewModel {
    
    var dataBinded: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var users: [String: UserModel] = [:]
    var usersKey: [String] = []
    var eventID: Variable<String> = Variable("")
    
    init(eventID: String) {
        self.eventID.value = eventID
    }
    
    func getAllUsersFromGroup(_ eventID: String) {
        let eventRef = FirebaseReferences().eventRef.document(eventID)
        eventRef.getDocument { (document,error) in
            if let document = document {
                guard let data = document.data() else { return }
                let users = data[FirebaseModel.users.rawValue] as? [String:Int] ?? [:]
                self.usersKey = Array(users.keys)
                self.toUserModel(self.usersKey)
            } else {
                print("Document does not exist")
            }
            
        }
    }
    
    func toUserModel(_ users: [String]) {
        _ = users.compactMap({ user in
            let userRef = FirebaseReferences().userRef.document(user)
            userRef.getDocument(completion: { (document, error) in
                if let document = document {
                    guard let userData = document.data() else { return }
                    self.users[document.documentID] = try! FirebaseDecoder().decode(UserModel.self, from: userData)
                    self.dataBinded.onNext(true)
                } else {
                    print("Group not exist")
                }
            })
        })
    }
    
}
