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
    
    var planeDetected: Variable<Bool> = Variable(false)
    var detectingActive: Variable<Bool> = Variable(false)
    var automaticEnabled: Variable<Bool> = Variable(true)
    let barcodeHandler: BarcodeHandler
    private var delegate: QRNodeDelegate?
    var isSearchingActive: Bool = false
    
    init(barcodeHandler: BarcodeHandler) {
        self.barcodeHandler = barcodeHandler
        self.barcodeHandler.inject(viewModel: self)
    }
    
    func foundQR(worldTransform: simd_float4x4) {
        let boxNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
        let qrMaterial = SCNMaterial()
        qrMaterial.diffuse.contents = #imageLiteral(resourceName: "qrNode")
        qrMaterial.isDoubleSided = false
        boxNode.simdWorldTransform = worldTransform
        boxNode.geometry?.materials = [qrMaterial]
        self.delegate?.showNodeOnQR(node: boxNode)
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
    
    func foundPlane(planeAnchor: ARPlaneAnchor) -> SCNNode {
//        let planeNode = SCNNode(geometry: SCNPlane(width: CGFloat(planeAnchor.extent.z), height: CGFloat(planeAnchor.extent.x)))
        let planeNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
        planeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        planeNode.geometry?.firstMaterial?.isDoubleSided = true
        planeNode.position = SCNVector3(planeAnchor.center.x,planeAnchor.center.y,planeAnchor.center.z)
        return planeNode
        
    }
}


