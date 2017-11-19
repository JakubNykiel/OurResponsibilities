//
//  RegisterViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 12.09.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class RegisterViewController: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    let viewModel = RegisterViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTextFields()
        self.hideKeyboardWhenTappedAround()
        self.containerDependOnKeyboardBottomConstrain = bottomConstraint
        self.watchForKeyboard()
        self.setupErrorObservable()
    }
    @IBAction func registerUser(_ sender: Any) {
        self.viewModel.createUser(email: self.emailTextField.text!, password: self.passwordTextField.text!, username: self.usernameTextField.text!)
    }
    
    @IBAction func presentLoginView(_ sender: Any) {
        let loginVC = StoryboardManager.loginViewController()
        self.present(loginVC, animated: true, completion: nil)
    }
    private func configureTextFields() {
        self.usernameTextField.setBottomBorder()
        self.emailTextField.setBottomBorder()
        self.passwordTextField.setBottomBorder()
    }
    
}
// MARK: RxSwift, RxCocoa
extension RegisterViewController {
    
    private func setupErrorObservable() {
        self.viewModel.error
        .asObservable()
        .bind(to: self.errorLabel.rx.text)
        .disposed(by: self.disposeBag)
    }
}

