//
//  matrix_float4x4.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 04.06.2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import ARKit

extension matrix_float4x4 {
    func position() -> SCNVector3 {
        return SCNVector3(columns.3.x, columns.3.y, columns.3.z)
    }
}
