//
//  MainViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 11.09.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signInAction(_ sender: Any) {
        let loginVC = StoryboardManager.loginViewController()
        self.present(loginVC, animated: true, completion: nil)
    }
    
    @IBAction func registerAction(_ sender: Any) {
        let registerVC = StoryboardManager.registerViewController()
        self.present(registerVC, animated: true, completion: nil)
    }
}
