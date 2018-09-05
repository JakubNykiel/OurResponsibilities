//
//  MenuViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 05/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit

class MenuViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let my = self.viewControllers?.first as? MyViewController {
            my.viewModel = MyViewModel()
        }
    }
}
