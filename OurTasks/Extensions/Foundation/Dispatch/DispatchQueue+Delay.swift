//
//  DispatchQueue+Delay.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 02.06.2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation

public extension DispatchQueue {
    
    private class func delay(delay: TimeInterval, closure: @escaping () -> Void) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    class func performAction(after seconds: TimeInterval, callBack: @escaping (() -> Void) ) {
        DispatchQueue.delay(delay: seconds) {
            callBack()
        }
    }
    
}
