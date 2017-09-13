//
//  RegisterViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 12.09.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    let viewModel = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTextFields()
        self.hideKeyboardWhenTappedAround()
        self.containerDependOnKeyboardBottomConstrain = bottomConstraint
        self.watchForKeyboard()
    }
    @IBAction func registerUser(_ sender: Any) {
        self.viewModel.createUser(email: emailTextField.text, password: passwordTextField.text)
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
