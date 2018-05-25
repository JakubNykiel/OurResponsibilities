//
//  StoryboardManager.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 11.09.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

struct StoryboardManager {
    
    static func viewController<T: UIViewController>(_ type: T.Type, withIdentifier viewControllerIdentifier: String? = nil, fromStoryboard storyboardName: String) -> T {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        if let identifier = viewControllerIdentifier {
            return storyboard.instantiateViewController(withIdentifier: identifier) as! T
        } else {
            return storyboard.instantiateInitialViewController() as! T
        }
    }
    
    struct ViewControllerTypes {
        let login = LoginViewController.self
        let register = RegisterViewController.self
        let afterLogin = GroupListViewController.self
        let addGroup = AddGroupViewController.self
        let group = GroupViewController.self
        let addEvent = AddEventViewController.self
    }

    enum StoryboardNames: String {
        case Login
        case Register
        case GroupList
        case AddGroup
        case ARKit
        case Group
        case AddEvent
    }

    enum ViewControllerIdentifiers: String {
        case loginViewController
        case registerViewController
        case groupListViewController
        case addGroupViewController
        case arKitViewController
        case groupViewController
        case addEventViewController
    }

    static func loginViewController() -> LoginViewController {
        let loginVC = self.viewController(ViewControllerTypes().login, withIdentifier: ViewControllerIdentifiers.loginViewController.rawValue, fromStoryboard: StoryboardNames.Login.rawValue)
        return loginVC
    }
    static func registerViewController() -> RegisterViewController {
        let registerVC = self.viewController(ViewControllerTypes().register, withIdentifier: ViewControllerIdentifiers.registerViewController.rawValue, fromStoryboard: StoryboardNames.Register.rawValue)
        return registerVC
    }
    static func groupListViewController() -> GroupListViewController {
        let groupListVC = self.viewController(ViewControllerTypes().afterLogin, withIdentifier: ViewControllerIdentifiers.groupListViewController.rawValue, fromStoryboard: StoryboardNames.GroupList.rawValue)
        groupListVC.viewModel = GroupListViewModel()
        return groupListVC
    }
    static func addGroupViewController() -> AddGroupViewController {
        let addGroupVC = self.viewController(ViewControllerTypes().addGroup, withIdentifier: ViewControllerIdentifiers.addGroupViewController.rawValue, fromStoryboard: StoryboardNames.AddGroup.rawValue)
        return addGroupVC
    }
    static func groupViewController(_ groupModel: GroupModel) -> GroupViewController {
        let groupVC = self.viewController(ViewControllerTypes().group, withIdentifier: ViewControllerIdentifiers.groupViewController.rawValue, fromStoryboard: StoryboardNames.Group.rawValue)
        let viewModel = GroupViewModel.init(groupModel: groupModel)
        groupVC.viewModel = viewModel
        return groupVC
    }
    static func addEventViewController() -> AddEventViewController {
        let addEventVC = self.viewController(ViewControllerTypes().addEvent, withIdentifier: ViewControllerIdentifiers.addEventViewController.rawValue, fromStoryboard: StoryboardNames.AddEvent.rawValue)
        return addEventVC
    }
    
    
    @available(iOS 11.0, *)
    static func arKitViewController() -> ARKitViewController {
        let arVC = self.viewController(ARKitViewController.self, withIdentifier: ViewControllerIdentifiers.arKitViewController.rawValue, fromStoryboard: StoryboardNames.ARKit.rawValue)
        return arVC
    }
}
