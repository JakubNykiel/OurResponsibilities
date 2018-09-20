//
//  AwardHistoryCell.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 20/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit

class AwardHistoryCell: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var awardName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(_ model: AwardHistoryCellModel) {
        self.dateLbl.text = model.date
        self.awardName.text = model.model.name
    }

}
