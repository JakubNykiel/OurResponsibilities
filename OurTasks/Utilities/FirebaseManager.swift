//
//  FirebaseManager.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 14.09.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase
import RxSwift

enum FirebaseModel: String {
    case users
    case groups
    case admins
    case events
    case tasks
}

struct FirebaseReferences {
    var groupRef = Firestore.firestore().collection(FirebaseModel.groups.rawValue)
    var eventRef = Firestore.firestore().collection(FirebaseModel.events.rawValue)
}

class FirebaseManager {
    
    let db = Firestore.firestore()
    let ref: DatabaseReference = Database.database().reference()
    static let sharedInstance = FirebaseManager()
    var currentUser: User?
    
    init() {
        self.currentUser = Auth.auth().currentUser
    }
    
    func getCurrentUserUid() -> String {
        guard let uid = self.currentUser?.uid else { return "" }
        return uid
    }   
}
