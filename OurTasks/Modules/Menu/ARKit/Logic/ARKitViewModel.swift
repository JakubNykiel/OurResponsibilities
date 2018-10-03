//
//  ARKitViewModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 06.04.2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit
import Vision
import ARKit
import SceneKit
import RxSwift

enum QRState {
    case search
    case find
    case task
}

protocol QRNodeDelegate {
    func showNodeOnQR(node: SCNNode)
}

@available(iOS 11.0, *)
class ARKitViewModel {
    
    private let firebaseManager = FirebaseManager()
    var planeDetected: Variable<Bool> = Variable(false)
    var detectingActive: Variable<Bool> = Variable(false)
    var automaticEnabled: Variable<Bool> = Variable(true)
    var planeDetecting: Bool = false
    let barcodeHandler: BarcodeHandler
    private var delegate: QRNodeDelegate?
    var isSearchingActive: Bool = false
    var userTasks: [SCNNode] = []
    var qrID: Variable<String> = Variable("")
    var qrName: String = ""
    var groupID: String
    var groupModel: GroupModel
    var isAdmin: Variable<Bool> = Variable(false)
    
    private var disposeBag = DisposeBag()
    
    init(barcodeHandler: BarcodeHandler, groupID: String, groupModel: GroupModel) {
        let currentUserUID = self.firebaseManager.getCurrentUserUid()
        self.isAdmin.value = groupModel.admins.contains(currentUserUID) ? true : false
        self.barcodeHandler = barcodeHandler
        self.groupID = groupID
        self.groupModel = groupModel
        self.barcodeHandler.inject(viewModel: self)
    }
    
    func foundQR(worldTransform: simd_float4x4, qrID: String) {
        self.qrID.value = qrID
        self.getQRData(qrID)
        let boxNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
        let qrMaterial = SCNMaterial()
        qrMaterial.diffuse.contents = #imageLiteral(resourceName: "qrNode")
        qrMaterial.isDoubleSided = false
        boxNode.simdWorldTransform = worldTransform
        boxNode.geometry?.materials = [qrMaterial]
        self.delegate?.showNodeOnQR(node: boxNode)
//        self.planeDetecting = true
    }
    
    func analize(image: CVImageBuffer) {
        let imageHandler = VNImageRequestHandler(cvPixelBuffer: image, options: [:])
        do {
            let barcodeRequest: VNDetectBarcodesRequest = self.barcodeHandler.barcodeRequest
            try imageHandler.perform([barcodeRequest])
        }
        catch {
            print("error")
        }
    }
    
    func setupDelegates(viewController: ARKitViewController) {
        self.barcodeHandler.delegate = viewController
        self.delegate = viewController
    }
    
    func addTask(_ position: SCNVector3) -> SCNNode {
        let taskNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
        let taskMaterial = SCNMaterial()
        taskMaterial.diffuse.contents = #imageLiteral(resourceName: "task")
        taskMaterial.isDoubleSided = false
        taskNode.geometry?.materials = [taskMaterial]
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -0.2
//        taskNode.simdWorldTransform = matrix_multiply(position, translation)
        taskNode.position = position
        self.userTasks.append(taskNode)
        return taskNode
        
    }
    
    func updatePositionAndOrientationOf(_ node: SCNNode, withPosition position: SCNVector3, relativeTo referenceNode: SCNNode) {
        let referenceNodeTransform = matrix_float4x4(referenceNode.transform)
        
        // Setup a translation matrix with the desired position
        var translationMatrix = matrix_identity_float4x4
        translationMatrix.columns.3.x = position.x
        translationMatrix.columns.3.y = position.y
        translationMatrix.columns.3.z = position.z
        
        // Combine the configured translation matrix with the referenceNode's transform to get the desired position AND orientation
        let updatedTransform = matrix_multiply(referenceNodeTransform, translationMatrix)
        node.transform = SCNMatrix4(updatedTransform)
    }
    
    private func getQRData(_ id: String) {
        let qrRef = FirebaseReferences().qrRef.document(id)
        qrRef.getDocument { (document,error) in
            if let document = document {
                guard let data = document.data() else { return }
                guard let groupID = data["groupID"] as? String else { return }
                guard let main = data["main"] as? Bool else { return }
                guard let name = data["name"] as? String else { return }
                self.qrName = name
                self.groupID = groupID
                if main {
//                    getAllTaskForGroupWhenARIsOn
                } else {
                    // get only my tasks when ar on
                    guard let user = data["user"] as? String else { return }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
}


