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
        let addTask = AddTaskViewController.self
        let event = EventViewController.self
        let task = TaskViewController.self
        let user = UserViewController.self
        let menu = MenuViewController.self
        let ranking = RankingViewController.self
        let awards = AwardsViewController.self
        let addaward = AddAwardViewController.self
        let awardHistory = AwardHistoryViewController.self
        let qr = QRViewController.self
        let addQr = AddQRViewController.self
    }

    enum StoryboardNames: String {
        case Login
        case Register
        case GroupList
        case Menu
        case AddGroup
        case AddEvent
        case AddTask
        case Event
        case Task
        case User
        case Ranking
        case award
        case addAward
    }

    enum ViewControllerIdentifiers: String {
        case loginViewController
        case registerViewController
        case groupListViewController
        case addGroupViewController
        case arKitViewController
        case groupViewController
        case addEventViewController
        case addTaskViewController
        case eventViewController
        case taskViewController
        case userViewController
        case menuViewController
        case rankingViewController
        case awardsViewController
        case addAwardViewController
        case awardHistoryViewController
        case QRViewController
        case addQRViewController
    }
    
    //MARK: GENERAL
    static func loginViewController() -> LoginViewController {
        let loginVC = self.viewController(ViewControllerTypes().login, withIdentifier: ViewControllerIdentifiers.loginViewController.rawValue, fromStoryboard: StoryboardNames.Login.rawValue)
        return loginVC
    }
    static func registerViewController() -> RegisterViewController {
        let registerVC = self.viewController(ViewControllerTypes().register, withIdentifier: ViewControllerIdentifiers.registerViewController.rawValue, fromStoryboard: StoryboardNames.Register.rawValue)
        return registerVC
    }
    static func usersViewController(groupID: String) -> UserViewController {
        let userVC = self.viewController(ViewControllerTypes().user, withIdentifier: ViewControllerIdentifiers.userViewController.rawValue, fromStoryboard: StoryboardNames.User.rawValue)
        userVC.viewModel = UserViewModel(groupID: groupID)
        return userVC
    }
    static func menuViewController(groupID: String, groupModel: GroupModel) -> MenuViewController {
        let menuVC = self.viewController(ViewControllerTypes().menu, withIdentifier: ViewControllerIdentifiers.menuViewController.rawValue, fromStoryboard: StoryboardNames.Menu.rawValue)
        menuVC.viewModel = MenuViewModel(groupID: groupID, groupModel: groupModel)
        return menuVC
    }
    //MARK: GROUP
    static func groupListViewController() -> GroupListViewController {
        let groupListVC = self.viewController(ViewControllerTypes().afterLogin, withIdentifier: ViewControllerIdentifiers.groupListViewController.rawValue, fromStoryboard: StoryboardNames.GroupList.rawValue)
        groupListVC.viewModel = GroupListViewModel()
        return groupListVC
    }
    static func addGroupViewController() -> AddGroupViewController {
        let addGroupVC = self.viewController(ViewControllerTypes().addGroup, withIdentifier: ViewControllerIdentifiers.addGroupViewController.rawValue, fromStoryboard: StoryboardNames.AddGroup.rawValue)
        return addGroupVC
    }
    static func groupViewController(_ groupModel: GroupModel, groupID: String) -> GroupViewController {
        let groupVC = self.viewController(ViewControllerTypes().group, withIdentifier: ViewControllerIdentifiers.groupViewController.rawValue, fromStoryboard: StoryboardNames.Menu.rawValue)
        let viewModel = GroupViewModel.init(groupModel: groupModel, groupID: groupID)
        groupVC.viewModel = viewModel
        return groupVC
    }
    //MARK: EVENT
    static func addEventViewController(_ groupID: String, state: AddEventViewState, eventModel: [String:EventModel]?) -> AddEventViewController {
        let addEventVC = self.viewController(ViewControllerTypes().addEvent, withIdentifier: ViewControllerIdentifiers.addEventViewController.rawValue, fromStoryboard: StoryboardNames.AddEvent.rawValue)
        let viewModel = AddEventViewModel.init(groupID: groupID, state: state, eventModel: eventModel)
        addEventVC.viewModel = viewModel
        return addEventVC
    }
    static func eventViewController(_ eventModel: EventModel, eventID: String) -> EventViewController {
        let eventVC = self.viewController(ViewControllerTypes().event, withIdentifier: ViewControllerIdentifiers.eventViewController.rawValue, fromStoryboard: StoryboardNames.Event.rawValue)
        let viewModel = EventViewModel.init(eventModel: eventModel, eventID: eventID)
        eventVC.viewModel = viewModel
        return eventVC
    }
    //MARK: TASK
    static func addTaskViewController(_ groupID: String, _ eventID: String, state: AddTaskViewState, taskModel: [String:TaskModel]?) -> AddTaskViewController {
        let addTaskVC = self.viewController(ViewControllerTypes().addTask, withIdentifier: ViewControllerIdentifiers.addTaskViewController.rawValue, fromStoryboard: StoryboardNames.AddTask.rawValue)
        let viewModel = AddTaskViewModel.init(groupID: groupID, eventID: eventID, state: state, taskModel: taskModel)
        addTaskVC.viewModel = viewModel
        return addTaskVC
    }
    static func taskViewController(_ taskID: String) -> TaskViewController {
        let taskVC = self.viewController(ViewControllerTypes().task, withIdentifier: ViewControllerIdentifiers.taskViewController.rawValue, fromStoryboard: StoryboardNames.Task.rawValue)
        let viewModel = TaskViewModel(taskID: taskID)
        taskVC.viewModel = viewModel
        return taskVC
    }
    //MARK: Ranking
    static func rankingViewController(groupID: String, groupModel: GroupModel) -> RankingViewController {
        let rankingVC = self.viewController(ViewControllerTypes().ranking, withIdentifier: ViewControllerIdentifiers.rankingViewController.rawValue, fromStoryboard: StoryboardNames.Menu.rawValue)
        let viewModel = RankingViewModel(groupId: groupID, groupModel: groupModel)
        rankingVC.viewModel = viewModel
        return rankingVC
    }
    
    @available(iOS 11.0, *)
    static func arKitViewController() -> ARKitViewController {
        let arVC = self.viewController(ARKitViewController.self, withIdentifier: ViewControllerIdentifiers.arKitViewController.rawValue, fromStoryboard: StoryboardNames.Menu.rawValue)
        return arVC
    }
    
    //MARK: Awards
    static func awardViewController(groupID: String, groupModel: GroupModel) -> AwardsViewController {
        let awardVC = self.viewController(AwardsViewController.self, withIdentifier: ViewControllerIdentifiers.awardsViewController.rawValue, fromStoryboard: StoryboardNames.Menu.rawValue)
        let viewModel = AwardsViewModel(groupID: groupID, groupModel: groupModel)
        awardVC.viewModel = viewModel
        return awardVC
    }
    
    static func addAwardViewController(groupID: String, groupModel: GroupModel, awardModel: [String:AwardModel]?) -> AddAwardViewController {
        let addAwardVC = self.viewController(ViewControllerTypes().addaward, withIdentifier: ViewControllerIdentifiers.addAwardViewController.rawValue, fromStoryboard: StoryboardNames.Menu.rawValue)
        let viewModel = AddAwardViewModel(groupId: groupID, groupModel: groupModel, awardModel: awardModel)
        addAwardVC.viewModel = viewModel
        return addAwardVC
    }
    
    static func awardHistoryViewController() -> AwardHistoryViewController {
        let awardHistoryVC = self.viewController(ViewControllerTypes().awardHistory, withIdentifier: ViewControllerIdentifiers.awardHistoryViewController.rawValue, fromStoryboard: StoryboardNames.Menu.rawValue)
        let viewModel = AwardHistoryViewModel()
        awardHistoryVC.viewModel = viewModel
        return awardHistoryVC
    }
    
    //MARK: QR
    static func qrViewController(groupID: String, groupModel: GroupModel) -> QRViewController {
        let qrVC = self.viewController(ViewControllerTypes().qr, withIdentifier: ViewControllerIdentifiers.QRViewController.rawValue, fromStoryboard: StoryboardNames.Menu.rawValue)
        let viewModel = QRViewModel(groupID: groupID, groupModel: groupModel)
        qrVC.viewModel = viewModel
        return qrVC
    }
    
    static func addQRViewController(groupID: String, groupModel: GroupModel) -> AddQRViewController {
        let qrVC = self.viewController(ViewControllerTypes().addQr, withIdentifier: ViewControllerIdentifiers.addQRViewController.rawValue, fromStoryboard: StoryboardNames.Menu.rawValue)
        let viewModel = AddQRViewModel(groupID: groupID)
        qrVC.viewModel = viewModel
        return qrVC
    }
    
}
