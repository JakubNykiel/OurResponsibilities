//
//  GroupListSection.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 18.04.2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import RxDataSources

enum GroupListSection: SectionModelType {
    case section(title: GroupListSectionTitle, items: [GroupListItemType])
    
    typealias Item = GroupListItemType
    init(original: GroupListSection, items: [GroupListItemType]) {
        switch original {
        case .section(title: let title, _):
            self = .section(title: title, items: items)
        }
    }
    
    var items: [GroupListItemType] {
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
enum GroupListItemType {
    case userGroups(_: UserGroupsCellModel)
    case userTasks(_: GroupTaskCellModel)
    case noResult(_: NoResultCellModel)
}

enum GroupListSectionTitle: String {
    case userGroups
    case userTasks
    
    var rawValue: String  {
        switch self {
        case .userGroups: return "choose_group".localize()
        case .userTasks: return "your_tasks".localize()
        }
    }
}

struct UserGroupsCellModel {
    var id: String
    var groupModel: GroupModel
}

struct NoResultCellModel {
    var description: String
}
