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
    
    private let viewModel: AddGroupViewModel = AddGroupViewModel()
    
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
    
    private func configureGroupModel() {
        let currentUserUid = self.viewModel.getCurrentUserUid()
        self.viewModel.groupModel.admins.append(currentUserUid)
        self.viewModel.groupModel.name = groupNameTextField.text
        self.viewModel.groupModel.createDate = self.viewModel.createGroupDate()
    }
    
    @IBAction func addGroup(_ sender: Any) {
        self.configureGroupModel()
        self.viewModel.addGroupToDatabase()
    }
    
}
