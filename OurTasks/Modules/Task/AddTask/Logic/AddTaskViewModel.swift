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

enum AddTaskViewState {
    case add
    case update
}

class AddTaskViewModel {
    
    let firebaseManager: FirebaseManager = FirebaseManager()
    var ref: DocumentReference?
    var taskAdded: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var taskModel: TaskModel?
    var taskModelToUpdate: [String:TaskModel]?
    var taskUser: [String:UserModel]?
    var arTaskModel: ARTaskModel?
    var viewState: AddTaskViewState?
    
    var eventID: String
    var qrCode: QRCode?
    
    init(eventID: String, state: AddTaskViewState, taskModel: [String:TaskModel]?) {
        self.eventID = eventID
        self.viewState = state
        self.taskModelToUpdate = taskModel
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
    
    func updateTask() {
        guard let taskKey = self.taskModelToUpdate?.first?.key else { return }
        guard let model = self.taskModel else { return }
        guard let taskData = model.asDictionary() else { return }
        
        let taskRef = FirebaseReferences().taskRef.document(taskKey)
        taskRef.setData(taskData, merge: true)
    }
    
    private func addTaskToEvent(id: String) {
        let eventRef = FirebaseReferences().eventRef.document(self.eventID)
        
        eventRef.getDocument { (document,error) in
            if let document = document {
                guard let data = document.data() else { return }
                var tasks: [String] = data[FirebaseModel.tasks.rawValue] as? [String] ?? []
                tasks.append(id)
                eventRef.updateData([FirebaseModel.tasks.rawValue : tasks])
                self.addTaskToUser(id: id)
            } else {
                print("Document does not exist")
            }
            
        }
    }
    
    private func addTaskToUser(id: String) {
        guard let model = self.taskUser?.first else { return }
        let userRef = FirebaseReferences().userRef.document(model.key)
        
        userRef.getDocument { (document,error) in
            if let document = document {
                guard let data = document.data() else { return }
                var tasks: [String] = data[FirebaseModel.tasks.rawValue] as? [String] ?? []
                tasks.append(id)
                userRef.updateData([FirebaseModel.tasks.rawValue : tasks])
                self.taskAdded.onNext(true)
            } else {
                print("Document does not exist")
            }
            
        }
    }
    
}
