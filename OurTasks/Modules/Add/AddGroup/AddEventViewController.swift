//
//  AddEventViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 24.05.2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit
import RxSwift
//TODO: Block add button when fields are empty
class AddEventViewController: UITableViewController {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var startDateLbl: UILabel!
    @IBOutlet weak var startDateTF: UITextField!
    
    @IBOutlet weak var endDateLbl: UILabel!
    @IBOutlet weak var endDateTF: UITextField!
    
    @IBOutlet weak var winnerPointsLbl: UILabel!
    @IBOutlet weak var winnerPointsTF: UITextField!
    
    var viewModel: AddEventViewModel!
    private let disposeBag = DisposeBag()
    private let firebaseManager = FirebaseManager()
    private let startDatePicker: UIDatePicker = UIDatePicker()
    private let endDatePicker: UIDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        self.prepare()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.eventAdded.asObservable()
            .subscribe(onNext: {
                if $0 {
                    self.navigationController?.popViewController(animated: true)
                }
            }).disposed(by: self.disposeBag)
    }
    
    func prepare() {
        self.prepareTexts()
        self.prepareTextFields()
        self.preparePickers()
    }
    
    @IBAction func presentTask(_ sender: Any) {
        
    }
    
    @IBAction func addEvent(_ sender: Any) {
        let currentUserUid = self.firebaseManager.getCurrentUserUid()
        self.viewModel.eventModel = EventModel.init(name: nameTF.text ?? "", startDate: startDateTF.text ?? "", dayToEnd: Int(self.endDateTF.text ?? "") ?? 0 , admins: [currentUserUid], users: [], tasks: [], winnerGlobalPoints: Int(self.winnerPointsTF.text ?? "") ?? 0)
        self.viewModel.addEventToDatabase()
    }
    
}
//MARK: Prepare
extension AddEventViewController {
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        if sender.tag == 1 {
            self.startDateTF.text = dateFormatter.string(from: sender.date)
            self.endDatePicker.minimumDate = sender.date
            if endDatePicker.date < sender.date {
                self.endDateTF.text = dateFormatter.string(from: sender.date)
                self.endDatePicker.date = sender.date
                //TODO: Add end date to view model
            }
            self.endDateTF.alpha = 1
            self.endDateLbl.alpha = 1
            self.endDateTF.isUserInteractionEnabled = true
            //TODO: Add start date to view model
        } else if sender.tag == 2 {
            self.endDateTF.text = dateFormatter.string(from: sender.date)
            //TODO: Add end date to view model
        }
        
    }
    
    @objc private func donePicker() {
        dismissKeyboard()
    }
    
    func prepareTexts() {
        self.navigationController?.title = "addEvent".localize()
        self.nameLbl.text = "name".localize()
        self.startDateLbl.text = "start_date".localize()
        self.endDateLbl.text = "end_date".localize()
        self.winnerPointsLbl.text = "winner_points".localize()
    }
    
    func prepareTextFields() {
        self.nameTF.tag = 1
        self.nameTF.setBottomBorder()
        self.startDateTF.tag = 2
        self.startDateTF.setBottomBorder()
        self.endDateTF.tag = 3
        self.endDateTF.setBottomBorder()
        self.winnerPointsTF.tag = 4
        self.winnerPointsTF.setBottomBorder()
        self.winnerPointsTF.keyboardType = .numberPad
    }
    
    func preparePickers() {
        self.startDatePicker.tag = 1
        self.startDatePicker.datePickerMode = .date
        self.startDatePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        self.startDateTF.inputView = self.startDatePicker
        
        self.endDateTF.alpha = 0.5
        self.endDateLbl.alpha = 0.5
        self.endDateTF.isUserInteractionEnabled = false
        self.endDatePicker.tag = 2
        self.endDatePicker.datePickerMode = .date
        self.endDatePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        self.endDateTF.inputView = self.endDatePicker
    }
    
}
//MARK: TextField
extension AddEventViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 2 || textField.tag == 3 {
            textField.resignFirstResponder()
            return true
        } else {
            return false
        }
    }

}
