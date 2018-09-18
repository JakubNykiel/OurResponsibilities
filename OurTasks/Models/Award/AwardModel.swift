//
//  AwardModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 17/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation

struct AwardModel: Codable {
    var name: String
    var group: String
    var cost: Int
    var available: Int
    
    enum AwardKeys: String,CodingKey {
        case name
        case cost
        case available
        case group
    }
    
    init(name: String, group: String, cost: Int, available: Int) {
        self.name = name
        self.cost = cost
        self.available = available
        self.group = group
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy:
            AwardKeys.self)
        self.name = try container.decode(String?.self, forKey: .name) ?? ""
        self.group = try container.decode(String?.self, forKey: .name) ?? ""
        self.cost = try container.decode(Int?.self, forKey: .cost) ?? 0
        self.available = try container.decode(Int?.self, forKey: .available) ?? 0
    }
}
extension AwardModel {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AwardKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.cost, forKey: .cost)
        try container.encode(self.available, forKey: .available)
        try container.encode(self.group, forKey: .group)
    }
}
