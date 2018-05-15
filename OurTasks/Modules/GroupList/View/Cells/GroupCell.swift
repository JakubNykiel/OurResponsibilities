//
//  GroupCell.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 26.03.2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var groupColor: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(_ model: UserGroupsCellModel) {
        self.nameLbl.text = model.groupModel.name
        self.groupColor.backgroundColor = model.groupModel.color.hexStringToUIColor()
    }
}
