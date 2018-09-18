//
//  MenuViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 05/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit

class MenuViewController: UITabBarController {

    var viewModel: MenuViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareOnLoad()
    }
}
// MARK: Preapre
extension MenuViewController {
    func prepareOnLoad() {
        preapreViewModels()
    }
    
    private func preapreViewModels() {
        guard let views = self.viewControllers else { return }
        guard let model = self.viewModel?.groupModel,
            let id = self.viewModel?.groupID else { return }
        for naviViews in views {
            let view = (naviViews as? UINavigationController)?.viewControllers.first
            if view is GroupViewController {
                let groupVC = view as! GroupViewController
                groupVC.viewModel = GroupViewModel(groupModel: model, groupID: id)
            } else if view is ARKitViewController {
                print("ARKit")
            } else if view is RankingViewController {
                let rankingVC = view as! RankingViewController
                rankingVC.viewModel = RankingViewModel(groupId: id, groupModel: model)
            } else if view is AwardsViewController {
                let awardsVC = view as! AwardsViewController
                awardsVC.viewModel = AwardsViewModel(groupID: id, groupModel: model)
            }
        }
    }
}
