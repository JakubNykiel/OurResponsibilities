//
//  User.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 13.09.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable {
    
    var email: String!
    var username: String!
    var groups: [String]!
    var invites: [String]!
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.email <- map["email"]
        self.username <- map["username"]
        self.groups <- map["groups"]
        self.invites <- map["invites"]
    }
}
