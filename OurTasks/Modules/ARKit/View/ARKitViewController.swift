//
//  ARKitViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 06.04.2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import UIKit
import ARKit
import SceneKit
import Vision

@available(iOS 11.0, *)
class ARKitViewController: UIViewController, ARSCNViewDelegate,SCNSceneRendererDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    let barcodeHandler: BarcodeHandler = BarcodeHandler()
    let arHandler: ARHandler = ARHandler()
    var viewModel: ARKitViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.delegate = self
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        self.setupView()
    }
    
    @IBAction func startSearchingQR(_ sender: Any) {
        self.viewModel?.isSearchingActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.arHandler.startSession(sceneView: self.sceneView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.arHandler.pauseSession(sceneView: self.sceneView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupView() {
        self.viewModel = ARKitViewModel(barcodeHandler: self.barcodeHandler)
        self.viewModel?.setupDelegates(viewController: self)
        self.sceneView.delegate = self
        self.arHandler.setupARScene(sceneView: self.sceneView)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if self.viewModel!.isSearchingActive {
            guard let image = self.sceneView.session.currentFrame?.capturedImage else { return }
            self.viewModel?.analize(image: image)
            let parentNode = self.sceneView.scene.rootNode.childNodes.filter{$0.name == "parent"}.first
            let textNode = parentNode?.childNodes.filter{$0.name == "text"}.first
            let constraint = SCNLookAtConstraint(target: self.sceneView.pointOfView)
            constraint.isGimbalLockEnabled = true
            parentNode?.constraints = [constraint]
            textNode?.eulerAngles = SCNVector3Make(0, .pi, 0)
        }
    }
}
@available(iOS 11.0, *)
extension ARKitViewController: QRNodeDelegate {
    func showNodeOnQR(node: SCNNode) {
        let nodes = self.sceneView.scene.rootNode.childNodes
        nodes.forEach { $0.removeFromParentNode() }
        let parentNode = SCNNode()
        parentNode.name = "parent"
        parentNode.addChildNode(node)
//        let textNode = self.addTextNode(node: node)
//        let textPosition = SCNVector3Make(node.position.x, node.position.y + 0.1, node.position.z)
//        textNode.position = textPosition
//        parentNode.addChildNode(textNode)
        self.sceneView.scene.rootNode.addChildNode(parentNode)
        self.viewModel?.isSearchingActive = false
    }
    
    private func addTextNode(node: SCNNode) -> SCNNode {
        let textNode = SCNNode(geometry: SCNText(string: "Znaleziono", extrusionDepth: 0.1))
        textNode.name = "text"
        let scale: Float = 1/300
        
        let (min, max) = textNode.boundingBox
        let tx: Float = min.x + (max.x - min.x)/2
        let ty: Float = min.y + (max.y - min.y)/2
        let tz: Float = min.z + (max.z - min.z)/2
        textNode.pivot = SCNMatrix4MakeTranslation(tx, ty, tz)
        textNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        textNode.scale = SCNVector3Make(scale,scale,scale)
        
        return textNode
    }
}
@available(iOS 11.0, *)
extension ARKitViewController: BarcodeDelegate {
    func hitTest(point: CGPoint) -> ARHitTestResult? {
        let results = self.sceneView.hitTest(self.sceneView.convertFromCamera(point), types: .featurePoint)
        return results.first
    }
}

@available(iOS 11.0, *)
extension ARKitViewController {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        guard let planeNode = self.viewModel?.foundPlane(planeAnchor: planeAnchor) else { return }
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        node.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
        }
        guard let planeNode = self.viewModel?.foundPlane(planeAnchor: planeAnchor) else { return }
        node.addChildNode(planeNode)
    }
}
