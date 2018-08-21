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
    
    var myTasksBehaviorSubject: BehaviorSubject<[String:TaskModel]> = BehaviorSubject(value: [:])
    var doneTasksBehaviorSubject: BehaviorSubject<[String:TaskModel]> = BehaviorSubject(value: [:])
    var eventUsersBehaviorSubject: BehaviorSubject<[String:UserModel]> = BehaviorSubject(value: [:])
    var noTasksBehaviorSubject: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var sectionsBehaviourSubject: BehaviorSubject<[EventSection]> = BehaviorSubject(value: [])
    
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
}
