//
//  GroupViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 01.05.2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit
import RxDataSources


class GroupViewController: UIViewController {
    
    var viewModel: GroupViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.prepare()
    }
    
    private func prepare() {
        self.prepareNavigation()
    }

}
// MARK: Prepare
extension GroupViewController {
    private func prepareNavigation() {
        self.navigationItem.title = self.viewModel.groupModel.name.capitalized
    }
}
