//
//  AddEventViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 24.05.2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit
import RxSwift

class AddEventViewController: UIViewController {

    @IBOutlet weak var bottomTextFieldsConstraint: NSLayoutConstraint!
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
    private let endDatePicker: UIPickerView = UIPickerView()
    private let days = Array(1...365)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.containerDependOnKeyboardBottomConstrain = bottomTextFieldsConstraint
        self.watchForKeyboard()
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
        dateFormatter.dateFormat = "dd MMM yyyy"
        self.startDateTF.text = dateFormatter.string(from: sender.date)
    }
    
    @objc private func donePicker() {
        // trzeba dodać zapis informacji z tych pickerów
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
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "choose".localize(), style: UIBarButtonItemStyle.done, target: self, action: #selector(donePicker))
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        toolBar.setItems([flexible,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.startDatePicker.tag = 1
        self.startDatePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        self.startDateTF.inputView = self.startDatePicker
        self.startDateTF.inputAccessoryView = toolBar
        
        self.endDatePicker.tag = 2
        self.endDatePicker.delegate = self
        self.endDateTF.inputView = self.endDatePicker
        self.endDateTF.inputAccessoryView = toolBar
    }
}

extension AddEventViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 2 || textField.tag == 3 {
            textField.resignFirstResponder()
            return true
        } else {
            return false
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 2 {
            return days.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50.0
    }

}
