//
//  UINavigation+BackgroundColor.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 19.05.2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit

@IBDesignable extension UINavigationController {
    @IBInspectable var backgroundColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            navigationBar.backgroundColor = uiColor
        }
        get {
            guard let color = navigationBar.backgroundColor else { return nil }
            return color
        }
    }
}

