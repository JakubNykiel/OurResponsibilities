//
//  AREventListViewModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 25/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift
import CodableFirebase
import Firebase
import ARKit

class AREventListViewModel {
    
    var groupEventsBehaviorSubject: BehaviorSubject<[String:EventModel]> = BehaviorSubject(value: [:])
    var presentEventsBehaviorSubject: BehaviorSubject<[String:EventModel]> = BehaviorSubject(value: [:])
    var futureEventsBehaviorSubject: BehaviorSubject<[String:EventModel]> = BehaviorSubject(value: [:])
    
    var noPresentEventsBehaviorSubject: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var noFutureEventsBehaviorSubject: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var sectionsBehaviourSubject: BehaviorSubject<[AREventListSection]> = BehaviorSubject(value: [])
    
    private let firebaseManager: FirebaseManager = FirebaseManager()
    private let disposeBag = DisposeBag()
    private var sections: [AREventListSection] = []
    private let dateFormatter = DateFormatter()
    private let calendar = Calendar.current
    var groupModel: GroupModel
    var groupID: String
    var qrID: String
    var position: [Float]?
    var scale: [Float]?
    var groupEvents: [String:EventModel] = [:]
    
    init(groupModel: GroupModel, groupID: String, qrID: String, position: [Float]?, scale: [Float]?) {
        self.dateFormatter.dateFormat = "dd.MM.yyyy"
        self.groupModel = groupModel
        self.position = position
        self.scale = scale
        self.groupID = groupID
        self.qrID = qrID
        
        self.groupEventsBehaviorSubject.asObservable()
            .subscribe(onNext: {
                let nowDate = Date()
                var presentEvent: [String:EventModel] = [:]
                var futureEvent: [String:EventModel] = [:]
                
                for (index, event) in $0.enumerated() {
                    let orderStart = self.calendar.compare( self.dateFormatter.date(from: event.value.startDate)!, to: nowDate, toGranularity: .day)
                    let orderEnd = self.calendar.compare( self.dateFormatter.date(from: event.value.endDate)!, to: nowDate, toGranularity: .day)
                    //nowDate after startDate
                    if orderStart == .orderedAscending || orderStart == .orderedSame {
                        // past
                        if orderEnd == .orderedDescending || orderEnd == .orderedSame {
                            presentEvent[event.key] = event.value
                        }
                    } else {
                        futureEvent[event.key] = event.value
                    }
                    
                    //END condition
                    if index == (self.groupEvents.count - 1) {
                        presentEvent.count == 0 ? self.noPresentEventsBehaviorSubject.onNext(true) : self.presentEventsBehaviorSubject.onNext(presentEvent)
                        futureEvent.count == 0 ? self.noFutureEventsBehaviorSubject.onNext(true) : self.futureEventsBehaviorSubject.onNext(futureEvent)
                    }
                }
            }).disposed(by: self.disposeBag)
    }
    
    func prepareEventsAndTasks() {
        
        self.presentEventsBehaviorSubject
            .flatMap({ (presentEvents) -> Observable<[GroupEventCellModel]> in
                let ret: [GroupEventCellModel] = presentEvents.compactMap({
                    return GroupEventCellModel(id: $0.key, eventModel: $0.value)
                })
                return Observable.of(ret)
            })
            .subscribe(onNext: {
                self.sections = self.sections.filter({ $0.title != AREventListSectionTitle.presentEvents.rawValue })
                self.sections.insert(AREventListSection.section(title: .presentEvents, items: $0.compactMap({ AREventListItemType.presentEvents($0) })), at: 0)
                self.sectionsBehaviourSubject.onNext(self.sections)
            })
            .disposed(by: self.disposeBag)
        
        self.futureEventsBehaviorSubject
            .flatMap({ (futureEvents) -> Observable<[GroupEventCellModel]> in
                let ret: [GroupEventCellModel] = futureEvents.compactMap({
                    return GroupEventCellModel(id: $0.key, eventModel: $0.value)
                })
                return Observable.of(ret)
            })
            .subscribe(onNext: {
                self.sections = self.sections.filter({ $0.title != AREventListSectionTitle.futureEvents.rawValue })
                self.sections.insert(AREventListSection.section(title: .futureEvents, items: $0.compactMap({ AREventListItemType.futureEvents($0) })), at: 1)
                self.sectionsBehaviourSubject.onNext(self.sections)
            })
            .disposed(by: self.disposeBag)
        
        self.noPresentEventsBehaviorSubject
            .flatMap({ (noEvents) -> Observable<NoResultCellModel> in
                let ret: NoResultCellModel = {
                    return NoResultCellModel(description: "no_events".localize())
                }()
                return Observable.of(ret)
            })
            .subscribe(onNext: {
                self.sections = self.sections.filter({ $0.title != AREventListSectionTitle.presentEvents.rawValue })
                self.sections.insert(AREventListSection.section(title: .presentEvents, items: [AREventListItemType.noResult($0)]), at: 0)
                self.sectionsBehaviourSubject.onNext(self.sections)
            })
            .disposed(by: self.disposeBag)
        
        self.noFutureEventsBehaviorSubject
            .flatMap({ (noEvents) -> Observable<NoResultCellModel> in
                let ret: NoResultCellModel = {
                    return NoResultCellModel(description: "no_events".localize())
                }()
                return Observable.of(ret)
            })
            .subscribe(onNext: {
                self.sections = self.sections.filter({ $0.title != AREventListSectionTitle.futureEvents.rawValue })
                self.sections.insert(AREventListSection.section(title: .futureEvents, items: [AREventListItemType.noResult($0)]), at: 1)
                self.sectionsBehaviourSubject.onNext(self.sections)
            })
            .disposed(by: self.disposeBag)
    }
    
    func getEvents() {
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
