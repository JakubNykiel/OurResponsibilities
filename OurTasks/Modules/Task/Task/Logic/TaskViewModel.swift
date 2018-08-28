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
    
    var taskModel: TaskModel
    var taskID: String
    
    private let firebaseManager: FirebaseManager = FirebaseManager()
    private let disposeBag = DisposeBag()
    private let dateFormatter = DateFormatter()
    
    init(taskModel: TaskModel, taskID: String) {
        self.dateFormatter.dateFormat = "dd.MM.yyyy"
        self.taskModel = taskModel
        self.taskID = taskID
        
        self.bindTask()
    }
    
    private func bindTask() {
        let userRef = FirebaseReferences().userRef.document(self.taskModel.owner)
        userRef.getDocument { (document, error) in
            if let document = document {
                guard let data = document.data() else { return }
                let userModel: UserModel = try! FirebaseDecoder().decode(UserModel.self, from: data)
                self.taskName.value = self.taskModel.name
                self.taskDate.value = self.taskModel.endDate
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
