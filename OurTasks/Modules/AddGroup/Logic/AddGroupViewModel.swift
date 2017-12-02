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
    
    let errorString = Variable<String>("")
    var groupModel: GroupModel = GroupModel()
    
    func addGroupToDatabase() {
        guard let group = groupModel else { return }
    }
    
    func createGroupDate() {
        
    }
}
