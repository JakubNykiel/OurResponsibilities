//
//  TaskCell.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 26/08/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var taskNameLbl: UILabel!
    @IBOutlet weak var taskStateLbl: TaskStateLabel!
    @IBOutlet weak var endDateTitleLbl: UILabel!
    @IBOutlet weak var endDateLbl: UILabel!
    
    func configure(_ model: EventTaskCellModel) {
        self.taskNameLbl.text = model.taskModel.name
        self.taskStateLbl.configure(model.taskModel.state)
        self.endDateTitleLbl.text = "end_date".localize()
        self.endDateLbl.text = model.taskModel.endDate
    }

}
