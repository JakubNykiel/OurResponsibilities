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
        
        self.bindGeneralInformation()
    }
    
    private func bindGeneralInformation() {
        self.eventName.value = self.eventModel.name
        self.eventPoints.value = "winner_points".localize() + " " + String(self.eventModel.winnerGlobalPoints)
        self.eventDate.value = self.eventModel.startDate + " - " + self.eventModel.endDate
    }
}
