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
    
    @IBOutlet weak var alreadyAccountBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
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
        self.prepareTexts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerBtn.isEnabled = false
        self.validation()
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
//MARK: Prepare
extension RegisterViewController {
    func validation() {
        let usernameValid = usernameTextField.rx.text.orEmpty.map{ $0.count > 0 }.share(replay: 1)
        let emailValid = emailTextField.rx.text.orEmpty.map{ $0.count > 0 }.share(replay: 1)
        let passwordValid = passwordTextField.rx.text.orEmpty.map{ $0.count > 0 }.share(replay: 1)
        
        let everythingValid = Observable.combineLatest(usernameValid, emailValid, passwordValid) { $0 && $1 && $2 }
            .share(replay: 1)
        
        everythingValid
            .bind(to: self.registerBtn.rx.isEnabled)
            .disposed(by: disposeBag)
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
    
    private func showViewAfterSuccessfulRegistration() {
        let storyBoard = UIStoryboard(name: "GroupList", bundle: nil)
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "loginNavigation")
        self.present(mainViewController, animated: true, completion: nil)
    }
}
// MARK: Localize
extension RegisterViewController {
    private func prepareTexts() {
        self.usernameTextField.placeholder = "username".localize()
        self.emailTextField.placeholder = "email".localize()
        self.passwordTextField.placeholder = "password".localize()
        self.registerBtn.setTitle("register".localize(), for: .normal)
        self.alreadyAccountBtn.setTitle("alreadyAccount".localize(), for: .normal)
    }
}
