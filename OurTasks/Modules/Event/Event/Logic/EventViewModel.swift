//
//  EventViewModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 19/08/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import RxSwift
import Firebase
import CodableFirebase

class EventViewModel {
    
    var tasksBehaviorSubject: BehaviorSubject<[String:TaskModel]> = BehaviorSubject(value: [:])
    var allTasksBehaviorSubject: BehaviorSubject<[String:TaskModel]> = BehaviorSubject(value: [:])
    var doneTasksBehaviorSubject: BehaviorSubject<[String:TaskModel]> = BehaviorSubject(value: [:])
    var eventUsersBehaviorSubject: BehaviorSubject<[String:UserModel]> = BehaviorSubject(value: [:])
    var noTasksBehaviorSubject: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var sectionsBehaviourSubject: BehaviorSubject<[EventSection]> = BehaviorSubject(value: [])
    var eventName: Variable<String> = Variable("")
    var eventDate: Variable<String> = Variable("")
    var eventPoints: Variable<String> = Variable("")
    
    private let firebaseManager: FirebaseManager = FirebaseManager()
    private let disposeBag = DisposeBag()
    private var sections: [EventSection] = []
    private let dateFormatter = DateFormatter()
    
    var eventTasks: [String:TaskModel] = [:]
    var eventModel: EventModel
    var eventID: String
    
    init(eventModel: EventModel, eventID: String) {
        self.dateFormatter.dateFormat = "dd.MM.yyyy"
        self.eventID = eventID
        self.eventModel = eventModel
        self.getEventTasks()
        
        self.bindGeneralInformation()
        
        self.tasksBehaviorSubject.asObservable()
            .subscribe(onNext: {
                var doneTasks: [String:TaskModel] = [:]
                var restTasks: [String:TaskModel] = [:]
                
                for (index,task) in $0.enumerated() {
                    if TaskState(rawValue: task.value.state) == TaskState.done {
                        doneTasks[task.key] = task.value
                    } else {
                        restTasks[task.key] = task.value
                    }
                    
                    if index == (self.eventTasks.count - 1) && self.eventTasks.count != 0 {
                            self.allTasksBehaviorSubject.onNext(restTasks)
                            self.doneTasksBehaviorSubject.onNext(doneTasks)
                    }
                }
            }).disposed(by: self.disposeBag)
    }
    
    private func bindGeneralInformation() {
        self.eventName.value = self.eventModel.name
        self.eventPoints.value = "winner_points".localize() + " " + String(self.eventModel.winnerGlobalPoints)
        self.eventDate.value = self.eventModel.startDate + " - " + self.eventModel.endDate
        
        self.doneTasksBehaviorSubject
            .flatMap({ (doneTasks) -> Observable<[EventTaskCellModel]> in
                let ret: [EventTaskCellModel] = doneTasks.compactMap({
                    return EventTaskCellModel(id: $0.key, taskModel: $0.value)
                })
                return Observable.of(ret)
            })
            .subscribe(onNext: {
                self.sections = self.sections.filter({
                    $0.title != EventSectionTitle.doneTasks.rawValue
                })
                self.sections.insert(EventSection.section(title: .doneTasks, items: $0.compactMap({EventItemType.doneTasks($0)})), at: 0)
                self.sectionsBehaviourSubject.onNext(self.sections)
            })
            .disposed(by: self.disposeBag)
        
        self.allTasksBehaviorSubject
            .flatMap({ (allTasks) -> Observable<[EventTaskCellModel]> in
                let ret: [EventTaskCellModel] = allTasks.compactMap({
                    return EventTaskCellModel(id: $0.key, taskModel: $0.value)
                })
                return Observable.of(ret)
            })
            .subscribe(onNext: {
                self.sections = self.sections.filter({
                    $0.title != EventSectionTitle.allTasks.rawValue
                })
                self.sections.insert(EventSection.section(title: .allTasks, items: $0.compactMap({EventItemType.allTasks($0)})), at: 1)
                self.sectionsBehaviourSubject.onNext(self.sections)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func getEventTasks() {
        let eventTasksRef = self.firebaseManager.db.collection(FirebaseModel.events.rawValue).document(self.eventID)
        eventTasksRef.getDocument { (document, error) in
            if let document = document {
                guard let data = document.data() else { return }
                guard let tasks: [String] = data["tasks"] as? [String] else { return }
                self.toTaskModel(tasks)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    private func toTaskModel(_ tasks: [String]) {
        if tasks.count == 0 {
            //            self.noEventsBehaviorSubject.onNext(true)
        } else {
            _ = tasks.compactMap({ task in
                let taskRef = FirebaseReferences().taskRef.document(task)
                taskRef.getDocument(completion: { (document, error) in
                    if let document = document {
                        guard let taskData = document.data() else { return }
                        let taskModel = try! FirebaseDecoder().decode(TaskModel.self, from: taskData)
                        self.eventTasks[document.documentID] = taskModel
                        if tasks.count == self.eventTasks.count {
                            self.tasksBehaviorSubject.onNext(self.eventTasks)
                        }
                    } else {
                        print("Task not exist")
                    }
                })
            })
        }
        
    }
}
