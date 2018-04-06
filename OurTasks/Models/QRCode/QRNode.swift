//
//  QRNode.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 06.04.2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import ARKit

@available(iOS 11.0, *)
class QRNode: SCNNode {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init?(qr: QRCode) {
        super.init()
        let g = SCNPlane(width: 0.1, height: 0.1)
        g.firstMaterial?.isDoubleSided = true
        let node = SCNNode(geometry: g)
        self.addChildNode(node)
    }
}
