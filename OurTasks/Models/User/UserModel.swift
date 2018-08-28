//
//  User.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 13.09.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import Foundation

struct UserModel: Codable {
    var email: String
    var username: String
    var groups: [String]?
    var invites: [String]?
    
    enum UserKeys: String, CodingKey {
        case email
        case username
        case groups
        case invites
    }
    
    init(email: String, username: String, groups: [String]?, invites: [String]?) {
        self.email = email
        self.username = username
        self.groups = groups
        self.invites = invites
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserKeys.self)
        self.email = try container.decode(String?.self, forKey: .email) ?? ""
        self.username = try container.decode(String?.self, forKey: .username) ?? ""
        self.groups = try? container.decode([String]?.self, forKey: .groups) ?? []
        self.invites = try? container.decode([String]?.self, forKey: .invites) ?? []
    }
    
    
}
extension UserModel {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: UserKeys.self)
        try container.encode(self.email, forKey: .email)
        try container.encode(self.username, forKey: .username)
        try container.encode(self.groups, forKey: .groups)
        try container.encode(self.invites, forKey: .invites)
    }
}
