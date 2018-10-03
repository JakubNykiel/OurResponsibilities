//
//  AREventListSection.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 25/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import RxDataSources

enum AREventListSection: SectionModelType {
    case section(title: AREventListSectionTitle, items: [AREventListItemType])
    
    typealias Item = AREventListItemType
    init(original: AREventListSection, items: [AREventListItemType]) {
        switch original {
        case .section(title: let title, _):
            self = .section(title: title, items: items)
        }
    }
    
    var items: [AREventListItemType] {
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
enum AREventListItemType {
    case futureEvents(_: GroupEventCellModel)
    case presentEvents(_: GroupEventCellModel)
    case noResult(_: NoResultCellModel)
}

enum AREventListSectionTitle: String {
    case futureEvents
    case presentEvents
    
    var rawValue: String  {
        switch self {
        case .futureEvents: return "future_events".localize()
        case .presentEvents: return "present_events".localize()
        }
    }
}
