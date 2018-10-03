//
//  ARTaskModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 22/08/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

//import Foundation
//import ARKit
//
//struct ARTaskModel: Codable {
//    var name: String
//    var position: [Float]
//    var scale: [Float]
//    
//    enum ARTaskKeys: String,CodingKey {
//        case name
//        case position
//        case scale
//    }
//    
//    init(name: String, position: [Float], scale: [Float]) {
//        self.name = name
//        self.position = position
//        self.scale = scale
//    }
//    
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: ARTaskKeys.self)
//        self.name = try container.decode(String?.self, forKey: .name) ?? ""
//        self.position = try container.decode([Float]?.self, forKey: .position) ?? []
//        self.scale = try container.decode([Float]?.self, forKey: .scale) ?? []
//    }
//}
//extension ARTaskModel {
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: ARTaskKeys.self)
//        try container.encode(self.name, forKey: .name)
//        try container.encode(self.position, forKey: .position)
//        try container.encode(self.scale, forKey: .scale)
//    }
//}
