//
//  AddTaskViewModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 28.05.2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import RxSwift

class AddTaskViewModel {
    
    var groupID: String
    var eventID: String
    
    init(groupID: String, eventID: String) {
        self.eventID = eventID
        self.groupID = groupID
    }
}
