//
//  GroupModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 20.11.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import Foundation
import ObjectMapper

class GroupModel: Mappable {
    var name: String!
    var createDate: String!
    var users: [String]!
    var tasks: [String]!
    var admins: [String]! = []
    var userInteraction: Bool!
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.name <- map["name"]
        self.createDate <- map["createDate"]
        self.users <- map["users"]
        self.tasks <- map["tasks"]
        self.admins <- map["admins"]
        self.userInteraction <- map["userInteraction"]
    }
}
