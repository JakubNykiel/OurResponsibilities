//
//  AddAwardViewModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 17/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase
import RxSwift

class AddAwardViewModel {
    
    private let firebaseManager: FirebaseManager = FirebaseManager()
    private let disposeBag = DisposeBag()
    var groupID: String
    var groupModel: GroupModel
    var awardModel: AwardModel?
    var awardModelToUpdate: Variable<[String:AwardModel]?> = Variable(nil)
    
    init(groupId: String, groupModel: GroupModel, awardModel: [String:AwardModel]?) {
        self.groupID = groupId
        self.groupModel = groupModel
        self.awardModelToUpdate.value = awardModel
    }
    
    func addTaskToDatabase() {
        let batch = self.firebaseManager.db.batch()
        guard let awardData = awardModel.asDictionary() else { return }
        let awardRef = FirebaseReferences().awardRef.document()
        batch.setData(awardData, forDocument: awardRef)
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write succeeded.")
                self.addAwardToGroup(awardRef.documentID)
            }
        }
    }
    
    private func addAwardToGroup(_ awardID: String) {
        var awards: [String] = []
        let groupRef = FirebaseReferences().groupRef.document(self.groupID)
        
        groupRef.getDocument { (document,error) in
            if let document = document {
                guard let data = document.data() else { return }
                awards = data[FirebaseModel.awards.rawValue] as? [String] ?? []
                awards.append(awardID)
                groupRef.setData(["awards": awards], merge: true)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func updateAward() {
        guard let awardKey = self.awardModelToUpdate.value?.first?.key else { return }
        guard let model = self.awardModel else { return }
        guard let awardData = model.asDictionary() else { return }
        
        let awardRef = FirebaseReferences().awardRef.document(awardKey)
        awardRef.setData(awardData, merge: true)
    }
}
