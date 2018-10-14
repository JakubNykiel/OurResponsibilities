//
//  RankingSection.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 11/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import RxDataSources

enum RankingSection: SectionModelType {
    case section(title: String, items: [RankingItemType])
    
    typealias Item = RankingItemType
    init(original: RankingSection, items: [RankingItemType]) {
        switch original {
        case .section(title: let title, _):
            self = .section(title: title, items: items)
        }
    }
    
    var items: [RankingItemType] {
        switch self {
        case .section(_, items: let items):
            return items.map { $0 }
        }
    }
    
    var title: String {
        switch self {
        case .section(title: let title, _):
            return title
        }
    }
}

enum RankingItemType {
    case group(_: RankingGroupCellModel)
    case event(_: RankingEventCellModel)
    case noResult(_: NoResultCellModel)
}

struct RankingGroupCellModel {
    var id: String
    var name: String
    var points: Int
}
struct RankingEventCellModel {
    var id: String
    var eventModel: EventModel
    var name: String
    var points: Int
}
