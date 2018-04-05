//
//  GroupModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 20.11.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import Foundation

struct GroupModel: Codable {
    var name: String
    var createDate: String
    var users: [String]?
    var tasks: [String]?
    var admins: [String] = []
    var userInteraction: Bool

    enum GroupKeys: String,CodingKey {
        case name
        case createDate
        case users
        case tasks
        case admins
        case userInteraction
    }
    
    init(name: String, createDate: String, users: [String]?, tasks: [String]?, admins: [String], userInteraction: Bool) {
        self.name = name
        self.createDate = createDate
        self.users = users
        self.tasks = tasks
        self.admins = admins
        self.userInteraction = userInteraction
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy:
            GroupKeys.self)
        self.name = try container.decode(String?.self, forKey: .name) ?? ""
        self.createDate = try container.decode(String?.self, forKey: .createDate) ?? ""
        self.users = try? container.decode([String]?.self, forKey: .users) ?? []
        self.tasks = try? container.decode([String]?.self, forKey: .tasks) ?? []
        self.admins = try container.decode([String]?.self, forKey: .users) ?? []
        self.userInteraction = try container.decode(Bool.self, forKey: .userInteraction)
    }

}
extension GroupModel {
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
