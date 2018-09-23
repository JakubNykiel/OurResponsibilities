//
//  AddQRViewModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 22/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import CodableFirebase
import Firebase
import RxSwift

class AddQRViewModel {
    var groupID: String
    var user: [String:UserModel] = [:]
    var qrGenerated: Variable<Bool> = Variable(false)
    var qrModel: QRCodeModel?
    
    init(groupID: String) {
        self.groupID = groupID
    }
    
    func generateQR() {
        let qrRef = FirebaseReferences().qrRef.document()
        let groupRef = FirebaseReferences().groupRef.document(self.groupID)
        
        guard let qrData = qrModel.asDictionary() else { return }
        qrRef.setData(qrData)
        
        groupRef.getDocument(completion: { (document, error) in
            if let document = document {
                guard let groupData = document.data() else { return }
                var codes = groupData["codes"] as? [String] ?? []
                codes.append(qrRef.documentID)
                groupRef.setData(["codes":codes], merge: true)
            } else {
                print("Group not exist")
            }
        })
        
        guard let qrImage = self.generateQRCode(from: qrRef.documentID) else { return }
        self.uploadImage(qrImage, uid: qrRef.documentID)
        
        
    }
    
    private func uploadImage(_ image: UIImage, uid: String) {
        if let data = UIImagePNGRepresentation(image){
            // set upload path
            let filePath = "\(uid)" // path where you wanted to store img in storage
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            
            let storageRef = Storage.storage().reference()
            storageRef.child(filePath).putData(data as Data, metadata: metaData){(metaData,error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }else{
                    //store downloadURL
                    print("Upload image complete")
                    
                }
            }
        } else {
            
        }
    }
    
    private func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                let context:CIContext = CIContext.init(options: nil)
                let cgImage:CGImage = context.createCGImage(output, from: output.extent)!
                let image:UIImage = UIImage.init(cgImage: cgImage)
                return image
            }
        }
        
        return nil
    }
    
}
