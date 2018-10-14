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
    var color: String
    var users: [String:Int]?
    var events: [String]?
    var admins: [String] = []
    var codes: [String] = []

    enum GroupKeys: String,CodingKey {
        case name
        case createDate
        case color
        case users
        case events
        case admins
        case codes
    }
    
    init(name: String, createDate: String, color: String, users: [String:Int]?, events: [String]?, admins: [String], codes: [String]) {
        self.name = name
        self.createDate = createDate
        self.color = color
        self.users = users
        self.events = events
        self.admins = admins
        self.codes = codes
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy:
            GroupKeys.self)
        self.name = try container.decode(String?.self, forKey: .name) ?? ""
        self.createDate = try container.decode(String?.self, forKey: .createDate) ?? ""
        self.color = try container.decode(String?.self, forKey: .color) ?? "FFFFFF"
        self.users = try? container.decode([String:Int]?.self, forKey: .users) ?? [:]
        self.events = try? container.decode([String]?.self, forKey: .events) ?? []
        self.admins = try container.decode([String]?.self, forKey: .admins) ?? []
        self.codes = try container.decode([String]?.self, forKey: .codes) ?? []
    }

}
extension GroupModel {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: GroupKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.createDate, forKey: .createDate)
        try container.encode(self.color, forKey: .color)
        try container.encode(self.users, forKey: .users)
        try container.encode(self.events, forKey: .events)
        try container.encode(self.admins, forKey: .admins)
        try container.encode(self.codes, forKey: .codes)
    }
}
