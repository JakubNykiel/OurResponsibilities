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
    var uid: String
    
    enum UserKeys: String, CodingKey {
        case email
        case username
        case groups
        case invites
        case uid
    }
    
//    init() {
//        guard let email = model["email"] as? String,
//            let username = model[UserKeys.username.rawValue],
//            let groups = model[UserKeys.groups.rawValue],
//            let invites = model[UserKeys.invites.rawValue],
//            let uid = model[UserKeys.uid.rawValue] else { return }
//        self.email = email
//        self.username = username
//        self.groups = groups
//        self.invites = invites
//        self.uid = uid
//    }
}
extension UserModel: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: UserKeys.self)
        try container.encode(self.email, forKey: .email)
        try container.encode(self.username, forKey: .username)
        try container.encode(self.groups, forKey: .groups)
        try container.encode(self.invites, forKey: .invites)
//        try container.encode(self.uid, forKey: .uid)
    }
}
