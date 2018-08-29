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
    
    @IBOutlet weak var stateStackView: UIStackView!
    @IBOutlet weak var backlogLbl: TaskStateLabel!
    @IBOutlet weak var inProgressLbl: TaskStateLabel!
    @IBOutlet weak var toFixLbl: TaskStateLabel!
    @IBOutlet weak var doneLbl: TaskStateLabel!
    
    
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
        guard let taskID = self.viewModel?.taskID else { return }
        guard let taskModel = self.viewModel?.taskModel else { return }
        let addTaskVC = StoryboardManager.addTaskViewController("", state: .update, taskModel: [ taskID : taskModel])
        addTaskVC.modalPresentationStyle = .overCurrentContext
        self.navigationController?.pushViewController(addTaskVC, animated: true)
    }
}
//MARK: Prepare
extension TaskViewController {
    func prepareOnLoad() {
        self.navigationItem.title = "details".localize()
    }
    
    func prepareOnAppear() {
        self.bindInformation()
        self.prepareStateLabels()
    }
    
    private func bindInformation() {
        self.viewModel?.taskName.asObservable()
            .bind(to: self.taskName.rx.text)
            .disposed(by: self.disposeBag)
        
        self.viewModel?.taskOwner.asObservable()
            .bind(to: self.taskOwner.rx.text)
            .disposed(by: self.disposeBag)
        
        self.viewModel?.taskDate.asObservable()
            .bind(to: self.taskEndDateLbl.rx.text)
            .disposed(by: self.disposeBag)
    }
    
    private func prepareStateLabels() {
        self.backlogLbl.configure(TaskState.backlog.rawValue, isActive: false)
        self.backlogLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeTaskState(_:))))
        self.backlogLbl.isUserInteractionEnabled = true
        self.inProgressLbl.configure(TaskState.inProgress.rawValue)
        self.inProgressLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeTaskState(_:))))
        self.inProgressLbl.isUserInteractionEnabled = true
        self.toFixLbl.configure(TaskState.toFix.rawValue)
        self.toFixLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeTaskState(_:))))
        self.toFixLbl.isUserInteractionEnabled = true
        self.doneLbl.configure(TaskState.done.rawValue)
        self.doneLbl.isUserInteractionEnabled = true
        self.doneLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeTaskState(_:))))
        
    }
    
    @objc private func changeTaskState(_ sender: UITapGestureRecognizer) {
        if sender.view?.tag == 1 {
            self.viewModel?.updateTaskState(TaskState.backlog)
        } else if sender.view?.tag == 2 {
            self.viewModel?.updateTaskState(TaskState.inProgress)
        } else if sender.view?.tag == 3 {
            self.viewModel?.updateTaskState(TaskState.toFix)
        } else if sender.view?.tag == 4 {
            self.viewModel?.updateTaskState(TaskState.done)
        }
    }
}
