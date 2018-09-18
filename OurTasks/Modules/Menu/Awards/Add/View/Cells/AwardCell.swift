//
//  AwardCell.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 18/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit

protocol AwardProtocol {
    func editTap(id: String, model: AwardModel)
    func exchangeTap(id: String)
}

class AwardCell: UITableViewCell {

    @IBOutlet weak var awardName: UILabel!
    
    @IBOutlet weak var exchangeBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var costTitleLbl: UILabel!
    @IBOutlet weak var costLbl: UILabel!
    
    @IBOutlet weak var availableTitleLbl: UILabel!
    @IBOutlet weak var availableLbl: UILabel!
    
    var delegate: AwardProtocol?
    var model: AwardCellModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.costTitleLbl.text = "cost".localize()
        self.availableTitleLbl.text = "available".localize()
    }
    
    @IBAction func exchangeAction(_ sender: Any) {
        guard let awardModel = self.model else { return }
        self.delegate?.exchangeTap(id: awardModel.id)
    }
    
    @IBAction func editAction(_ sender: Any) {
        guard let awardModel = self.model else { return }
        self.delegate?.editTap(id: awardModel.id, model: awardModel.model)
    }
    
    func configure(_ model: AwardCellModel) {
        self.model = model
        self.awardName.text = model.model.name
        self.costLbl.text = String(model.model.cost)
        self.availableLbl.text = String(model.model.available)
    }
}
