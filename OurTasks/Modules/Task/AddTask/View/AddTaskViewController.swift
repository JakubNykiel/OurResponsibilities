//
//  AddTaskViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 24.05.2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit
import RxSwift

class AddTaskViewController: UITableViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var endDateLbl: UILabel!
    @IBOutlet weak var endTF: UITextField!
    
    @IBOutlet weak var usersInteractionLbl: UILabel!
    @IBOutlet weak var usersInteractionSwitch: UISwitch!
    
    @IBOutlet weak var globalPointsLbl: UILabel!
    @IBOutlet weak var globalPositivePointsTF: UITextField!
    @IBOutlet weak var globalNegativePointsTF: UITextField!
    
    @IBOutlet weak var eventPointsLbl: UILabel!
    @IBOutlet weak var eventPositivePointsTF: UITextField!
    @IBOutlet weak var eventNegativePointsTF: UITextField!
    
    @IBOutlet weak var arHeight: NSLayoutConstraint!
    @IBOutlet weak var arLbl: UILabel!
    @IBOutlet weak var addInAR: UIButton!
    @IBOutlet weak var switchAR: UISwitch!
    @IBOutlet weak var qrName: UILabel!
    @IBOutlet weak var qrNameValueLbl: UILabel!
    @IBOutlet weak var xValueLbl: UILabel!
    @IBOutlet weak var yValueLbl: UILabel!
    @IBOutlet weak var zValueLbl: UILabel!
    
    var viewModel: AddTaskViewModel?
    private let disposeBag = DisposeBag()
    private let firebaseManager = FirebaseManager()
    private let endDatePicker: UIDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.prepare()
    }
    
    func prepare() {
        self.addInAR.isHidden = true
        self.switchAR.isOn = false
        self.prepareTexts()
        self.prepareTextFields()
        self.preparePickers()
    }

    @IBAction func switchARAction(_ sender: Any) {
        self.addInAR.isHidden = !self.switchAR.isOn
        self.view.layoutIfNeeded()
    }
    
    @IBAction func ARAction(_ sender: Any) {
        
    }
    
    @IBAction func addTask(_ sender: Any) {
        let currentUserUid = self.firebaseManager.getCurrentUserUid()
        self.viewModel?.taskModel = TaskModel(
            owner: currentUserUid,
            name: self.nameTF.text ?? "",
            endDate: self.endTF.text ?? "",
            users: [],
            positivePoints: Int(self.eventPositivePointsTF.text ?? "0")!,
            negativePoints: -Int(self.eventNegativePointsTF.text ?? "0")!,
            userInteraction: self.usersInteractionSwitch.isOn,
            AR: self.switchAR.isOn,
            arTask: self.viewModel?.arTaskModel,
            state: TaskState.backlog.rawValue,
            globalPositivePoints: Int(self.globalPositivePointsTF.text ?? "0")!,
            globalNegativePoints: -Int(self.globalNegativePointsTF.text ?? "0")!)
        self.viewModel?.addTaskToDatabase()
        self.navigationController?.popViewController(animated: true)
    }
}
extension AddTaskViewController {
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        self.endTF.text = dateFormatter.string(from: sender.date)
    }
    
    @objc private func donePicker() {
        dismissKeyboard()
    }
    
    func prepareTexts() {
        self.navigationController?.title = "addEvent".localize()
        self.nameLbl.text = "name".localize()
        self.endDateLbl.text = "end_date".localize()
        self.globalPointsLbl.text = "global_points".localize()
        self.arLbl.text = "AR".localize()
        self.qrName.text = "QR_name".localize()
    }
    
    func prepareTextFields() {
        self.nameTF.tag = 1
        self.nameTF.setBottomBorder()
        self.nameTF.delegate = self
        
        self.endTF.tag = 2
        self.endTF.setBottomBorder()
        self.endTF.delegate = self
        
        self.globalPositivePointsTF.tag = 3
        self.globalPositivePointsTF.setBottomBorder()
        self.globalPositivePointsTF.delegate = self
        
        self.globalNegativePointsTF.tag = 4
        self.globalNegativePointsTF.setBottomBorder()
        self.globalNegativePointsTF.delegate = self
        
        self.eventPositivePointsTF.tag = 5
        self.eventPositivePointsTF.setBottomBorder()
        self.eventPositivePointsTF.delegate = self
        
        self.eventNegativePointsTF.tag = 6
        self.eventNegativePointsTF.setBottomBorder()
        self.eventNegativePointsTF.delegate = self
        
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
        
        self.endDatePicker.tag = 1
        self.endDatePicker.minimumDate = Date()
        self.endDatePicker.datePickerMode = .date
        self.endDatePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        self.endTF.inputView = self.endDatePicker
        self.endTF.inputAccessoryView = toolBar
        
    }
}

extension AddTaskViewController: UIPickerViewDelegate, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 2 {
            textField.resignFirstResponder()
            return true
        } else {
            return false
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50.0
    }
    
}
extension AddTaskViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
