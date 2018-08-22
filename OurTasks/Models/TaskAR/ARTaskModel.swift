//
//  ARTaskModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 22/08/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import ARKit

struct ARTaskModel: Codable {
    var id: Int?
    var name: String?
    var coordinates: SCNVector3?
    var blockSize: Float?
}
