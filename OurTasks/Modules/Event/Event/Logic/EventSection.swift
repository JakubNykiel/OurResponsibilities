//
//  EventSection.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 19/08/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import RxDataSources

enum EventSection: SectionModelType {
    case section(title: EventSectionTitle, items: [EventItemType])
    
    typealias Item = EventItemType
    init(original: EventSection, items: [EventItemType]) {
        switch original {
        case .section(title: let title, _):
            self = .section(title: title, items: items)
        }
    }
    
    var items: [EventItemType] {
        switch self {
        case .section(_, items: let items):
            return items.map { $0 }
        }
    }
    
    var title: String {
        switch self {
        case .section(title: let title, _):
            return title.rawValue
        }
    }
}

enum EventItemType {
    case myTasks(_: EventTaskCellModel)
    case allTasks(_: EventTaskCellModel)
    case doneTasks(_: EventTaskCellModel)
    case unassignedTasks(_: EventTaskCellModel)
    case noResult(_: NoResultCellModel)
    case reviewTasks(_: EventTaskCellModel)//    case users(_: EventUserCellModel)
}

enum EventSectionTitle: String {
    case myTasks
    case allTasks
    case doneTasks
    case unassignedTasks
    case users
    case review
    
    var rawValue: String {
        switch self {
        case .myTasks: return "my_tasks".localize()
        case .allTasks: return "all_tasks".localize()
        case .doneTasks: return "done_tasks".localize()
        case .unassignedTasks: return "unassigned_tasks".localize()
        case .users: return "users".localize()
        case .review: return "Zadania do sprawdzenia"
            
        }
    }
}

struct EventTaskCellModel {
    var id: String
    var taskModel: TaskModel
}

struct EventUserCellModel {
    var id: String
    var name: String
}
