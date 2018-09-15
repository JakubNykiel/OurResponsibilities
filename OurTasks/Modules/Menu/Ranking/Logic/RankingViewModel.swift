//
//  RankingViewModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 11/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase
import RxSwift

class RankingViewModel {
    
    private let firebaseManager: FirebaseManager = FirebaseManager()
    var groupRanking: [String:GroupModel] = [:]
    var eventRanking: [String:String] = [:]
    var userData: [String:UserModel] = [:]
    var groupRankingBehaviorSubject: BehaviorSubject<[String:Int]> = BehaviorSubject(value: [:])
    var eventRankingBehaviorSubject: BehaviorSubject<[String:Int]> = BehaviorSubject(value: [:])
    var noRankingGroupsBehaviorSubject: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var noRankingEventsBehaviorSubject: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var sectionsBehaviourSubject: BehaviorSubject<[RankingSection]> = BehaviorSubject(value: [])
    var selectedSegment: Variable<Int> = Variable(0)
    
    private let disposeBag = DisposeBag()
    var sections: [RankingSection] = []
    var groupID: String
    var groupModel: GroupModel
    var dataBinded: BehaviorSubject<Bool> = BehaviorSubject(value: false)

    
    init(groupId: String, groupModel: GroupModel) {
        self.groupID = groupId
        self.groupModel = groupModel
    }
    
    private func fetchGroupsRanking() {
        let groupRef = FirebaseReferences().groupRef.document(self.groupID)
        groupRef.getDocument(completion: { (document, error) in
            if let document = document {
                guard let groupData = document.data() else { return }
                guard let users = groupData["users"] as? [String:Int] else { return }
                self.groupRankingBehaviorSubject.onNext(users)
            } else {
                print("User not exist")
            }
        })
    }
    
    private func fetchEventRanking() {
        let events = self.groupModel.events ?? []
        self.toEventModel(events)
        _ = events.compactMap({
            let eventRef = FirebaseReferences().eventRef.document($0)
            eventRef.getDocument(completion: { (document, error) in
                if let document = document {
                    guard let eventData = document.data() else { return }
                    guard let users = eventData["users"] as? [String:Int] else { return }
                    self.eventRankingBehaviorSubject.onNext(users)
                } else {
                    print("Event not exist")
                }
            })
        })
    }
    
    private func toEventModel(_ events: [String]) {
        _ = events.enumerated().compactMap({ (index,event) in
            let eventRef = FirebaseReferences().eventRef.document(event)
            eventRef.getDocument(completion: { (document, error) in
                if let document = document {
                    guard let eventData = document.data() else { return }
                    let eventModel = try! FirebaseDecoder().decode(EventModel.self, from: eventData)
                    self.eventRanking[event] = eventModel.name
                    if index == events.count - 1 && self.selectedSegment.value == 0 {
                        self.dataBinded.onNext(true)
                    }
                } else {
                    print("Event not exist")
                }
            })
        })
    }
    
    private func bind() {
        self.selectedSegment.asObservable()
            .subscribe(onNext: {
                self.sections = []
                self.sectionsBehaviourSubject.onNext(self.sections)
                if $0 == 0 {
                    self.fetchGroupsRanking()
                } else {
                    self.fetchEventRanking()
                }
            }).disposed(by: self.disposeBag)
        
        self.dataBinded.asObservable()
            .subscribe(onNext: {
                if $0 {
                    self.selectedSegment.value = 0
                    
                }
            }).disposed(by: self.disposeBag)
        
        self.groupRankingBehaviorSubject
            .flatMap({ (groups) -> Observable<[RankingGroupCellModel]> in
                let users = self.groupModel.users ?? [:]
                let sortedUsers = users.sorted { $0.1 > $1.1 }
                let ret: [RankingGroupCellModel] = sortedUsers.compactMap({
                    let username = self.userData[$0.key]?.username ?? ""
                    return RankingGroupCellModel(id: $0.key, name: username, points: $0.value)
                })
                return Observable.of(ret)
            })
            .subscribe(onNext: {
                self.sections.insert(RankingSection.section(title: self.groupModel.name, items: $0.compactMap({ RankingItemType.group($0) })), at: 0)
                self.sectionsBehaviourSubject.onNext(self.sections)
            })
            .disposed(by: self.disposeBag)
        
        self.noRankingGroupsBehaviorSubject
            .flatMap({ (noGroups) -> Observable<NoResultCellModel> in
                let ret: NoResultCellModel = {
                    return NoResultCellModel(description: "no_group_user".localize())
                }()
                return Observable.of(ret)
            })
            .subscribe(onNext: {
                self.sections.insert(RankingSection.section(title: self.groupModel.name, items: [RankingItemType.noResult($0)]), at: 0)
                self.sectionsBehaviourSubject.onNext(self.sections)
            })
            .disposed(by: self.disposeBag)
        
        self.eventRankingBehaviorSubject
            .flatMap({ (users) -> Observable<[RankingEventCellModel]> in
                let sortedUsers = users.sorted { $0.1 > $1.1 }
                let ret: [RankingEventCellModel] = sortedUsers.enumerated().compactMap({ (index,element) in
                    let name = self.userData[element.key]?.username ?? ""
                    return RankingEventCellModel(id: element.key, eventName: "", name: name, points: element.value)
                })
                return Observable.of(ret)
            })
            .subscribe(onNext: {
                
                self.sections.append(RankingSection.section(title: $0.first?.eventName ?? "", items: $0.compactMap({ RankingItemType.event($0) })))
                self.sectionsBehaviourSubject.onNext(self.sections)
            })
            .disposed(by: self.disposeBag)
        
        self.noRankingEventsBehaviorSubject
            .flatMap({ (noEvents) -> Observable<NoResultCellModel> in
                let ret: NoResultCellModel = {
                    return NoResultCellModel(description: "no_group_user".localize())
                }()
                return Observable.of(ret)
            })
            .subscribe(onNext: {
                self.sections.insert(RankingSection.section(title: "", items: [RankingItemType.noResult($0)]), at: 0)
                self.sectionsBehaviourSubject.onNext(self.sections)
            })
            .disposed(by: self.disposeBag)
    }
    
    func prepareData() {
        guard let users = self.groupModel.users else { return }
        let sortedUsers = users.sorted { $0.1 > $1.1 }
        self.bind()
        
        _ = sortedUsers.enumerated().compactMap({ (index,element) in
            let userRef = FirebaseReferences().userRef.document(element.key)
            
            userRef.getDocument(completion: { (document, error) in
                if let document = document {
                    guard let userData = document.data() else { return }
                    self.userData[element.key] = try! FirebaseDecoder().decode(UserModel.self, from: userData)
                    if index == (self.groupModel.users?.count ?? 0) - 1 {
                        self.toEventModel(self.groupModel.events ?? [])
                    }
                } else {
                    print("User not exist")
                }
            })
        })
    }
}
