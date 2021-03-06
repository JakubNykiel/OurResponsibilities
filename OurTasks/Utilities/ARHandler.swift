//
//  ARHandler.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 06.04.2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import ARKit

@available(iOS 11.0, *)
class ARHandler {
    
    func startSession(sceneView: ARSCNView) {
        let configuration = ARWorldTrackingConfiguration()
        if #available(iOS 11.3, *) {
            configuration.planeDetection = [.horizontal, .vertical]
        } else {
            configuration.planeDetection = [.horizontal]
        }
        sceneView.session.run(configuration)
    }
    
    func pauseSession(sceneView: ARSCNView) {
        sceneView.session.pause()
    }
    
    func setupARScene(sceneView: ARSCNView){
        sceneView.showsStatistics = true
        let scene = SCNScene()
        sceneView.scene = scene
    }
    
    func resetARScene(sceneView: ARSCNView) {
        sceneView.session.pause()
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode() }
        self.startSession(sceneView: sceneView)
    }
}
