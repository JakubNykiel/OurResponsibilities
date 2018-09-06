//
//  MenuViewModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 06/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation

class MenuViewModel {
    
    var groupID: String
    var groupModel: GroupModel
    
    init(groupID: String, groupModel: GroupModel) {
        self.groupID = groupID
        self.groupModel = groupModel
    }
}
