//
//  KeyboardObservers.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 12.09.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import Foundation
import UIKit

private var xoAssociationKeyForBottomConstrainInVC: UInt8 = 0
private var beginConstraint: CGFloat = 0

extension UIViewController {
    var containerDependOnKeyboardBottomConstrain :NSLayoutConstraint! {
        get {
            return objc_getAssociatedObject(self, &xoAssociationKeyForBottomConstrainInVC) as? NSLayoutConstraint
        }
        set(newValue) {
            objc_setAssociatedObject(self, &xoAssociationKeyForBottomConstrainInVC, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    
    
    func watchForKeyboard() {
        beginConstraint = containerDependOnKeyboardBottomConstrain.constant
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.containerDependOnKeyboardBottomConstrain.constant = keyboardFrame.height + beginConstraint
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.containerDependOnKeyboardBottomConstrain.constant = beginConstraint
            self.view.layoutIfNeeded()
        })
    }
} 
