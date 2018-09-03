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
    
    @IBOutlet weak var addEventBtn: UIButton!
    
    
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
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                    if self.viewModel.viewState == .add {
                        self.navigationController?.popViewController(animated: true)
                    } else {
                       self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                    }
                }
            }).disposed(by: self.disposeBag)
    }
    
    func prepare() {
        self.prepareTexts()
        self.prepareTextFields()
        self.preparePickers()
        self.dateFormatter.dateFormat = "dd.MM.yyyy"
        self.navigationItem.title = "add_event".localize()
        if self.viewModel.viewState == AddEventViewState.update {
            self.prepareUpdateView()
        } else {
            self.viewModel.getGroupInfo()
        }
        self.validation()
    }
    
    @IBAction func addEvent(_ sender: Any) {
        let currentUserUid = self.firebaseManager.getCurrentUserUid()
        if self.viewModel.viewState == AddEventViewState.add {
            self.viewModel.eventModel = EventModel.init(name: nameTF.text ?? "", startDate: startDateTF.text ?? "", endDate: endDateTF.text ?? "", admins: [currentUserUid], users: self.viewModel.users, tasks: [], winnerGlobalPoints: Int(self.winnerPointsTF.text ?? "") ?? 0)
            self.viewModel.addEventToDatabase()
        } else {
            guard let model = self.viewModel.eventModelToUpdate?.first?.value else { return }
            self.viewModel.eventModel = EventModel.init(name: nameTF.text ?? "", startDate: startDateTF.text ?? "", endDate: endDateTF.text ?? "", admins: model.admins ?? [], users: model.users, tasks: model.tasks ?? [], winnerGlobalPoints: Int(self.winnerPointsTF.text ?? "") ?? 0)
            self.viewModel.updateEvent()
        }
    }
    
}
//MARK: Prepare
extension AddEventViewController {
    
    private func prepareUpdateView() {
        guard let model = self.viewModel.eventModelToUpdate?.first?.value else { return }
        self.nameTF.text = model.name
        self.startDateTF.text = model.startDate
        self.endDateTF.text = model.endDate
        self.winnerPointsTF.text = String(model.winnerGlobalPoints)
    }
    
    @objc private func donePicker() {
        dismissKeyboard()
    }
    
    func validation() {
        let nameValid = nameTF.rx.text.orEmpty.map{ $0.count > 0 }.share(replay: 1)
        let pointValid = winnerPointsTF.rx.text.orEmpty.map{ $0.count > 0 }.share(replay: 1)
        
        let everythingValid = Observable.combineLatest(nameValid, pointValid) { $0 && $1 }
            .share(replay: 1)
        
        self.addEventBtn.setTitleColor(AppColor.gray, for: .disabled)
        everythingValid.asObservable()
            .subscribe(onNext: {
                self.addEventBtn.isEnabled = $0
            }).disposed(by: self.disposeBag)
    }
    
    func prepareTexts() {
        self.navigationController?.title = "addEvent".localize()
        self.nameLbl.text = "event_name".localize()
        self.startDateLbl.text = "start_date".localize()
        self.endDateLbl.text = "end_date".localize()
        self.winnerPointsLbl.text = "winner_points".localize()
        let buttonText: String = self.viewModel?.viewState == .add ? "add".localize() : "update".localize()
        self.addEventBtn.setTitle(buttonText, for: .normal)
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
        
        if self.viewModel.viewState == AddEventViewState.add {
            self.endDateTF.alpha = 0.5
            self.endDateLbl.alpha = 0.5
            self.endDateTF.isUserInteractionEnabled = false
        }
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

