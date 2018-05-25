//
//  AddEventViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 24.05.2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var startDateLbl: UILabel!
    @IBOutlet weak var startDateTF: UITextField!
    
    @IBOutlet weak var endDateLbl: UILabel!
    @IBOutlet weak var endDateTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepare()
        
    }
    
    func prepare() {
        
    }

}
//MARK: Prepare
extension AddEventViewController {
    func prepareTexts() {
        self.navigationController?.title = "addEvent".localize()
        self.nameLbl.text = "name".localize()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from:date as Date)
    }
}
