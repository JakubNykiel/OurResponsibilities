//
//  AddTaskViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 24.05.2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit
import RxSwift

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var endDateLbl: UILabel!
    @IBOutlet weak var endTF: UITextField!
    
    @IBOutlet weak var globalPointsLbl: UILabel!
    @IBOutlet weak var globalPointsTF: UITextField!
    
    @IBOutlet weak var positivePointsLbl: UILabel!
    @IBOutlet weak var positivePointsTF: UITextField!
    
    @IBOutlet weak var negativePointsLbl: UILabel!
    @IBOutlet weak var negativePointsTF: UITextField!
    
    @IBOutlet weak var arHeight: NSLayoutConstraint!
    @IBOutlet weak var arLbl: UILabel!
    @IBOutlet weak var addInAR: UIButton!
    @IBOutlet weak var switchAR: UISwitch!
    @IBOutlet weak var qrName: UILabel!
    @IBOutlet weak var qrNameValueLbl: UILabel!
    @IBOutlet weak var xLbl: UILabel!
    @IBOutlet weak var yLbl: UILabel!
    @IBOutlet weak var zLbl: UILabel!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var viewModel: AddTaskViewModel?
    private let disposeBag = DisposeBag()
    private let firebaseManager = FirebaseManager()
    private let endDatePicker: UIDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.containerDependOnKeyboardBottomConstrain = bottomConstraint
        self.watchForKeyboard()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    func prepare() {
        self.addInAR.isHidden = true
        self.prepareTexts()
        self.prepareTextFields()
        self.preparePickers()
    }

    @IBAction func switchARAction(_ sender: Any) {
        self.addInAR.isHidden = !self.switchAR.isOn
        if self.switchAR.isOn {
            self.arHeight.constant = 80
        } else {
            self.arHeight.constant = 31
        }
        self.view.layoutIfNeeded()
    }
    
    @IBAction func ARAction(_ sender: Any) {
        
    }
    
    @IBAction func addTask(_ sender: Any) {
        
    }
}
extension AddTaskViewController {
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        self.endTF.text = dateFormatter.string(from: sender.date)
    }
    
    @objc private func donePicker() {
        // trzeba dodać zapis informacji z tych pickerów
        dismissKeyboard()
    }
    
    func prepareTexts() {
        self.navigationController?.title = "addEvent".localize()
        self.nameLbl.text = "name".localize()
        self.endDateLbl.text = "end_date".localize()
        self.positivePointsLbl.text = "positive_points".localize()
        self.negativePointsLbl.text = "negative_points".localize()
        self.globalPointsLbl.text = "global_points".localize()
        self.arLbl.text = "AR".localize()
        self.qrName.text = "QR".localize()
    }
    
    func prepareTextFields() {
        self.nameTF.tag = 1
        self.endTF.tag = 2
        self.globalPointsTF.tag = 3
        self.positivePointsTF.tag = 4
        self.negativePointsTF.tag = 5
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
