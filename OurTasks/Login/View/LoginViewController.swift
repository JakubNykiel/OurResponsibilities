//
//  LoginViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 11.09.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var bottomTextFieldsConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTextFields()
        self.containerDependOnKeyboardBottomConstrain = bottomTextFieldsConstraint
        self.watchForKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideKeyboardWhenTappedAround()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func configureTextFields() {
        self.emailTextField.setBottomBorder()
        self.passwordTextField.setBottomBorder()
    }

    @IBAction func signInUser(_ sender: Any) {
    }
    
    @IBAction func presentRegisterView(_ sender: Any) {
        let registerVC = StoryboardManager.registerViewController()
        self.present(registerVC, animated: true, completion: nil)
    }
    
}
