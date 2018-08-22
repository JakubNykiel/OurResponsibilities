//
//  AddTaskViewModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 29/07/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import Firebase
import RxSwift

class AddTaskViewModel {
    
    let firebaseManager: FirebaseManager = FirebaseManager()
    var ref: DocumentReference?
    var taskAdded: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var taskModel: TaskModel?
    var arTaskModel: ARTaskModel?
    
    var eventID: String
    var qrCode: QRCode?
    
    init(eventID: String) {
        self.eventID = eventID
    }
    
    func addTaskToDatabase() {
        let batch = self.firebaseManager.db.batch()
        guard let taskData = taskModel.asDictionary() else { return }
        
        let eventRef = FirebaseReferences().taskRef.document()
        batch.setData(taskData, forDocument: eventRef)
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write succeeded.")
                self.addTaskToEvent(id: eventRef.documentID)
            }
        }
    }
    
    private func addTaskToEvent(id: String) {
        let eventRef = FirebaseReferences().eventRef.document(self.eventID)
        
        eventRef.getDocument { (document,error) in
            if let document = document {
                print("Document data: \(String(describing: document.data()))")
                guard let data = document.data() else { return }
                var tasks: [String] = data[FirebaseModel.tasks.rawValue] as? [String] ?? []
                tasks.append(id)
                eventRef.updateData([FirebaseModel.tasks.rawValue : tasks])
                self.taskAdded.onNext(true)
            } else {
                print("Document does not exist")
            }
            
        }
    }
}
