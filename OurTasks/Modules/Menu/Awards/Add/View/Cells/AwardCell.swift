//
//  AwardCell.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 18/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit

class AwardCell: UITableViewCell {

    @IBOutlet weak var awardName: UILabel!
    
    @IBOutlet weak var exchangeBtn: UIButton!
    
    @IBOutlet weak var costTitleLbl: UILabel!
    @IBOutlet weak var costLbl: UILabel!
    
    @IBOutlet weak var availableTitleLbl: UILabel!
    @IBOutlet weak var availableLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.costTitleLbl.text = "cost".localize()
        self.availableTitleLbl.text = "available".localize()
    }
    
    @IBAction func exchangeAction(_ sender: Any) {
        
    }
    
    func configure(_ model: AwardCellModel) {
        self.awardName.text = model.model.name
        self.costLbl.text = String(model.model.cost)
        self.availableLbl.text = String(model.model.available)
    }
}
