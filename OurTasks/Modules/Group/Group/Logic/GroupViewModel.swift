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
    
    var eventsBehaviorSubject: BehaviorSubject<[String:EventModel]> = BehaviorSubject(value: [:])
    var pastEventsBehaviorSubject: BehaviorSubject<[String:EventModel]> = BehaviorSubject(value: [:])
    var futureEventsBehaviorSubject: BehaviorSubject<[String:EventModel]> = BehaviorSubject(value: [:])
    var noEventsBehaviorSubject: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var sectionsBehaviourSubject: BehaviorSubject<[GroupSection]> = BehaviorSubject(value: [])
    
    private let disposeBag = DisposeBag()
    private var sections: [GroupSection] = []
    private let dateFormatter = DateFormatter()
    var hexStringColor: String = ""
    var groupModel: GroupModel
    var groupID: String
    
    init(groupModel: GroupModel, groupID: String) {
        self.dateFormatter.dateFormat = "dd.MM.yyyy"
        self.groupModel = groupModel
        self.groupID = groupID
        self.eventsBehaviorSubject
            .flatMap({ (presentEvents) -> Observable<[GroupEventCellModel]> in
                let ret: [GroupEventCellModel] = presentEvents.compactMap({
                    let startDate = self.dateFormatter.date(from: $0.value.startDate) ?? nil
                    let endDate = self.dateFormatter.date(from: $0.value.endDate) ?? nil
                    return GroupEventCellModel(id: $0.key, eventName: $0.value.name, startDate: startDate, endDate: endDate)
                })
                return Observable.of(ret)
            })
            .subscribe(onNext: {
                self.sections.insert(GroupSection.section(title: .presentEvents, items: $0.compactMap({ GroupItemType.presentEvents($0) })), at: 0)
                self.sectionsBehaviourSubject.onNext(self.sections)
            })
            .disposed(by: self.disposeBag)
    }
    
    func fetchEventsAndTasks() {
       self.getEvents()
    }
    
    private func getEvents() {
        
    }
}
