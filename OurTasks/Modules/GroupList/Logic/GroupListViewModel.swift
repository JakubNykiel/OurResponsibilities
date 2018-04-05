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
        self.groupsFetched.value = false
        guard let uid = self.firebaseManager.currentUser?.uid else { return }
        let userGroupsRef = self.firebaseManager.db.collection(FirebaseModel.users.rawValue).document(uid)
        userGroupsRef.getDocument { (document, error) in
            if let document = document {
                print("Document data: \(document.data())")
                guard let data = document.data() else { return }
                guard let groups: [String] = data[FirebaseModel.groups.rawValue] as? [String] else { return }
                self.toGroupModel(groups)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    private func toGroupModel(_ groups: [String]) {
        groups.compactMap({ group in
            guard let model = self.firebaseManager.makeGroupModel(groupId: group) else { return }
            self.userGroups.value.append(model)
        })
        self.groupsFetched.value = true
    }
}
