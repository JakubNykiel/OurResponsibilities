//
//  MyViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 05/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit

class MyViewController: UITableViewController {

    var viewModel: MyViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareOnLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareOnAppear()
    }
}
// MARK Preapre
extension MyViewController {
    func prepareOnLoad() {
        self.navigationItem.title = "my".localize()
    }
    
    func prepareOnAppear() {
        
    }
}
