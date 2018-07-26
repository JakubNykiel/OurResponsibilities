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
    private let dateFormatter = DateFormatter()
    
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
        self.dateFormatter.dateFormat = "dd.MM.yyyy"
    }
    
    @IBAction func presentTask(_ sender: Any) {
        
    }
    
    @IBAction func addEvent(_ sender: Any) {
        let currentUserUid = self.firebaseManager.getCurrentUserUid()
        self.viewModel.eventModel = EventModel.init(name: nameTF.text ?? "", startDate: startDateTF.text ?? "", endDate: endDateTF.text ?? "", admins: [currentUserUid], users: [], tasks: [], winnerGlobalPoints: Int(self.winnerPointsTF.text ?? "") ?? 0)
        self.viewModel.addEventToDatabase()
    }
    
}
//MARK: Prepare
extension AddEventViewController {
    
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
        self.nameTF.delegate = self
        self.startDateTF.tag = 2
        self.startDateTF.setBottomBorder()
        self.startDateTF.delegate = self
        self.endDateTF.tag = 3
        self.endDateTF.setBottomBorder()
        self.endDateTF.delegate = self
        self.winnerPointsTF.tag = 4
        self.winnerPointsTF.setBottomBorder()
        self.winnerPointsTF.keyboardType = .numberPad
        self.winnerPointsTF.delegate = self
    }
    
    func preparePickers() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "choose".localize(), style: UIBarButtonItemStyle.done, target: self, action: #selector(donePicker))
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        toolBar.setItems([flexible,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.startDatePicker.tag = 1
        self.startDatePicker.datePickerMode = .date
        self.startDatePicker.minimumDate = Date()
        self.startDatePicker.setDate(Date(), animated: true)
        self.startDateTF.inputView = self.startDatePicker
        self.startDateTF.inputAccessoryView = toolBar
        
        self.endDateTF.alpha = 0.5
        self.endDateLbl.alpha = 0.5
        self.endDateTF.isUserInteractionEnabled = false
        self.endDatePicker.tag = 2
        self.endDatePicker.datePickerMode = .date
        self.endDateTF.inputView = self.endDatePicker
        self.endDateTF.inputAccessoryView = toolBar
    }
    
}
//MARK: TextField
extension AddEventViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 2 {
            self.startDateTF.text = dateFormatter.string(from: self.startDatePicker.date)
            self.endDatePicker.minimumDate = self.startDatePicker.date
            if endDatePicker.date < self.startDatePicker.date {
                self.endDateTF.text = dateFormatter.string(from: self.startDatePicker.date)
                self.endDatePicker.date =  self.startDatePicker.date
            }
            self.endDateTF.alpha = 1
            self.endDateLbl.alpha = 1
            self.endDateTF.isUserInteractionEnabled = true
        } else if textField.tag == 3 {
            self.endDateTF.text = dateFormatter.string(from: self.endDatePicker.date)
        }
    }
}
