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
    var uid: String
}
