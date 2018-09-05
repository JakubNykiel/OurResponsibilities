//
//  MySection.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 05/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import RxDataSources

enum MySection: SectionModelType {
    case section(title: MyItemSectionTitle, items: [MyItemType])
    
    typealias Item = MyItemType
    init(original: MySection, items: [MyItemType]) {
        switch original {
        case .section(title: let title, _):
            self = .section(title: title, items: items)
        }
    }
    
    var items: [MyItemType] {
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

enum MyItemType {
    case myGroups(_: MyGroupCellModel)
    case myTasks(_: MyTaskCellModel)
    case myEvents(_: MyEventCellModel)
    case noResult(_: NoResultCellModel)
}

enum MyItemSectionTitle: String {
    case myGroups
    case myEvents
    case myTasks
    
    var rawValue: String {
        switch self {
        case .myGroups: return "my_groups".localize()
        case .myEvents: return "my_events".localize()
        case .myTasks: return "my_tasks".localize()
        }
    }
}

struct MyGroupCellModel {
    var id: String
    var groupModel: GroupModel
}
struct MyEventCellModel {
    var id: String
    var groupModel: EventModel
}
struct MyTaskCellModel {
    var id: String
    var groupModel: TaskModel
}
