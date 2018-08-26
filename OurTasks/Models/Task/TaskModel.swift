//
//  TaskModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 21.05.2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation

enum TaskState: String {
    case backlog = "backlog"
    case inProgress = "In Progress"
    case done = "Done"
    case toFix = "To Fix"
    
}

struct TaskModel: Codable {
    var owner: String
    var name: String
    var state: String
    var endDate: String
    var users: [String]?
    var globalPositivePoints: Int
    var globalNegativePoints: Int
    var positivePoints: Int
    var negativePoints: Int
    var userInteraction: Bool
    var AR: Bool
    var arTask: ARTaskModel?
    var description: String
    
    enum TaskKeys: String,CodingKey {
        case owner
        case name
        case endDate
        case users
        case positivePoints
        case negativePoints
        case userInteraction
        case AR
        case arTask
        case state
        case globalPositivePoints
        case globalNegativePoints
        case description
    }
    
    init(owner: String, name: String, endDate: String, users: [String]?, positivePoints: Int, negativePoints: Int, userInteraction: Bool, AR: Bool, arTask: ARTaskModel?, state: String, globalPositivePoints: Int, globalNegativePoints: Int, description: String) {
        self.owner = owner
        self.name = name
        self.endDate = endDate
        self.users = users
        self.positivePoints = positivePoints
        self.negativePoints = negativePoints
        self.userInteraction = userInteraction
        self.AR = AR
        self.arTask = arTask
        self.state = state
        self.globalPositivePoints = globalPositivePoints
        self.globalNegativePoints = globalNegativePoints
        self.description = description
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy:
            TaskKeys.self)
        self.owner = try container.decode(String?.self, forKey: .owner) ?? ""
        self.name = try container.decode(String?.self, forKey: .name) ?? ""
        self.endDate = try container.decode(String?.self, forKey: .endDate) ?? ""
        self.users = try? container.decode([String]?.self, forKey: .users) ?? []
        self.positivePoints = try container.decode(Int?.self, forKey: .positivePoints) ?? 0
        self.negativePoints = try container.decode(Int?.self, forKey: .negativePoints) ?? 0
        self.userInteraction = try container.decode(Bool?.self, forKey: .userInteraction) ?? false
        self.AR = try container.decode(Bool?.self, forKey: .AR) ?? false
        self.arTask = try? container.decode(ARTaskModel?.self, forKey: .arTask) ?? ARTaskModel()
        self.state = try container.decode(String?.self, forKey: .state) ?? "backlog"
        self.globalPositivePoints = try container.decode(Int?.self, forKey: .globalPositivePoints) ?? 0
        self.globalNegativePoints = try container.decode(Int?.self, forKey: .globalNegativePoints) ?? 0
        self.description = try container.decode(String?.self, forKey: .description) ?? ""
    }
    
}
extension TaskModel {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TaskKeys.self)
        try container.encode(self.owner, forKey: .owner)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.endDate, forKey: .endDate)
        try container.encode(self.users, forKey: .users)
        try container.encode(self.positivePoints, forKey: .positivePoints)
        try container.encode(self.negativePoints, forKey: .negativePoints)
        try container.encode(self.userInteraction, forKey: .userInteraction)
        try container.encode(self.AR, forKey: .AR)
        try container.encode(self.arTask, forKey: .arTask)
        try container.encode(self.state, forKey: .state)
        try container.encode(self.globalPositivePoints, forKey: .globalPositivePoints)
        try container.encode(self.globalNegativePoints, forKey: .globalNegativePoints)
        try container.encode(self.description, forKey: .description)
    }
}
