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

class TaskViewModel {
    
    var taskName: Variable<String> = Variable("")
    var taskOwner: Variable<String> = Variable("")
    var taskDate: Variable<String> = Variable("")
    
    var taskModel: Variable<TaskModel?> = Variable(nil)
    var taskID: String
    
    private let firebaseManager: FirebaseManager = FirebaseManager()
    private let disposeBag = DisposeBag()
    private let dateFormatter = DateFormatter()
    
    init(taskID: String) {
        self.dateFormatter.dateFormat = "dd.MM.yyyy"
        self.taskID = taskID
    }
    
    func bindTask() {
        let taskRef = FirebaseReferences().taskRef.document(self.taskID)
        taskRef.getDocument { (document, error) in
            if let document = document {
                guard let data = document.data() else { return }
                let taskModel: TaskModel = try! FirebaseDecoder().decode(TaskModel.self, from: data)
                self.taskModel.value = taskModel
                self.bindUser(model: taskModel)
            } else {
                print("User does not exist")
            }
        }
    }
    
    private func bindUser(model: TaskModel) {
        let userRef = FirebaseReferences().userRef.document(model.owner)
        userRef.getDocument { (document, error) in
            if let document = document {
                guard let data = document.data() else { return }
                let userModel: UserModel = try! FirebaseDecoder().decode(UserModel.self, from: data)
                self.taskName.value = model.name
                self.taskDate.value = model.endDate
                self.taskOwner.value = userModel.username
            } else {
                print("User does not exist")
            }
        }
    }
    
    func updateTaskState(_ state: TaskState) {
        let taskRef = FirebaseReferences().taskRef.document(self.taskID).setData(["state": state.rawValue], merge: true)
    }
}
