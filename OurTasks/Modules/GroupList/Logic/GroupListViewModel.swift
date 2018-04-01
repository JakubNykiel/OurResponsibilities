//
//  GroupListViewModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 19.12.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import Foundation
import Firebase
import RxSwift

class GroupListViewModel {
    
    private let firebaseManager: FirebaseManager = FirebaseManager()
    var userGroups: Variable<[GroupModel]> = Variable([])
    var groupsFetched: Variable<Bool> = Variable(false)
    
    func getUserGroups() {
//        let uid = self.firebaseManager.currentUser?.uid ?? ""
//        let userGroupsRef = self.firebaseManager.db.collection(FirebaseModel.users.rawValue).document(uid).
    }
}
