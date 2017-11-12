//
//  AddGroupViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 04/11/2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase

class AddGroupViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var groupNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideKeyboardWhenTappedAround()
    }
    
    private func configureTextFields() {
        self.groupNameTextField.setBottomBorder()
    }
    
    @IBAction func addGroup(_ sender: Any) {
        
    }
    
}
