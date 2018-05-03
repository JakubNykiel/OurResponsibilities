//
//  GroupSection.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 18.04.2018.
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
    case userGroups(_: UserGroupsCellModel)
    case userInvites(_: UserInvitesCellModel)
}

enum GroupSectionTitle: String {
    case userGroups
    case userInvites
    
    var rawValue: String  {
        switch self {
        case .userGroups: return "my_groups".localize()
        case .userInvites: return "invites".localize()
        }
    }
}

struct UserGroupsCellModel {
    var name: String
    var color: String
}

struct UserInvitesCellModel {
    var name: String
    var color: String
    var followBtnText: String
    var followBtnVisible: Bool
}
