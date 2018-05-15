//
//  GroupTaskCell.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 09.05.2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit

class GroupTaskCell: UITableViewCell {
    
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskEndDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure() {
        
    }

}
