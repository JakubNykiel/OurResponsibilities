//
//  GroupInviteCell.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 18.04.2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit

class GroupInviteCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet var acceptInvitationButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(_ model: UserInvitesCellModel) {
        self.nameLbl.text = model.name
        self.acceptInvitationButton.setTitle(model.followBtnText, for: .normal)
    }
}
