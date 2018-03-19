//
//  FirebaseManager.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 14.09.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import Foundation
import Firebase
import RxSwift

enum FirebaseModel: String {
    case users
    case groups
    case admins
}

class FirebaseManager {
    
    let ref: DatabaseReference = Database.database().reference()
    static let sharedInstance = FirebaseManager()
    var currentUser: User?
    
    init() {
        self.currentUser = Auth.auth().currentUser
    }
   
}
