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
import RxSwift
import Vision

@available(iOS 11.0, *)
class ARKitViewController: UIViewController, ARSCNViewDelegate,SCNSceneRendererDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var surfaceBtn: UIButton!
    @IBOutlet weak var qrBtn: UIButton!
    @IBOutlet weak var removeBtn: UIButton!
    let barcodeHandler: BarcodeHandler = BarcodeHandler()
    let arHandler: ARHandler = ARHandler()
    var viewModel: ARKitViewModel?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.delegate = self
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.viewModel?.planeDetected.asObservable()
//            .subscribe(onNext: {
////                self.removeBtn.isHidden = !$0
//                
//            }).disposed(by: disposeBag)
        self.arHandler.startSession(sceneView: self.sceneView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.arHandler.pauseSession(sceneView: self.sceneView)
    }
    
    @IBAction func startSearchingPlane(_ sender: Any) {
//        let nodes = self.sceneView.scene.rootNode.childNodes
//        if nodes.count > 2 {
//            nodes.last?.removeFromParentNode()
//        }
        self.viewModel?.detectingActive.value = true
        print("Szukam plane")
        
    }
    @IBAction func removePlane(_ sender: Any) {
        let lastNode = self.sceneView.scene.rootNode.childNodes.last
        lastNode?.removeFromParentNode()
    }
    @IBAction func startSearchingQR(_ sender: Any) {
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        self.surfaceBtn.isEnabled = false
        self.surfaceBtn.alpha = 0.5
        self.viewModel?.isSearchingActive = true
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
        self.prepareBtn()
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
        self.surfaceBtn.alpha = 1.0
        self.surfaceBtn.isEnabled = true
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
        guard let detectingActive = self.viewModel?.detectingActive.value else { return }
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        guard let planeNode = self.viewModel?.foundPlane(planeAnchor: planeAnchor) else { return }
        if detectingActive {
            node.addChildNode(planeNode)
            self.viewModel?.detectingActive.value = false
            self.viewModel?.planeDetected.value = true
        }
    }
    
//    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//        guard let detectingActive = self.viewModel?.detectingActive.value else { return }
//        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
//        guard let planeNode = self.viewModel?.foundPlane(planeAnchor: planeAnchor) else { return }
//        if detectingActive {
//            let lastNode = self.sceneView.scene.rootNode.childNodes.last
//            lastNode?.removeFromParentNode()
//            node.addChildNode(planeNode)
//            self.viewModel?.detectingActive.value = false
//            self.viewModel?.planeDetected.value = true
//        }
//    }
}
//MARK: Prepare
@available(iOS 11.0, *)
extension ARKitViewController {
    func prepareBtn() {
        self.removeBtn.layer.borderColor = UIColor.red.cgColor
        self.removeBtn.layer.borderWidth = 2
        self.removeBtn.layer.cornerRadius = self.removeBtn.layer.bounds.height / 2
        self.removeBtn.isHidden = true
        
        self.surfaceBtn.isEnabled = false
        self.surfaceBtn.alpha = 0.5
        
    }
}
