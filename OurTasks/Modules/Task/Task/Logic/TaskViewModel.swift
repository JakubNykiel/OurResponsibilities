//
//  TaskViewModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 27/08/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import RxSwift
import Firebase
import CodableFirebase

enum TaskViewState {
    case unassignedTaskUser
    case user
    case viewer
    case admin
}

class TaskViewModel {
    
    var taskName: Variable<String> = Variable("")
    var taskOwner: Variable<String> = Variable("")
    var taskDate: Variable<String> = Variable("")
    var eventPositivePoints: Variable<String> = Variable("")
    var eventNegativePoints: Variable<String> = Variable("")
    var generalPoints: Variable<String> = Variable("")
    var description: Variable<String> = Variable("")
    
    var taskViewState: Variable<TaskViewState> = Variable(TaskViewState.admin)
    
    var taskModel: Variable<TaskModel?> = Variable(nil)
    var taskID: String
    
    private let firebaseManager: FirebaseManager = FirebaseManager()
    private let disposeBag = DisposeBag()
    private let dateFormatter = DateFormatter()
    
    init(taskID: String) {
        self.dateFormatter.dateFormat = "dd.MM.yyyy"
        self.taskID = taskID
    }
    
    private func checkTaskViewState() {
        let currentUserID = self.firebaseManager.getCurrentUserUid()
        if self.taskModel.value?.owner == currentUserID {
            self.taskViewState.value = .admin
        } else {
            if currentUserID == self.taskModel.value?.user {
                self.taskViewState.value = .user
            } else if self.taskModel.value?.user == "" {
                self.taskViewState.value = .unassignedTaskUser
            } else {
                self.taskViewState.value = .viewer
            }
        }
    }
    
    func bindTask() {
        let taskRef = FirebaseReferences().taskRef.document(self.taskID)
        taskRef.getDocument { (document, error) in
            if let document = document {
                guard let data = document.data() else { return }
                let taskModel: TaskModel = try! FirebaseDecoder().decode(TaskModel.self, from: data)
                self.taskModel.value = taskModel
                self.checkTaskViewState()
                self.bindUser(model: taskModel)
            } else {
                print("User does not exist")
            }
        }
    }
    
    private func bindUser(model: TaskModel) {
        guard let userID = model.user, model.user != "" else {
            setTaskValues(model)
            return
        }
        let userRef = FirebaseReferences().userRef.document(userID)
        userRef.getDocument { (document, error) in
            if let document = document {
                guard let data = document.data() else { return }
                let userModel: UserModel = try! FirebaseDecoder().decode(UserModel.self, from: data)
                self.taskOwner.value = userModel.username
                self.setTaskValues(model)
            } else {
                print("User does not exist")
            }
        }
    }
    
    private func setTaskValues(_ model: TaskModel) {
        self.taskName.value = model.name
        self.taskDate.value = model.endDate
        self.eventNegativePoints.value = String(model.negativePoints)
        self.eventPositivePoints.value = String(model.positivePoints)
        self.generalPoints.value = String(model.globalPositivePoints)
        self.description.value = model.description
    }
    
    func updateTaskState(_ state: TaskState) {
        _ = FirebaseReferences().taskRef.document(self.taskID).setData(["state": state.rawValue], merge: true)
    }
    
    func resignFromTask() {
        let currentUserUID = self.firebaseManager.getCurrentUserUid()
        
        _ = FirebaseReferences().taskRef.document(self.taskID).setData(["user": ""], merge: true)
        
        let userRef = FirebaseReferences().userRef.document(currentUserUID)
        userRef.getDocument { (document, error) in
            if let document = document {
                guard let data = document.data() else { return }
                var tasks = data[FirebaseModel.tasks.rawValue] as? [String] ?? []
                if let index = tasks.index(of: self.taskID) {
                    tasks.remove(at: index)
                    userRef.updateData([FirebaseModel.tasks.rawValue : tasks])
                }
            } else {
                print("User does not exist")
            }
        }
        
        self.savePointsToDatabase(points: self.taskModel.value?.negativePoints ?? 0)
    }
    
    func doneTask() {
        
    }
    
    
    private func savePointsToDatabase(points: Int) {
        let currentUserUID = self.firebaseManager.getCurrentUserUid()
        guard let eventID = self.taskModel.value?.eventID else { return }
        guard let groupID = self.taskModel.value?.groupID else { return }
        let eventRef = FirebaseReferences().eventRef.document(eventID)
        let groupRef = FirebaseReferences().groupRef.document(groupID)
       
        if points <= 0 {
            eventRef.getDocument { (document, error) in
                if let document = document {
                    guard let data = document.data() else { return }
                    var users = data[FirebaseModel.users.rawValue] as? [String:Int] ?? [:]
                    guard var userPoints = users[currentUserUID] else { return }
                    userPoints = userPoints + points
                    eventRef.updateData(["users":userPoints])
                } else {
                    print("User does not exist")
                }
            }
            
            groupRef.getDocument { (document, error) in
                if let document = document {
                    guard let data = document.data() else { return }
                    var users = data[FirebaseModel.users.rawValue] as? [String:Int] ?? [:]
                    guard var userPoints = users[currentUserUID] else { return }
                    userPoints = userPoints + points
                    groupRef.updateData(["users":userPoints])
                } else {
                    print("User does not exist")
                }
            }
        } else {
            
        }
    }
}
