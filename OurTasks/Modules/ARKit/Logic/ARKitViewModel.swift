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

protocol QRNodeDelegate {
    func showNodeOnQR(node: SCNNode)
}

@available(iOS 11.0, *)
class ARKitViewModel {
    
    let barcodeHandler: BarcodeHandler
    private var delegate: QRNodeDelegate?
    var isSearchingActive: Bool = false
    
    init(barcodeHandler: BarcodeHandler) {
        self.barcodeHandler = barcodeHandler
        self.barcodeHandler.inject(viewModel: self)
    }
    
    func foundQR(worldTransform: simd_float4x4) {
        let boxNode = SCNNode(geometry: SCNSphere(radius: 0.1))
        boxNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        boxNode.simdWorldTransform = worldTransform
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
}


