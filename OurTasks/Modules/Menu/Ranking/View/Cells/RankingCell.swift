//
//  RankingCell.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 11/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit

class RankingCell: UITableViewCell {

    @IBOutlet weak var positionLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var pointsTitleLbl: UILabel!
    @IBOutlet weak var pointsLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.pointsTitleLbl.text = "points".localize()
    }

    func configureGroup(_ model: RankingGroupCellModel) {
        self.usernameLbl.text = model.name
        self.pointsLbl.text = String(model.points)
    }
    
    func configureEvent(_ model: RankingEventCellModel) {
        self.usernameLbl.text = model.name
        self.pointsLbl.text = String(model.points)
    }

}
