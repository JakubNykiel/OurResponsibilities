//
//  AwardSection.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 17/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import RxDataSources

enum AwardSection: SectionModelType {
    
    case section(items: [AwardItemType])
    
    typealias Item = AwardItemType
    init(original: AwardSection, items: [AwardItemType]) {
        switch original {
        case .section(_):
            self = .section(items: items)
        }
    }
    
    var items: [AwardItemType] {
        switch self {
        case .section(items: let items):
            return items.map { $0 }
        }
    }
}

enum AwardItemType {
    case award(_: AwardCellModel)
}

struct AwardCellModel {
    var id: String
    var model: AwardModel
}
