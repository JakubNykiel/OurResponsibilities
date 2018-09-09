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
    @IBOutlet weak var taskEndDateTitle: UILabel!
    @IBOutlet weak var taskEndDate: UILabel!
    @IBOutlet weak var groupNameTitle: UILabel!
    @IBOutlet weak var groupName: UILabel!

    private let dateFormatter = DateFormatter()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.dateFormatter.dateFormat = "dd.MM.yyyy"
        self.taskEndDateTitle.text = "end".localize()
        self.groupNameTitle.text = "group_name".localize()
    }

    func configure(_ model: GroupTaskCellModel) {
        self.taskName.text = model.taskModel.name
        self.taskEndDate.text = model.taskModel.endDate
        self.groupName.text = model.groupName
    }


}
