//
//  UITableViewCell+Enable.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 18/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    func enable(on: Bool) {
        self.isUserInteractionEnabled = on
        for view in contentView.subviews {
            self.isUserInteractionEnabled = on
            view.alpha = on ? 1 : 0.5
        }
    }
}
