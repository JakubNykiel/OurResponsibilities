//
//  GroupSection.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 09.05.2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import RxDataSources

enum GroupSection: SectionModelType {
    case section(title: GroupSectionTitle, items: [GroupItemType])
    
    typealias Item = GroupItemType
    init(original: GroupSection, items: [GroupItemType]) {
        switch original {
        case .section(title: let title, _):
            self = .section(title: title, items: items)
        }
    }
    
    var items: [GroupItemType] {
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
enum GroupItemType {
//    case task(_: GroupTaskCellModel)
    case unsettledEvents(_: GroupEventCellModel)
    case settledEvents(_: GroupEventCellModel)
    case futureEvents(_: GroupEventCellModel)
    case presentEvents(_: GroupEventCellModel)
    case noResult(_: NoResultCellModel)
//    case globalRanking(_: GroupGlobalRankingCellModel)
}

enum GroupSectionTitle: String {
//    case task
    case unsettledEvents
    case settledEvents
    case futureEvents
    case presentEvents
//    case globalRanking
    
    var rawValue: String  {
        switch self {
//        case .task: return "my_tasks".localize()
        case .unsettledEvents: return "unsettled_events".localize()
        case .settledEvents: return "settled_events".localize()
        case .futureEvents: return "future_events".localize()
        case .presentEvents: return "present_events".localize()
//        case .globalRanking: return "global_ranking".localize()
        }
    }
}

struct GroupEventCellModel {
    var id: String
    var eventModel: EventModel
}

struct GroupTaskCellModel {
    var id: String
    var groupName: String
    var taskModel: TaskModel
}
struct GroupGlobalRankingCellModel {
    var position: Int
    var username: String
    var points: Int
}
struct NoDataCellModel {
    var descText: String
}
