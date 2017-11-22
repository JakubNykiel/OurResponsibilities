//
//  LoginViewModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 20.11.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import Foundation
import Firebase
import RxSwift

class LoginViewModel {
    
    let errorString = Variable<String>("")
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard let errorDescription = error?.localizedDescription else { return }
            self.errorString.value = errorDescription
        }
    }
}
