//
//  GroupModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 20.11.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import Foundation

class GroupModel {
    var name: String!
    var createDate: String!
    var users: [String]!
    var tasks: [String]!
    var admins: [String]! = []
    var userInteraction: Bool!

    enum GroupKeys: String,CodingKey {
        case name
        case createDate
        case users
        case tasks
        case admins
        case userInteraction
    }

}
extension GroupModel: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: GroupKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.createDate, forKey: .createDate)
        try container.encode(self.users, forKey: .users)
        try container.encode(self.tasks, forKey: .tasks)
        try container.encode(self.admins, forKey: .admins)
        try container.encode(self.userInteraction, forKey: .userInteraction)
    }
}
