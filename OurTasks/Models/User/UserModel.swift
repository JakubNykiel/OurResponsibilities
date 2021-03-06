//
//  User.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 13.09.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import Foundation

enum UserRole {
    case admin
    case user
}

struct UserModel: Codable {
    var email: String
    var username: String
    var groups: [String]?
    var events: [String]?
    var tasks: [String]?
    var points: Int
    
    enum UserKeys: String, CodingKey {
        case email
        case username
        case groups
        case events
        case tasks
        case points
    }
    
    init(email: String, username: String, groups: [String]?, events: [String]?, tasks: [String]?, points: Int) {
        self.email = email
        self.username = username
        self.groups = groups
        self.events = events
        self.tasks = tasks
        self.points = points
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserKeys.self)
        self.email = try container.decode(String?.self, forKey: .email) ?? ""
        self.username = try container.decode(String?.self, forKey: .username) ?? ""
        self.groups = try? container.decode([String]?.self, forKey: .groups) ?? []
        self.events = try? container.decode([String]?.self, forKey: .events) ?? []
        self.tasks = try? container.decode([String]?.self, forKey: .tasks) ?? []
        self.points = try container.decode(Int?.self, forKey: .points) ?? 0
    }
    
    
}
extension UserModel {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: UserKeys.self)
        try container.encode(self.email, forKey: .email)
        try container.encode(self.username, forKey: .username)
        try container.encode(self.groups, forKey: .groups)
        try container.encode(self.points, forKey: .points)
    }
}
