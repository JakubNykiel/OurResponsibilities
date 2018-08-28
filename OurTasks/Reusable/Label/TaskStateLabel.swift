//
//  TaskStateLabel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 27/08/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import UIKit

class TaskStateLabel: UILabel {
    
    override func awakeFromNib() {
        self.layer.masksToBounds = true
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 5
    }
    
    func configure(_ state: String, isActive: Bool = true) {
        var color = UIColor()
        guard let taskState = TaskState(rawValue: state) else {
            self.isHidden = true
            return
        }
        if taskState == .backlog {
            color = AppColor.appleBlue
        } else if taskState == .done {
            color = AppColor.appleGreen
        } else if taskState == .inProgress {
            color = AppColor.appleYellow
        } else if taskState == .toFix {
            color = AppColor.appleRed
        }
        
        if !isActive {
            color = AppColor.gray
        }
        
        self.layer.borderColor = color.cgColor
        self.textColor = color
        self.backgroundColor = color.withAlphaComponent(0.5)
        self.text = state.capitalized
    }
}
