//
//  RegisterViewModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 13.09.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import Foundation
import Firebase

class RegisterViewModel {
    
    func createUser(email: String?, password: String?) {
        guard let email = email, let password = password else { return }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("Error with create user: \(error)")
            }
            if let user = user {
                print(user)
            }
        }
    }
    
}
