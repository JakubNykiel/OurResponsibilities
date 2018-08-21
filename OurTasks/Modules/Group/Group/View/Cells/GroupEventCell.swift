//
//  GroupEventCell.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 17/08/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit

class GroupEventCell: UITableViewCell {
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var titleStart: UILabel!
    @IBOutlet weak var eventStartDate: UILabel!
    @IBOutlet weak var titleEnd: UILabel!
    @IBOutlet weak var eventEndDate: UILabel!
    
    private let dateFormatter = DateFormatter()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         self.dateFormatter.dateFormat = "dd.MM.yyyy"
    }

    func configure(_ model: GroupEventCellModel) {
        self.eventName.text = model.eventModel.name
        self.titleStart.text = "event_start".localize()
        self.eventStartDate.text = model.eventModel.startDate
        self.titleEnd.text = "event_end".localize()
        self.eventEndDate.text = model.eventModel.endDate
    }
}
