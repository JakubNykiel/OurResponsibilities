//
//  ShowQRViewModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 23/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import RxSwift
import Firebase
import CodableFirebase

class ShowQRViewModel {
    var groupID: String
    var qrID: String
    var qrImage: Variable<UIImage?> = Variable(nil)
    
    init(qrID: String, groupID: String) {
        self.qrID = qrID
        self.groupID = groupID
        
        self.showQR()
    }
    
    func removeQR() {
        let groupRef = FirebaseReferences().groupRef.document(self.groupID)
        let qrRef = FirebaseReferences().qrRef.document(self.qrID)
        
        qrRef.delete()
        
        groupRef.getDocument { (document,error) in
            if let document = document {
                guard let data = document.data() else { return }
                guard let codes = data["codes"] as? [String] else { return }
                let tempCodes = codes.filter { $0 != self.qrID }
                groupRef.updateData(["codes":tempCodes])
            } else {
                print("Document does not exist")
            }
        }
        
    }
    
    func showQR() {
        let storageRef = Storage.storage().reference(withPath: self.qrID)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
            } else {
                self.qrImage.value = UIImage(data: data!)
            }
        }
    }
}
