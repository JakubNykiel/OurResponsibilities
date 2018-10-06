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
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var qrBtn: UIButton!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var addTaskBtn: UIButton!
    let barcodeHandler: BarcodeHandler = BarcodeHandler()
    let arHandler: ARHandler = ARHandler()
    var viewModel: ARKitViewModel?
    private let disposeBag = DisposeBag()
    private var timer = Timer()
    private var taskAdded: Bool = false
    private var planeAdded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.sceneView.delegate = self
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bindData()
        self.viewModel?.planeDetecting = false
        self.addTaskBtn.isHidden = true
        self.searchBtn.isHidden = true
        self.qrBtn.isHidden = false
        self.arHandler.startSession(sceneView: self.sceneView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer.invalidate()
        self.timer = Timer()
        self.navigationController?.isNavigationBarHidden = false
        self.arHandler.pauseSession(sceneView: self.sceneView)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let currentTouchLocation = touches.first?.location(in: self.sceneView) else { return }
        let hitTestResults = self.sceneView.hitTest(currentTouchLocation, options: nil)
        let resultFilter = hitTestResults.filter{ $0.node.name != nil }.first
        guard let node = resultFilter?.node else { return }
        self.presentTaskDetails(node)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func addTaskAction(_ sender: Any) {
        if !(self.viewModel?.planeDetecting)! {
            self.viewModel?.planeDetecting = true
        } else {
            guard let taskNode = self.sceneView.scene.rootNode.childNodes.last else { return }
            self.presentGroupEvent(node: taskNode)
        }
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func searchTaskAction(_ sender: Any) {
        guard let main = self.viewModel?.qrMain else { return }
        if main {
            self.viewModel?.getARUnassignedTasks()
        } else {
            self.viewModel?.getUserARTasks()
        }
    }
    
    //    @IBAction func removePlane(_ sender: Any) {
    //        let lastNode = self.sceneView.scene.rootNode.childNodes.filter{$0.name == "parent"}.last
    //        lastNode?.removeFromParentNode()
    //        self.removeBtn.isHidden = true
    //    }
    
    @IBAction func startSearchingQR(_ sender: Any) {
        let nodes = self.sceneView.scene.rootNode.childNodes.filter{$0.name == "parent"}
        nodes.forEach({
            $0.removeFromParentNode()
        })
        self.viewModel?.isSearchingActive = true
        
        if self.viewModel?.automaticEnabled.value ?? true {
            self.viewModel?.isSearchingActive = true
            self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(actionAfterDelay(_:)), userInfo: nil, repeats: true)
        } else {
            self.viewModel?.isSearchingActive = false
            self.addQRToScene()
        }
    }
    
    @objc func actionAfterDelay(_ sender: Any) {
        if self.viewModel?.isSearchingActive ?? true {
            self.viewModel?.isSearchingActive = false
            let alert = UIAlertController(title: "Nie znaleziono QR code", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Wyszukaj ponownie", style: .default, handler: { action in
                self.viewModel?.isSearchingActive = true
                self.viewModel?.automaticEnabled.value = true
                self.startSearchingQR(sender)
                
            }))
            alert.addAction(UIAlertAction(title: "Dodaj ręcznie", style: .cancel, handler: { action in
                self.viewModel?.automaticEnabled.value = false
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    private func setupView() {
        self.registerGestureRecognizers()
        self.viewModel?.setupDelegates(viewController: self)
        self.sceneView.delegate = self
        self.arHandler.setupARScene(sceneView: self.sceneView)
        self.prepareBtn()
    }
    
    func addQRToScene() {
        let boxNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
        boxNode.name = "ManualQR"
        let qrMaterial = SCNMaterial()
        qrMaterial.diffuse.contents = #imageLiteral(resourceName: "qrNode")
        qrMaterial.isDoubleSided = false
        boxNode.geometry?.materials = [qrMaterial]
        self.sceneView.pointOfView?.addChildNode(boxNode)
        self.viewModel?.automaticEnabled.value = true
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeDetectingActive = self.viewModel?.planeDetecting,
            let isAdmin = self.viewModel?.isAdmin.value else { return }
        if planeDetectingActive && isAdmin {
            guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
            let width = CGFloat(planeAnchor.extent.x)
            let height = CGFloat(planeAnchor.extent.z)
            let plane = SCNPlane(width: width, height: height)
            
            plane.materials.first?.diffuse.contents = AppColor.planeBlue
            
            let planeNode = SCNNode(geometry: plane)
            
            let x = CGFloat(planeAnchor.center.x)
            let y = CGFloat(planeAnchor.center.y)
            let z = CGFloat(planeAnchor.center.z)
            planeNode.position = SCNVector3(x,y,z)
            planeNode.eulerAngles.x = -.pi / 2
            
            node.addChildNode(planeNode)
        }
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeDetectingActive = self.viewModel?.planeDetecting,
            let isAdmin = self.viewModel?.isAdmin.value else { return }
        if planeDetectingActive && isAdmin {
            guard let planeAnchor = anchor as?  ARPlaneAnchor,
                let planeNode = node.childNodes.first,
                let plane = planeNode.geometry as? SCNPlane
                else { return }
            let width = CGFloat(planeAnchor.extent.x)
            let height = CGFloat(planeAnchor.extent.z)
            plane.width = width
            plane.height = height
            
            let x = CGFloat(planeAnchor.center.x)
            let y = CGFloat(planeAnchor.center.y)
            let z = CGFloat(planeAnchor.center.z)
            planeNode.position = SCNVector3(x, y, z)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if self.viewModel!.isSearchingActive {
            guard let image = self.sceneView.session.currentFrame?.capturedImage else { return }
            self.viewModel?.analize(image: image)
        }
    }
    
    @objc func addToSceneView(withGestureRecognizer recognizer: UIGestureRecognizer) {
        if !taskAdded {
            self.taskAdded = true
            let tapLocation = recognizer.location(in: sceneView)
            let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
            
            guard let hitTestResult = hitTestResults.first else { return }
            let translation = hitTestResult.worldTransform.columns.3
            let x = translation.x
            let y = translation.y
            let z = translation.z
            
            let position = SCNVector3(x,y,z)
            guard let taskNode = self.viewModel?.addTask(position) else { return }
            sceneView.scene.rootNode.addChildNode(taskNode)
            self.viewModel?.planeDetecting = false
            if (self.viewModel?.isAdmin.value)! {
                self.addTaskBtn.isHidden = false
                //            self.removeBtn.isHidden = false
            }
            
        }
        
    }
}
@available(iOS 11.0, *)
extension ARKitViewController: QRNodeDelegate {
    func showNodeOnQR(node: SCNNode) {
        let parentNode = SCNNode()
        parentNode.name = "parent"
        parentNode.addChildNode(node)
        
        self.sceneView.scene.rootNode.addChildNode(parentNode)
        self.viewModel?.isSearchingActive = false
        self.qrBtn.isEnabled = false
        self.searchBtn.isHidden = false
        self.addTaskBtn.isHidden = false
        self.qrBtn.alpha = 0.5
        DispatchQueue.performAction(after: 3.0) {
            self.qrBtn.isEnabled = true
            self.qrBtn.alpha = 1.0
        }
    }
    
    //    private func addTextNode(node: SCNNode) -> SCNNode {
    //        let textNode = SCNNode(geometry: SCNText(string: "Znaleziono", extrusionDepth: 0.1))
    //        textNode.name = "text"
    //        let scale: Float = 1/300
    //
    //        let (min, max) = textNode.boundingBox
    //        let tx: Float = min.x + (max.x - min.x)/2
    //        let ty: Float = min.y + (max.y - min.y)/2
    //        let tz: Float = min.z + (max.z - min.z)/2
    //        textNode.pivot = SCNMatrix4MakeTranslation(tx, ty, tz)
    //        textNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
    //        textNode.scale = SCNVector3Make(scale,scale,scale)
    //
    //        return textNode
    //    }
    
    private func presentGroupEvent(node: SCNNode) {
        guard let viewModel = self.viewModel else { return }
        var position: [Float] = []
        position.append(node.position.x)
        position.append(node.position.y)
        position.append(node.position.z)
        var scale: [Float] = []
        scale.append(node.scale.x)
        scale.append(node.scale.y)
        scale.append(node.scale.z)
        
        let destinationVC = StoryboardManager.arEventListViewController(groupID: viewModel.groupID, groupModel: viewModel.groupModel, qrID: self.viewModel?.qrID.value ?? "", position: position, scale: scale)
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
}
@available(iOS 11.0, *)
extension ARKitViewController: BarcodeDelegate {
    func hitTest(point: CGPoint) -> ARHitTestResult? {
        let results = self.sceneView.hitTest(self.sceneView.convertFromCamera(point), types: .featurePoint)
        return results.first
    }
}
//MARK: Prepare
@available(iOS 11.0, *)
extension ARKitViewController {
    func prepareBtn() {
        self.removeBtn.layer.borderColor = UIColor.red.cgColor
        self.removeBtn.layer.borderWidth = 2
        self.removeBtn.layer.cornerRadius = self.removeBtn.layer.bounds.height / 2
        self.removeBtn.isHidden = true
    }
    
    func bindData() {
        self.viewModel?.unassignedARTasks.asObservable()
            .subscribe(onNext: {
                guard let qrNode = self.sceneView.scene.rootNode.childNodes.filter({$0.name == "parent"}).first else { return }
                for task in $0 {
                    guard let ARposition = task.ARposition,
                        let ARscale = task.ARscale else { return }
                    let position: SCNVector3 = SCNVector3(ARposition[0], ARposition[1], ARposition[2])
                    let scale: SCNVector3 = SCNVector3(ARscale[0],ARscale[1],ARscale[2])
                    guard let taskNode = self.viewModel?.addTask(position) else { return }
                    taskNode.name = task.name
                    taskNode.scale = scale
                    self.sceneView.scene.rootNode.addChildNode(taskNode)
                    
                }
            }).disposed(by: self.disposeBag)
        
        self.viewModel?.userARTasks.asObservable()
            .subscribe(onNext: {
                guard let qrNode = self.sceneView.scene.rootNode.childNodes.filter({$0.name == "parent"}).first else { return }
                for task in $0 {
                    guard let ARposition = task.1.ARposition,
                        let ARscale = task.1.ARscale else { return }
                    let position: SCNVector3 = SCNVector3(ARposition[0], ARposition[1], ARposition[2])
                    let scale: SCNVector3 = SCNVector3(ARscale[0],ARscale[1],ARscale[2])
                    guard let taskNode = self.viewModel?.addTask(position) else { return }
                    taskNode.name = task.1.name
                    taskNode.scale = scale
                    self.sceneView.scene.rootNode.addChildNode(taskNode)
                }
            }).disposed(by: self.disposeBag)
    }
}
//MARK: Gestures
@available(iOS 11.0, *)
extension ARKitViewController {
    
    func registerGestureRecognizers() {
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
        let tapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ARKitViewController.addToSceneView(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        self.sceneView.addGestureRecognizer(pinchGestureRecognizer)
        //        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func changeDistanceFromCamera(_ node: SCNNode, newValue: CGFloat) {
        let position = node.position
    }
    
    @objc func toggleSlider(sender: UITapGestureRecognizer) {
        let sceneView = sender.view as! ARSCNView
        let tapLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(tapLocation)
        
        if !hitTest.isEmpty && hitTest.first!.node.name != "parent" {
            let results = hitTest.first!
            let node = results.node
        }
    }
    
    @objc func pinch(sender: UIPinchGestureRecognizer) {
        let sceneView = sender.view as! ARSCNView
        let pinchLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(pinchLocation)
        
        if !hitTest.isEmpty && hitTest.first!.node.name != "parent" {
            let results = hitTest.first!
            let node = results.node
            let pinchAction = SCNAction.scale(by: sender.scale, duration: 0)
            print(sender.scale)
            node.runAction(pinchAction)
            sender.scale = 1.0
        }
    }
    
    func presentTaskDetails(_ node: SCNNode) {
        guard let taskID = self.viewModel?.getNodeTask(node) else { return }
        let destinationVC = StoryboardManager.taskViewController(taskID)
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
}
