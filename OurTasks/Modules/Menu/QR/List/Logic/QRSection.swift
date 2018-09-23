//
//  QRSection.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 22/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import RxDataSources

enum QRSection: SectionModelType {
    
    case section(items: [QRItemType])
    
    typealias Item = QRItemType
    init(original: QRSection, items: [QRItemType]) {
        switch original {
        case .section(_):
            self = .section(items: items)
        }
    }
    
    var items: [QRItemType] {
        switch self {
        case .section(items: let items):
            return items.map { $0 }
        }
    }
}

enum QRItemType {
    case code(_: QRCellModel)
}

struct QRCellModel {
    var id: String
    var model: QRCodeModel
}
