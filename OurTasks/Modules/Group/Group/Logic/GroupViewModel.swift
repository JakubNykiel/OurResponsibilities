//
//  GroupViewModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 01.05.2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class GroupViewModel {
    
    var userGroupsBehaviorSubject: BehaviorSubject<[GroupModel]> = BehaviorSubject(value: [])
    var userInvitesBehaviorSubject: BehaviorSubject<[GroupModel]> = BehaviorSubject(value: [])
    var sectionsBehaviourSubject: BehaviorSubject<[GroupListSection]> = BehaviorSubject(value: [])
    
    private let disposeBag = DisposeBag()
    private var sections: [GroupSection] = []
    
    var hexStringColor: String = ""
    var groupModel: GroupModel
    var groupID: String
    
    init(groupModel: GroupModel, groupID: String) {
        self.groupModel = groupModel
        self.groupID = groupID
    }
}
