//
//  QRCodeModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 22/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation

struct QRCodeModel: Codable {
    var main: Bool
    var user: String?
    var groupID: String
    
    enum QRCodeKeys: String,CodingKey {
        case main
        case user
        case groupID
    }
    
    init(main: Bool, user: String, groupID: String) {
        self.main = main
        self.user = user
        self.groupID = groupID
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy:
            QRCodeKeys.self)
        self.main = try container.decode(Bool?.self, forKey: .main) ?? false
        self.user = try? container.decode(String?.self, forKey: .user) ?? ""
        self.groupID = try container.decode(String?.self, forKey: .groupID) ?? ""
    }
    
}
extension QRCodeModel {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: QRCodeKeys.self)
        try container.encode(self.main, forKey: .main)
        try container.encode(self.user, forKey: .user)
        try container.encode(self.groupID, forKey: .groupID)
    }
}
