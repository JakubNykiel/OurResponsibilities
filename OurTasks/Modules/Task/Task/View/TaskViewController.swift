//
//  TaskViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 27/08/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit
import RxSwift

class TaskViewController: UIViewController {
    
    @IBOutlet var informationView: UIView!
    
    @IBOutlet weak var taskNameTitle: UILabel!
    @IBOutlet weak var taskName: UILabel!
    
    @IBOutlet weak var taskOwnerTitle: UILabel!
    @IBOutlet weak var taskOwner: UILabel!
    
    @IBOutlet weak var taskEndDateTitle: UILabel!
    @IBOutlet weak var taskEndDateLbl: UILabel!
    
    @IBOutlet weak var eventPointsTitle: UILabel!
    @IBOutlet weak var eventPositivePointsTitle: UILabel!
    @IBOutlet weak var eventPositivePoints: UILabel!
    @IBOutlet weak var eventNegativePointsTitle: UILabel!
    @IBOutlet weak var eventNegativePoints: UILabel!
    
    @IBOutlet weak var generalPointsTitle: UILabel!
    @IBOutlet weak var generalPoints: UILabel!
    
    @IBOutlet weak var stateView: UIView!
    @IBOutlet weak var backlogLbl: TaskStateLabel!
    @IBOutlet weak var inProgressLbl: TaskStateLabel!
    @IBOutlet weak var toFixLbl: TaskStateLabel!
    @IBOutlet weak var doneLbl: TaskStateLabel!
    @IBOutlet weak var reviewLbl: TaskStateLabel!
    
    @IBOutlet weak var userStateView: UIStackView!
    @IBOutlet weak var resignButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    
    @IBOutlet weak var descriptionTitle: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    var viewModel: TaskViewModel?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareOnLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.prepareOnAppear()
    }
    
    @IBAction func editTaskAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "", message: "Wybierz opcję", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Edycja", style: .default , handler:{ (UIAlertAction)in
            guard let taskID = self.viewModel?.taskID else { return }
            guard let taskModel = self.viewModel?.taskModel.value else { return }
            let addTaskVC = StoryboardManager.addTaskViewController(taskModel.groupID, taskModel.eventID, state: .update, taskModel: [ taskID : taskModel])
            addTaskVC.modalPresentationStyle = .overCurrentContext
            self.navigationController?.pushViewController(addTaskVC, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Niewykonano", style: .destructive , handler:{ (UIAlertAction)in
            self.viewModel?.endTask()
        }))
        
        alert.addAction(UIAlertAction(title: "Powrót", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
        guard let taskID = self.viewModel?.taskID else { return }
        guard let taskModel = self.viewModel?.taskModel.value else { return }
        let addTaskVC = StoryboardManager.addTaskViewController(taskModel.groupID, taskModel.eventID, state: .update, taskModel: [ taskID : taskModel])
        addTaskVC.modalPresentationStyle = .overCurrentContext
        self.navigationController?.pushViewController(addTaskVC, animated: true)
    }
    
}
//MARK: Prepare
extension TaskViewController {
    func prepareOnLoad() {
        self.navigationItem.title = "details".localize()
        self.descriptionLbl.text = "description".localize()
        self.resignButton.setTitle("resign".localize(), for: .normal)
    }
    
    func prepareOnAppear() {
        self.prepareButtons()
        self.bindInformation()
        self.prepareStateLabels()
        self.viewModel?.bindTask()
    }
    
    private func prepareView(_ model: TaskModel) {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        switch model.state {
        case TaskState.backlog.rawValue:
            self.backlogLbl.configure(TaskState.backlog.rawValue, isActive: true)
            self.informationView.backgroundColor = self.backlogLbl.backgroundColor
        case TaskState.inProgress.rawValue:
            self.inProgressLbl.configure(TaskState.inProgress.rawValue, isActive: true)
            self.informationView.backgroundColor = self.inProgressLbl.backgroundColor
        case TaskState.toFix.rawValue:
            self.toFixLbl.configure(TaskState.toFix.rawValue, isActive: true)
            self.informationView.backgroundColor = self.toFixLbl.backgroundColor
        case TaskState.done.rawValue:
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.doneLbl.configure(TaskState.done.rawValue, isActive: true)
            self.informationView.backgroundColor = self.doneLbl.backgroundColor
        //TODO: zablokuj aboslutnie wszystko bo już Done i elo i koniec
        case TaskState.review.rawValue:
            self.reviewLbl.configure(TaskState.review.rawValue, isActive: true)
            self.informationView.backgroundColor = self.reviewLbl.backgroundColor
        default:
            break
        }
    }
    
    private func disableButton(_ button: UIButton) {
        button.alpha = 0.5
        button.isEnabled = false
    }
    
    private func enableButton(_ button: UIButton) {
        button.alpha = 1.0
        button.isEnabled = true
    }
    
    private func prepareButtons() {
        self.resignButton.backgroundColor = AppColor.appleRed
        self.checkButton.backgroundColor = AppColor.appleGreen
    }
    
