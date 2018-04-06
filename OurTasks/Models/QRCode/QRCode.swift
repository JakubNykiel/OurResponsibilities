//
//  QRCode.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 06.04.2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import ARKit

@available(iOS 11.0, *)
struct QRCode {
    let text: String
    
    let topLeft: SCNVector3
    let topRight: SCNVector3
    let bottomLeft: SCNVector3
    let bottomRight: SCNVector3
    let middle: ARHitTestResult
}
