//
//  GroupListViewModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 19.12.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase
import RxSwift

class GroupListViewModel {
    
    private let firebaseManager: FirebaseManager = FirebaseManager()
    var userGroups: [String:GroupModel] = [:]
    var userTasks: [String:TaskModel] = [:]
    
    var userGroupsBehaviorSubject: BehaviorSubject<[String:GroupModel]> = BehaviorSubject(value: [:])
    var noGroupUserBehaviorSubject: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    var userTasksBehaviorSubject: BehaviorSubject<[String:TaskModel]> = BehaviorSubject(value: [:])
    var noUserTasksBehaviorSubject: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    var sectionsBehaviourSubject: BehaviorSubject<[GroupListSection]> = BehaviorSubject(value: [])
    
    private let disposeBag = DisposeBag()
    private var sections: [GroupListSection] = []
    private let dateFormatter = DateFormatter()
    
    init() {
        dateFormatter.dateFormat = "dd.MM.yyyy"
        self.userGroupsBehaviorSubject
            .flatMap({ (userGroups) -> Observable<[UserGroupsCellModel]> in
                let ret: [UserGroupsCellModel] = userGroups.compactMap({
                    return UserGroupsCellModel(id: $0.key, groupModel: $0.value)
                })
                return Observable.of(ret)
            })
            .subscribe(onNext: {
                self.sections = self.sections.filter({ $0.title != GroupListSectionTitle.userGroups.rawValue })
                self.sections.insert(GroupListSection.section(title: .userGroups, items: $0.compactMap({ GroupListItemType.userGroups($0) })), at: 0)
                self.sectionsBehaviourSubject.onNext(self.sections)
            })
            .disposed(by: self.disposeBag)
        
        self.noGroupUserBehaviorSubject
            .flatMap({ (noTeams) -> Observable<NoResultCellModel> in
                let ret: NoResultCellModel = {
                    return NoResultCellModel(description: "no_group_user".localize())
                }()
                return Observable.of(ret)
            })
            .subscribe(onNext: {
                self.sections = self.sections.filter({ $0.title != GroupListSectionTitle.userGroups.rawValue })
                self.sections.insert(GroupListSection.section(title: .userGroups, items: [GroupListItemType.noResult($0)]), at: 0)
                self.sectionsBehaviourSubject.onNext(self.sections)
            })
            .disposed(by: self.disposeBag)
        
        self.userTasksBehaviorSubject
            .flatMap({ (userTasks) -> Observable<[GroupTaskCellModel]> in
                let ret: [GroupTaskCellModel] = userTasks.compactMap({
                    let groupName = self.userGroups[$0.value.groupID]?.name ?? ""
                    return GroupTaskCellModel(id: $0.key, groupName: groupName, taskModel: $0.value)
                })
                return Observable.of(ret)
            })
            .subscribe(onNext: {
                self.sections = self.sections.filter({ $0.title != GroupListSectionTitle.userTasks.rawValue })
                self.sections.insert(GroupListSection.section(title: .userTasks, items: $0.compactMap({ GroupListItemType.userTasks($0) })), at: 1)
                self.sectionsBehaviourSubject.onNext(self.sections)
            })
            .disposed(by: self.disposeBag)
        
        self.noUserTasksBehaviorSubject
            .flatMap({ (noTeams) -> Observable<NoResultCellModel> in
                let ret: NoResultCellModel = {
                    return NoResultCellModel(description: "no_tasks".localize())
                }()
                return Observable.of(ret)
            })
            .subscribe(onNext: {
                self.sections = self.sections.filter({ $0.title != GroupListSectionTitle.userTasks.rawValue })
                self.sections.insert(GroupListSection.section(title: .userTasks, items: [GroupListItemType.noResult($0)]), at: 1)
                self.sectionsBehaviourSubject.onNext(self.sections)
            })
            .disposed(by: self.disposeBag)
    }
    
    func getUserGroups() {
        guard let uid = self.firebaseManager.currentUser?.uid else { return }
        let userGroupsRef = self.firebaseManager.db.collection(FirebaseModel.users.rawValue).document(uid)
        userGroupsRef.getDocument { (document, error) in
            if let document = document {
                guard let data = document.data() else { return }
                guard let groups: [String] = data["groups"] as? [String] else { return }
                self.toGroupModel(groups)
                guard let tasks: [String] = data["tasks"] as? [String] else { return }
                self.toTaskModel(tasks)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    private func toTaskModel(_ tasks: [String]) {
        if tasks.count == 0 {
            self.noUserTasksBehaviorSubject.onNext(true)
        } else {
            _ = tasks.compactMap({ task in
                let taskRef = FirebaseReferences().taskRef.document(task)
                taskRef.getDocument(completion: { (document, error) in
                    if let document = document {
                        guard let taskData = document.data() else { return }
                        let taskModel = try! FirebaseDecoder().decode(TaskModel.self, from: taskData)
                        self.userTasks[document.documentID] = taskModel
                        if tasks.count == self.userTasks.count {
                            self.userTasksBehaviorSubject.onNext(self.userTasks)
                        }
                    } else {
                        print("Task not exist")
                    }
                })
            })
        }
    }
    
    private func toGroupModel(_ groups: [String]) {
        if groups.count == 0 {
            self.noGroupUserBehaviorSubject.onNext(true)
        } else {
            _ = groups.compactMap({ group in
                let groupRef = FirebaseReferences().groupRef.document(group)
                groupRef.getDocument(completion: { (document, error) in
                    if let document = document {
                        guard let groupData = document.data() else { return }
                        let groupModel = try! FirebaseDecoder().decode(GroupModel.self, from: groupData)
                        self.userGroups[document.documentID] = groupModel
                        if groups.count == self.userGroups.count {
                            self.userGroupsBehaviorSubject.onNext(self.userGroups)
                        }
                        
                    } else {
                        print("Group not exist")
                    }
                })
            })
        }
        
    }
    
    
}
