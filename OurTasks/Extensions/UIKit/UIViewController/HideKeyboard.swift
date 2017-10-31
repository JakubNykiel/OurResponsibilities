//
//  HideKeyboard.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 12.09.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapSelector = #selector(UIViewController.dismissKeyboard)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: tapSelector)
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
