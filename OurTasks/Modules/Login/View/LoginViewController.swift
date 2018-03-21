//
//  LoginViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 11.09.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase
import RxCocoa
import RxSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var bottomTextFieldsConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorLabel: UILabel!
    
    let viewModel = LoginViewModel()
    private var handle: AuthStateDidChangeListenerHandle?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTextFields()
        self.containerDependOnKeyboardBottomConstrain = bottomTextFieldsConstraint
        self.watchForKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideKeyboardWhenTappedAround()
        //TODO: remove mocks
        self.mockLoginData()
        self.siginInListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(self.handle!)
    }
    
    private func configureTextFields() {
        self.emailTextField.setBottomBorder()
        self.passwordTextField.setBottomBorder()
    }

    @IBAction func signInUser(_ sender: Any) {        
        guard let email = self.emailTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }
        self.viewModel.signIn(email: email, password: password)
        self.siginInListener()
    }
    
    @IBAction func presentRegisterView(_ sender: Any) {
        let registerVC = StoryboardManager.registerViewController()
        self.present(registerVC, animated: true, completion: nil)
    }
    
}
// MARK: listener
extension LoginViewController {
    private func siginInListener() {
        self.handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user != nil {
                let storyBoard = UIStoryboard(name: "GroupList", bundle: nil)
                let groupListVC = storyBoard.instantiateViewController(withIdentifier: "groupListNavigation")
                self.present(groupListVC, animated: true, completion: nil)
            }
        })
    }
    
    private func signInErrorListener() {
        self.viewModel.errorString
        .asObservable()
        .bind(to: self.errorLabel.rx.text)
        .disposed(by: self.disposeBag)
    }
}
// MARK: mocks [TO REMOVE]
extension LoginViewController {
    func mockLoginData() {
        self.emailTextField.text = "kuba@test.com"
        self.passwordTextField.text = "kuba1234567"
    }
}
