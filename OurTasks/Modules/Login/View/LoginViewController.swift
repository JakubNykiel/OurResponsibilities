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
    
    @IBOutlet weak var signBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var signLbl: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var bottomTextFieldsConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorLabel: UILabel!
    
    let viewModel = LoginViewModel()
    private var handle: AuthStateDidChangeListenerHandle?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareTexts()
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
        self.validation()
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
// MARK: Prepare
extension LoginViewController {
    func validation() {
        let emailValid = emailTextField.rx.text.orEmpty.map{ $0.count > 0 }.share(replay: 1)
        let passwordValid = passwordTextField.rx.text.orEmpty.map{ $0.count > 0 }.share(replay: 1)
        
        let everythingValid = Observable.combineLatest(emailValid, passwordValid) { $0 && $1 }
            .share(replay: 1)
        
        everythingValid
            .bind(to: self.signBtn.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
// MARK: listener
extension LoginViewController {
    private func siginInListener() {
        self.handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user != nil {
                let storyBoard = UIStoryboard(name: "GroupList", bundle: nil)
                let groupListVC = StoryboardManager.groupListViewController()
                let navController = UINavigationController(rootViewController: groupListVC)
                self.present(navController, animated: true, completion: nil)
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
//MARK: Localize
extension LoginViewController {
    func prepareTexts() {
        self.signLbl.text = "signIn".localize()
        self.emailTextField.placeholder = "email".localize()
        self.passwordTextField.placeholder = "password".localize()
        self.signBtn.setTitle("signInAction".localize(), for: .normal)
        self.registerBtn.setTitle("notRegisterYet".localize(), for: .normal)
    }
}
