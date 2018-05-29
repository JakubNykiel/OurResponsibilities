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
    var dayToEnd: Int
    var admins: [String]?
    var users: [String]?
    var tasks: [String]?
    var winnerGlobalPoints: Int
    
    enum EventKeys: String,CodingKey {
        case name
        case startDate
        case dayToEnd
        case admins
        case users
        case tasks
        case money
        case ratio
        case winnerGlobalPoints
    }
    
    init(name: String, startDate: String, dayToEnd: Int,admins: [String], users: [String]?, tasks: [String], winnerGlobalPoints: Int) {
        self.name = name
        self.startDate = startDate
        self.dayToEnd = dayToEnd
        self.admins = admins
        self.users = users
        self.tasks = tasks
        self.winnerGlobalPoints = winnerGlobalPoints
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy:
            EventKeys.self)
        self.name = try container.decode(String?.self, forKey: .name) ?? ""
        self.startDate = try container.decode(String?.self, forKey: .startDate) ?? ""
        self.dayToEnd = try container.decode(Int?.self, forKey: .dayToEnd) ?? 0
        self.admins = try? container.decode([String]?.self, forKey: .admins) ?? []
        self.users = try? container.decode([String]?.self, forKey: .users) ?? []
        self.tasks = try? container.decode([String]?.self, forKey: .tasks) ?? []
        self.winnerGlobalPoints = try container.decode(Int?.self, forKey: .winnerGlobalPoints) ?? 0
    }
    
}
extension EventModel {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EventKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.startDate, forKey: .startDate)
        try container.encode(self.dayToEnd, forKey: .dayToEnd)
        try container.encode(self.admins, forKey: .admins)
        try container.encode(self.users, forKey: .users)
        try container.encode(self.tasks, forKey: .tasks)
        try container.encode(self.winnerGlobalPoints, forKey: .winnerGlobalPoints)
    }
}
