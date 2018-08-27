//
//  TaskViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 27/08/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareOnLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.prepareOnAppear()
    }
}
//MARK: Prepare
extension TaskViewController {
    func prepareOnLoad() {
        
    }
    
    func prepareOnAppear() {
        
    }
}
