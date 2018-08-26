//
//  GroupViewModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 01.05.2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import RxSwift
import Firebase
import CodableFirebase
import UIKit

class GroupViewModel {
    
    var groupEventsBehaviorSubject: BehaviorSubject<[String:EventModel]> = BehaviorSubject(value: [:])
    var eventsBehaviorSubject: BehaviorSubject<[String:EventModel]> = BehaviorSubject(value: [:])
    var pastEventsBehaviorSubject: BehaviorSubject<[String:EventModel]> = BehaviorSubject(value: [:])
    var futureEventsBehaviorSubject: BehaviorSubject<[String:EventModel]> = BehaviorSubject(value: [:])
    var noEventsBehaviorSubject: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var sectionsBehaviourSubject: BehaviorSubject<[GroupSection]> = BehaviorSubject(value: [])
    
    private let firebaseManager: FirebaseManager = FirebaseManager()
    private let disposeBag = DisposeBag()
    private var sections: [GroupSection] = []
    private let dateFormatter = DateFormatter()
    private let calendar = Calendar.current
    var hexStringColor: String = ""
    var groupModel: GroupModel
    var groupID: String
    var groupEvents: [String:EventModel] = [:]
    
    init(groupModel: GroupModel, groupID: String) {
        self.dateFormatter.dateFormat = "dd.MM.yyyy"
        self.groupModel = groupModel
        self.groupID = groupID
        self.getEvents()
        
        self.groupEventsBehaviorSubject.asObservable()
            .subscribe(onNext: {
                let nowDate = Date()
                var pastEvent: [String:EventModel] = [:]
                var presentEvent: [String:EventModel] = [:]
                var futureEvent: [String:EventModel] = [:]
                
                for (index, event) in $0.enumerated() {
                    let orderStart = self.calendar.compare( self.dateFormatter.date(from: event.value.startDate)!, to: nowDate, toGranularity: .day)
                    let orderEnd = self.calendar.compare( self.dateFormatter.date(from: event.value.endDate)!, to: nowDate, toGranularity: .day)
                    //nowDate after startDate
                    if orderStart == .orderedAscending {
                        // past
                        if orderEnd == .orderedDescending || orderEnd == .orderedSame {
                            presentEvent[event.key] = event.value
                        } else if orderEnd == .orderedAscending {
                            pastEvent[event.key] = event.value
                        }
                    } else {
                        futureEvent[event.key] = event.value
                    }
                    
                    //END condition
                    if index == (self.groupEvents.count - 1) && self.groupEvents.count != 0 {
                        self.eventsBehaviorSubject.onNext(presentEvent)
                        self.pastEventsBehaviorSubject.onNext(pastEvent)
                        self.futureEventsBehaviorSubject.onNext(futureEvent)
                    }
                }
                
                
                
                
            }).disposed(by: self.disposeBag)
    }
    
    func prepareEventsAndTasks() {
        
        self.pastEventsBehaviorSubject
            .flatMap({ (pastEvents) -> Observable<[GroupEventCellModel]> in
                let ret: [GroupEventCellModel] = pastEvents.compactMap({
                    return GroupEventCellModel(id: $0.key, eventModel: $0.value)
                })
                return Observable.of(ret)
            })
            .subscribe(onNext: {
                self.sections = self.sections.filter({ $0.title != GroupSectionTitle.pastEvents.rawValue })
                self.sections.insert(GroupSection.section(title: .pastEvents, items: $0.compactMap({ GroupItemType.pastEvents($0) })), at: 0)
                self.sectionsBehaviourSubject.onNext(self.sections)
            })
            .disposed(by: self.disposeBag)
        
        self.eventsBehaviorSubject
            .flatMap({ (presentEvents) -> Observable<[GroupEventCellModel]> in
                let ret: [GroupEventCellModel] = presentEvents.compactMap({
                    let startDate = self.dateFormatter.date(from: $0.value.startDate) ?? nil
                    let endDate = self.dateFormatter.date(from: $0.value.endDate) ?? nil
                    return GroupEventCellModel(id: $0.key, eventModel: $0.value)
                })
                return Observable.of(ret)
            })
            .subscribe(onNext: {
                self.sections = self.sections.filter({ $0.title != GroupSectionTitle.presentEvents.rawValue })
                self.sections.insert(GroupSection.section(title: .presentEvents, items: $0.compactMap({ GroupItemType.presentEvents($0) })), at: 1)
                self.sectionsBehaviourSubject.onNext(self.sections)
            })
            .disposed(by: self.disposeBag)
        
        self.futureEventsBehaviorSubject
            .flatMap({ (futureEvents) -> Observable<[GroupEventCellModel]> in
                let ret: [GroupEventCellModel] = futureEvents.compactMap({
                    let startDate = self.dateFormatter.date(from: $0.value.startDate) ?? nil
                    let endDate = self.dateFormatter.date(from: $0.value.endDate) ?? nil
                    return GroupEventCellModel(id: $0.key, eventModel: $0.value)
                })
                return Observable.of(ret)
            })
            .subscribe(onNext: {
                self.sections = self.sections.filter({ $0.title != GroupSectionTitle.futureEvents.rawValue })
                self.sections.insert(GroupSection.section(title: .futureEvents, items: $0.compactMap({ GroupItemType.futureEvents($0) })), at: 2)
                self.sectionsBehaviourSubject.onNext(self.sections)
            })
            .disposed(by: self.disposeBag)
        
    }
    
    private func getEvents() {
        let groupEventsRef = self.firebaseManager.db.collection(FirebaseModel.groups.rawValue).document(self.groupID)
        groupEventsRef.getDocument { (document, error) in
            if let document = document {
                guard let data = document.data() else { return }
                guard let groups: [String] = data["events"] as? [String] else { return }
                self.toEventModel(groups)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    private func toEventModel(_ events: [String]) {
        if events.count == 0 {
//            self.noEventsBehaviorSubject.onNext(true)
        } else {
            _ = events.compactMap({ event in
                let eventRef = FirebaseReferences().eventRef.document(event)
                eventRef.getDocument(completion: { (document, error) in
                    if let document = document {
                        guard let eventData = document.data() else { return }
                        let eventModel = try! FirebaseDecoder().decode(EventModel.self, from: eventData)
                        self.groupEvents[document.documentID] = eventModel
                        if events.count == self.groupEvents.count {
                            self.groupEventsBehaviorSubject.onNext(self.groupEvents)
                        }
                    } else {
                        print("Event not exist")
                    }
                })
            })
        }
        
    }
}
