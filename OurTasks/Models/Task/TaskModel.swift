//
//  TaskModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 21.05.2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation

struct TaskModel: Codable {
    var owner: String
    var name: String
    var startDate: String
    var endDate: String
    var users: [String]?
    var positivePoints: Int
    var negativePoints: Int
    var userInteraction: Bool
    
    enum TaskKeys: String,CodingKey {
        case owner
        case name
        case startDate
        case endDate
        case users
        case positivePoints
        case negativePoints
        case userInteraction
    }
    
    init(owner: String, name: String, startDate: String, endDate: String, users: [String]?, positivePoints: Int, negativePoints: Int, userInteraction: Bool) {
        self.owner = owner
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.users = users
        self.positivePoints = positivePoints
        self.negativePoints = negativePoints
        self.userInteraction = userInteraction
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy:
            TaskKeys.self)
        self.owner = try container.decode(String?.self, forKey: .owner) ?? ""
        self.name = try container.decode(String?.self, forKey: .name) ?? ""
        self.startDate = try container.decode(String?.self, forKey: .startDate) ?? ""
        self.endDate = try container.decode(String?.self, forKey: .endDate) ?? ""
        self.users = try? container.decode([String]?.self, forKey: .users) ?? []
        self.positivePoints = try container.decode(Int?.self, forKey: .positivePoints) ?? 0
        self.negativePoints = try container.decode(Int?.self, forKey: .negativePoints) ?? 0
        self.userInteraction = try container.decode(Bool?.self, forKey: .userInteraction) ?? false
    }
    
}
extension TaskModel {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TaskKeys.self)
        try container.encode(self.owner, forKey: .owner)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.startDate, forKey: .startDate)
        try container.encode(self.endDate, forKey: .endDate)
        try container.encode(self.users, forKey: .users)
        try container.encode(self.positivePoints, forKey: .positivePoints)
        try container.encode(self.negativePoints, forKey: .negativePoints)
        try container.encode(self.userInteraction, forKey: .userInteraction)
    }
}