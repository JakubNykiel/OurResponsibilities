//
//  GroupListViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 03/10/2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class GroupListViewController: UIViewController {

    @IBOutlet weak var groupSegmentedControl: UISegmentedControl!
    @IBOutlet weak var groupListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func addGroupView(_ sender: Any) {
        let addGroupVC = StoryboardManager.addGroupViewController()
        self.present(addGroupVC, animated: true, completion: nil)
    }
    
    @IBAction func changeGroupList(_ sender: Any) {
        
    }
}
