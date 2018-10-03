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
    var viewState: AddTaskViewState?
    var position: [Float]?
    var scale: [Float]?
    var eventID: String
    var groupID: String
    var qrCode: QRCode?
    
    init(groupID: String, eventID: String, state: AddTaskViewState, position: [Float]?, scale: [Float]?, taskModel: [String:TaskModel]?) {
        self.groupID = groupID
        self.eventID = eventID
        self.viewState = state
        self.taskModelToUpdate = taskModel
        self.position = position
        self.scale = scale
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
    
    func removeTask() {
        guard let id = self.taskModelToUpdate?.first?.key else { return }
        guard let user = self.taskModelToUpdate?.first?.value.user else { return }

        let taskRef = FirebaseReferences().taskRef.document(id)
        let userRef = FirebaseReferences().userRef.document(user)
        let eventRef = FirebaseReferences().eventRef.document(self.eventID)
        
        userRef.getDocument { (document,error) in
            if let document = document {
                guard let data = document.data() else { return }
                let tasks: [String] = data[FirebaseModel.tasks.rawValue] as? [String] ?? []
                let taskToUpdate: [String] = tasks.filter{ $0 != id}
                userRef.updateData([FirebaseModel.tasks.rawValue : taskToUpdate])
            } else {
                print("Document does not exist")
            }
        }
        
        eventRef.getDocument { (document,error) in
            if let document = document {
                guard let data = document.data() else { return }
                let tasks: [String] = data[FirebaseModel.tasks.rawValue] as? [String] ?? []
                let taskToUpdate: [String] = tasks.filter{ $0 != id}
                eventRef.updateData([FirebaseModel.tasks.rawValue : taskToUpdate])
            } else {
                print("Document does not exist")
            }
        }
        
        taskRef.delete(completion: { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Event successfully removed!")
            }
        })
        
        
    }
    
}
