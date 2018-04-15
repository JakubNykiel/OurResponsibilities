//
//  User.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 13.09.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import Foundation

struct UserModel {
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
}
extension UserModel: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: UserKeys.self)
        try container.encode(self.email, forKey: .email)
        try container.encode(self.username, forKey: .username)
        try container.encode(self.groups, forKey: .groups)
        try container.encode(self.invites, forKey: .invites)
    }
}
