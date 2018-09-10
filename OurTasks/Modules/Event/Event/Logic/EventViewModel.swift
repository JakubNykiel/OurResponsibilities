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
    var myTasksBehaviorSubject: BehaviorSubject<[String:TaskModel]> = BehaviorSubject(value: [:])
    var allTasksBehaviorSubject: BehaviorSubject<[String:TaskModel]> = BehaviorSubject(value: [:])
    var doneTasksBehaviorSubject: BehaviorSubject<[String:TaskModel]> = BehaviorSubject(value: [:])
    var unassignedTasksBehaviorSubject: BehaviorSubject<[String:TaskModel]> = BehaviorSubject(value: [:])
    var eventUsersBehaviorSubject: BehaviorSubject<[String:UserModel]> = BehaviorSubject(value: [:])
    
    var noMyTasksBehaviorSubject: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var noAllTasksBehaviorSubject: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var noUnassignedTasksBehaviorSubject: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var noDoneTasksBehaviorSubject: BehaviorSubject<Bool> = BehaviorSubject(value: false)
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
    }
    
    func bindGeneralInformation() {
        let currentUserUID = self.firebaseManager.getCurrentUserUid()
        self.eventName.value = self.eventModel.name
        self.eventPoints.value = "winner_points".localize() + " " + String(self.eventModel.winnerGlobalPoints)
        self.eventDate.value = self.eventModel.startDate + " - " + self.eventModel.endDate
        
        self.tasksBehaviorSubject.asObservable()
            .subscribe(onNext: {
                var doneTasks: [String:TaskModel] = [:]
                var unassignedTasks: [String:TaskModel] = [:]
                var allTasks: [String:TaskModel] = [:]
                var myTasks: [String:TaskModel] = [:]
                
                for (index,task) in $0.enumerated() {
                    if TaskState(rawValue: task.value.state) == TaskState.done {
                        doneTasks[task.key] = task.value
                    } else if task.value.user == "" {
                            unassignedTasks[task.key] = task.value
                    }
                    
                    if task.value.user == currentUserUID {
                        myTasks[task.key] = task.value
                    }
                    
                    allTasks[task.key] = task.value
                    if index == (self.eventTasks.count - 1) && self.eventTasks.count != 0 {
                        unassignedTasks.count == 0 ? self.noUnassignedTasksBehaviorSubject.onNext(true) : self.unassignedTasksBehaviorSubject.onNext(unassignedTasks)
                        allTasks.count == 0 ? self.noAllTasksBehaviorSubject.onNext(true) : self.allTasksBehaviorSubject.onNext(allTasks)
                        doneTasks.count == 0 ? self.noDoneTasksBehaviorSubject.onNext(true) : self.doneTasksBehaviorSubject.onNext(doneTasks)
                        myTasks.count == 0 ? self.noMyTasksBehaviorSubject.onNext(true) : self.myTasksBehaviorSubject.onNext(myTasks)
                    }
                }
            }).disposed(by: self.disposeBag)
        
        self.myTasksBehaviorSubject
            .flatMap({ (myTasks) -> Observable<[EventTaskCellModel]> in
                let ret: [EventTaskCellModel] = myTasks.compactMap({
                    return EventTaskCellModel(id: $0.key, taskModel: $0.value)
                })
                return Observable.of(ret)
            })
            .subscribe(onNext: {
                self.sections = self.sections.filter({
                    $0.title != EventSectionTitle.myTasks.rawValue
                })
                self.sections.insert(EventSection.section(title: .myTasks, items: $0.compactMap({EventItemType.myTasks($0)})), at: 0)
                self.sectionsBehaviourSubject.onNext(self.sections)
            })
            .disposed(by: self.disposeBag)
        self.noMyTasksBehaviorSubject
            .flatMap({ (myTasks) -> Observable<NoResultCellModel> in
                let ret: NoResultCellModel = {
                    return NoResultCellModel(description: "no_my_tasks".localize())
                }()
                return Observable.of(ret)
            })
            .subscribe(onNext: {
                self.sections = self.sections.filter({ $0.title != EventSectionTitle.myTasks.rawValue })
                self.sections.insert(EventSection.section(title: .myTasks, items: [EventItemType.noResult($0)]), at: 0)
                self.sectionsBehaviourSubject.onNext(self.sections)
            })
            .disposed(by: self.disposeBag)
        
        self.unassignedTasksBehaviorSubject
            .flatMap({ (unassignedTasks) -> Observable<[EventTaskCellModel]> in
                let ret: [EventTaskCellModel] = unassignedTasks.compactMap({
                    return EventTaskCellModel(id: $0.key, taskModel: $0.value)
                })
                return Observable.of(ret)
            })
            .subscribe(onNext: {
                self.sections = self.sections.filter({
                    $0.title != EventSectionTitle.unassignedTasks.rawValue
                })
                self.sections.insert(EventSection.section(title: .unassignedTasks, items: $0.compactMap({EventItemType.unassignedTasks($0)})), at: 1)
                self.sectionsBehaviourSubject.onNext(self.sections)
            })
            .disposed(by: self.disposeBag)
        self.noUnassignedTasksBehaviorSubject
            .flatMap({ (noTeams) -> Observable<NoResultCellModel> in
                let ret: NoResultCellModel = {
                    return NoResultCellModel(description: "no_unassigned_tasks".localize())
                }()
                return Observable.of(ret)
            })
            .subscribe(onNext: {
                self.sections = self.sections.filter({ $0.title != EventSectionTitle.unassignedTasks.rawValue })
                self.sections.insert(EventSection.section(title: .unassignedTasks, items: [EventItemType.noResult($0)]), at: 1)
                self.sectionsBehaviourSubject.onNext(self.sections)
            })
            .disposed(by: self.disposeBag)
        
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
                self.sections.insert(EventSection.section(title: .doneTasks, items: $0.compactMap({EventItemType.doneTasks($0)})), at: 2)
                self.sectionsBehaviourSubject.onNext(self.sections)
            })
            .disposed(by: self.disposeBag)
        self.noDoneTasksBehaviorSubject
            .flatMap({ (noTeams) -> Observable<NoResultCellModel> in
                let ret: NoResultCellModel = {
                    return NoResultCellModel(description: "no_done_tasks".localize())
                }()
                return Observable.of(ret)
            })
            .subscribe(onNext: {
                self.sections = self.sections.filter({ $0.title != EventSectionTitle.doneTasks.rawValue })
                self.sections.insert(EventSection.section(title: .doneTasks, items: [EventItemType.noResult($0)]), at: 2)
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
                self.sections.insert(EventSection.section(title: .allTasks, items: $0.compactMap({EventItemType.allTasks($0)})), at: 3)
                self.sectionsBehaviourSubject.onNext(self.sections)
            })
            .disposed(by: self.disposeBag)
        self.noAllTasksBehaviorSubject
            .flatMap({ (noTeams) -> Observable<NoResultCellModel> in
                let ret: NoResultCellModel = {
                    return NoResultCellModel(description: "no_all_tasks".localize())
                }()
                return Observable.of(ret)
            })
            .subscribe(onNext: {
                self.sections = self.sections.filter({ $0.title != EventSectionTitle.allTasks.rawValue })
                self.sections.insert(EventSection.section(title: .allTasks, items: [EventItemType.noResult($0)]), at: 3)
                self.sectionsBehaviourSubject.onNext(self.sections)
            })
            .disposed(by: self.disposeBag)
    }
    
    func getEventTasks() {
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
