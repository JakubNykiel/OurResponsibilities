//
//  AddGroupViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 04/11/2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase
import RxSwift

class AddGroupViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var groupNameTextField: UITextField!
    
    private let viewModel: AddGroupViewModel = AddGroupViewModel()
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideKeyboardWhenTappedAround()

        self.viewModel.groupAdded.asObservable()
            .subscribe(onNext: {
                if $0 {
                    self.navigationController?.popViewController(animated: true)
                }
            }).disposed(by: self.disposeBag)
    }
    
    private func configureTextFields() {
        self.groupNameTextField.setBottomBorder()
    }
    
    private func prepareGroupModel() {
        let currentUserUid = self.viewModel.getCurrentUserUid()
        let groupName = self.groupNameTextField.text ?? ""
        self.viewModel.groupModel = GroupModel(name: groupName, createDate: self.viewModel.getTodayDate(), users: nil, events: nil, admins: [currentUserUid], userInteraction: false)
    }
    
    @IBAction func addGroup(_ sender: Any) {
        self.prepareGroupModel()
        self.viewModel.addGroupToDatabase()
    }
    
}
