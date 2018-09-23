//
//  QRCodeCell.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 23/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit

class QRCodeCell: UITableViewCell {
    
    @IBOutlet weak var user: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func confifure(_ model: QRCellModel) {
        if model.model.main {
            self.user.text = "GŁÓWNY"
        } else {
            self.user.text = model.model.user
        }
        
    }

}
