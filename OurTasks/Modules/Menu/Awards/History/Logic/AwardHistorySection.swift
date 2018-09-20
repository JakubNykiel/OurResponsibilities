//
//  AwardHistorySection.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 20/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import RxDataSources

enum AwardHistorySection: SectionModelType {
    
    case section(items: [AwardHistoryItemType])
    
    typealias Item = AwardHistoryItemType
    init(original: AwardHistorySection, items: [AwardHistoryItemType]) {
        switch original {
        case .section(_):
            self = .section(items: items)
        }
    }
    
    var items: [AwardHistoryItemType] {
        switch self {
        case .section(items: let items):
            return items.map { $0 }
        }
    }
}

enum AwardHistoryItemType {
    case award(_: AwardHistoryCellModel)
}

struct AwardHistoryCellModel {
    var date: String
    var model: AwardModel
}
