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
    var beginConstraintTextFields: CGFloat = 0
    
    let keyboardWillShowObserver = #selector(LoginViewController.keyboardWillShow(sender:))
    let keyboardWillHideObserver = #selector(LoginViewController.keyboardWillHide(sender:))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideKeyboardWhenTappedAround()
        self.setObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setObservers() {
        NotificationCenter.default.addObserver(self, selector: self.keyboardWillShowObserver, name: NSNotification.Name(rawValue: Notification.Name.UIKeyboardWillShow.rawValue), object: nil)

        
        NotificationCenter.default.addObserver(self, selector: keyboardWillHideObserver, name: NSNotification.Name(rawValue: NSNotification.Name.UIKeyboardWillHide.rawValue), object: nil)
    }
    
    private func configureTextFields() {
        self.beginConstraintTextFields = self.bottomTextFieldsConstraint.constant
        self.emailTextField.setBottomBorder()
        self.passwordTextField.setBottomBorder()
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        guard let info:[AnyHashable:Any] = sender.userInfo,
              let keyboardSize:CGSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size else { return }
        self.bottomTextFieldsConstraint.constant = keyboardSize.height + self.beginConstraintTextFields
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.bottomTextFieldsConstraint.constant = beginConstraintTextFields
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}
