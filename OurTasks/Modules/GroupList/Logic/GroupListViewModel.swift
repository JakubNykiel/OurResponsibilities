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
    
    func getUserGroups() {
//        guard let id = self.firebaseManager.currentUser?.uid else { return }
//        var groups: [GroupModel] = []
//        self.firebaseManager.ref.child(FirebaseModel.users.rawValue).child(id).child(FirebaseModel.groups.rawValue).observeSingleEvent(of: .value, with: {
//            guard let id = $0.value as! String else { return }
//                guard let group = self.firebaseManager.makeGroupModel(groupId: id) else { return }
//                groups.append(group)
//            })
//        self.userGroups.value = groups
    }
}
