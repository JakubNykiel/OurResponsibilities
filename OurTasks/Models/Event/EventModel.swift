//
//  EventModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 21.05.2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation

struct EventModel: Codable {
    var name: String
    var startDate: String
    var endDate: String
    var admins: [String]?
    var users: [String]?
    var tasks: [String]?
    var money: Bool
    var ratio: Float?
    
    enum EventKeys: String,CodingKey {
        case name
        case startDate
        case endDate
        case admins
        case users
        case tasks
        case money
        case ratio
    }
    
    init(name: String, startDate: String, endDate: String,admins: [String], users: [String]?, tasks: [String], money: Bool, ratio: Float?) {
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.admins = admins
        self.users = users
        self.tasks = tasks
        self.money = money
        self.ratio = ratio
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy:
            EventKeys.self)
        self.name = try container.decode(String?.self, forKey: .name) ?? ""
        self.startDate = try container.decode(String?.self, forKey: .startDate) ?? ""
        self.endDate = try container.decode(String?.self, forKey: .endDate) ?? ""
        self.admins = try? container.decode([String]?.self, forKey: .admins) ?? []
        self.users = try? container.decode([String]?.self, forKey: .users) ?? []
        self.tasks = try? container.decode([String]?.self, forKey: .tasks) ?? []
        self.money = try container.decode(Bool?.self, forKey: .money) ?? false
        self.ratio = try? container.decode(Float?.self, forKey: .ratio) ?? 0.0
    }
    
}
extension EventModel {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EventKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.startDate, forKey: .startDate)
        try container.encode(self.endDate, forKey: .endDate)
        try container.encode(self.admins, forKey: .admins)
        try container.encode(self.users, forKey: .users)
        try container.encode(self.tasks, forKey: .tasks)
        try container.encode(self.money, forKey: .money)
        try container.encode(self.ratio, forKey: .ratio)
    }
}
