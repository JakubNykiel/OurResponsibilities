//
//  BarcodeHandler.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 06.04.2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import ARKit
import Vision

@available(iOS 11.0, *)
protocol BarcodeDelegate: class {
    func hitTest(point: CGPoint) -> ARHitTestResult?
}

@available(iOS 11.0, *)
class BarcodeHandler {
    
    private(set) var barcodeRequest: VNDetectBarcodesRequest!
    private(set) var viewModel: ARKitViewModel!
    weak var delegate: BarcodeDelegate?
    
    init() {
        weak var weakSelf = self
        self.barcodeRequest = VNDetectBarcodesRequest(completionHandler: weakSelf?.completion)
    }
    
    private func completion(request: VNRequest, error: Error?) {
        for result in request.results! {
            if let barcode = result as? VNBarcodeObservation {
                DispatchQueue.main.async {
                    print("Description: \(barcode.payloadStringValue)")
                    self.addNode(barcode: barcode)
                }
            }
        }
    }
    
    func inject(viewModel: ARKitViewModel) {
        self.viewModel = viewModel
    }
    
    private func addNode(barcode: VNBarcodeObservation) {
        guard let qrID = barcode.payloadStringValue else { return }
        guard let worldTransform = self.generateQRPosition(barcode) else { return }
        self.viewModel.foundQR(worldTransform: worldTransform, qrID: qrID)
    }
    
    private func generateQRPosition(_ barcode: VNBarcodeObservation) -> simd_float4x4? {
        guard let br = self.delegate?.hitTest(point: barcode.bottomRight) else { return nil }
        return br.worldTransform
    }
}