    private func bindInformation() {
        
        self.viewModel?.taskModel.asObservable().subscribe(onNext: {
            guard let model = $0 else { return }
            self.prepareView(model)
        }).disposed(by: self.disposeBag)
        
        self.viewModel?.taskName.asObservable()
            .bind(to: self.taskName.rx.text)
            .disposed(by: self.disposeBag)
        
        self.viewModel?.taskOwner.asObservable()
            .bind(to: self.taskOwner.rx.text)
            .disposed(by: self.disposeBag)
        
        self.viewModel?.taskDate.asObservable()
            .bind(to: self.taskEndDateLbl.rx.text)
            .disposed(by: self.disposeBag)
        
        self.viewModel?.eventNegativePoints.asObservable()
            .bind(to: self.eventNegativePoints.rx.text)
            .disposed(by: self.disposeBag)
        
        self.viewModel?.eventPositivePoints.asObservable()
            .bind(to: self.eventPositivePoints.rx.text)
            .disposed(by: self.disposeBag)
        
        self.viewModel?.generalPoints.asObservable()
            .bind(to: self.generalPoints.rx.text)
            .disposed(by: self.disposeBag)
        
        self.viewModel?.description.asObservable()
            .bind(to: self.descriptionLbl.rx.text)
            .disposed(by: self.disposeBag)
        
        self.viewModel?.taskViewState.asObservable()
            .subscribe(onNext: {
                if $0 == .user {
                    self.prepareUserView()
                } else if $0 == .admin {
                    self.prepareAdminView()
                } else if $0 == .unassignedTaskUser {
                    self.prepareUnassignedView()
                } else if $0 == .viewer {
                    self.prepareViewerView()
                }
            }).disposed(by: self.disposeBag)
    }
    
    private func prepareStateLabels() {
        self.backlogLbl.configure(TaskState.backlog.rawValue, isActive: false)
        self.backlogLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeTaskState(_:))))
        self.backlogLbl.isUserInteractionEnabled = true
        self.inProgressLbl.configure(TaskState.inProgress.rawValue, isActive: false)
        self.inProgressLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeTaskState(_:))))
        self.inProgressLbl.isUserInteractionEnabled = true
        self.toFixLbl.configure(TaskState.toFix.rawValue, isActive: false)
        self.toFixLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeTaskState(_:))))
        self.toFixLbl.isUserInteractionEnabled = true
        self.doneLbl.configure(TaskState.done.rawValue, isActive: false)
        self.doneLbl.isUserInteractionEnabled = true
        self.doneLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeTaskState(_:))))
        self.reviewLbl.configure(TaskState.review.rawValue, isActive: false)
        self.reviewLbl.isUserInteractionEnabled = true
        self.reviewLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeTaskState(_:))))
        
    }
    
    @objc private func changeTaskState(_ sender: UITapGestureRecognizer) {
        self.prepareStateLabels()
        guard var model = self.viewModel?.taskModel.value else { return }
        if sender.view?.tag == 1 {
            self.viewModel?.updateTaskState(TaskState.backlog)
            model.state = TaskState.backlog.rawValue
        } else if sender.view?.tag == 2 {
            self.viewModel?.updateTaskState(TaskState.inProgress)
            model.state = TaskState.inProgress.rawValue
        } else if sender.view?.tag == 3 {
            self.viewModel?.updateTaskState(TaskState.toFix)
            model.state = TaskState.toFix.rawValue
        } else if sender.view?.tag == 4 {
            self.viewModel?.updateTaskState(TaskState.done)
            model.state = TaskState.done.rawValue
        } else if sender.view?.tag == 5 {
            self.viewModel?.updateTaskState(TaskState.review)
            model.state = TaskState.review.rawValue
        }
        //REFRESH
        self.view.layoutIfNeeded()
        self.viewModel?.taskViewState.value = (self.viewModel?.taskViewState.value)!
        self.prepareView(model)
    }
    
    private func prepareUserView() {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        let state = self.viewModel?.taskModel.value?.state
        self.userStateView.isHidden = false
        self.stateView.isUserInteractionEnabled = false
        if state == TaskState.done.rawValue {
            self.userStateView.isHidden = true
        } else if state == TaskState.toFix.rawValue {
            self.disableButton(resignButton)
            self.checkButton.setTitle("check".localize(), for: .normal)
        } else if state == TaskState.review.rawValue {
            self.disableButton(resignButton)
            self.disableButton(checkButton)
        } else if state == TaskState.inProgress.rawValue {
            self.enableButton(resignButton)
            self.enableButton(checkButton)
            self.checkButton.setTitle("check".localize(), for: .normal)
        } else if state == TaskState.backlog.rawValue {
            self.disableButton(resignButton)
            self.checkButton.setTitle("take_task".localize(), for: .normal)
        }
    }
    
    private func prepareAdminView() {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.stateView.isUserInteractionEnabled = true
        self.userStateView.isHidden = true
    }
    
    private func prepareViewerView() {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.stateView.isUserInteractionEnabled = false
        self.userStateView.isHidden = true
    }
    
    private func prepareUnassignedView() {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.stateView.isUserInteractionEnabled = false
        self.userStateView.isHidden = false
        self.disableButton(resignButton)
        self.checkButton.setTitle("take_task".localize(), for: .normal)
    }
}
