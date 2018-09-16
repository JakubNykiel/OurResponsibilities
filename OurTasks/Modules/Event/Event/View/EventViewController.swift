//
//  EventViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 19/08/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit
import RxDataSources
import Firebase
import RxSwift
import RxCocoa

class EventViewController: UITableViewController {
    
    enum Constants {
        struct CellIdentifiers {
            static let eventTask = "taskCell"
            static let noResult = "noResultCell"
        }
        
        struct NibNames {
            static let eventTask = "TaskCell"
        }
    }
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventPoints: UILabel!
    
    var viewModel: EventViewModel!
    private let firebaseManager: FirebaseManager = FirebaseManager()
    private var disposeBag: DisposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<EventSection>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareOnLoad()
        
        self.dataSource = RxTableViewSectionedReloadDataSource<EventSection>(configureCell: { dataSource, tableView, indexPath, item in
            switch dataSource[indexPath] {
            case .unassignedTasks(let model):
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.eventTask, for: indexPath) as! TaskCell
                cell.configure(model)
                return cell
            case .allTasks(let model):
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.eventTask, for: indexPath) as! TaskCell
                cell.configure(model)
                return cell
            case .doneTasks(let model):
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.eventTask, for: indexPath) as! TaskCell
                cell.configure(model)
                return cell
            case .myTasks(let model):
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.eventTask, for: indexPath) as! TaskCell
                cell.configure(model)
                return cell
            case .noResult(let model):
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.noResult, for: indexPath) as! NoResultCell
                cell.descLbl.text = model.description
                return cell
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.prepareOnAppear()
    }
    
    @IBAction func toEditEvent(_ sender: Any) {
        guard let eventID = self.viewModel?.eventID else { return }
        guard let eventModel = self.viewModel?.eventModel else { return }
        let addEventVC = StoryboardManager.addEventViewController("", state: .update, eventModel: [eventID:eventModel])
        self.navigationController?.pushViewController(addEventVC, animated: true)
    }
    
    @IBAction func toAddTask(_ sender: Any) {
        guard let eventModel = self.viewModel?.eventModel else { return }
        let addTaskVC = StoryboardManager.addTaskViewController(eventModel.groupID, self.viewModel.eventID, state: .add, taskModel: nil)
        self.navigationController?.pushViewController(addTaskVC, animated: true)
    }
}
//MARK: Preapre
extension EventViewController {
    func prepareOnLoad() {
        self.registerNibs()
        self.addBtn.setTitle("add_task".localize(), for: .normal)
    }
    
    func prepareOnAppear() {
        self.disposeBag = DisposeBag()
        self.tableView.dataSource = nil
        self.viewModel.getEventTasks()
        self.viewModel.bindGeneralInformation()
        self.bindEventData()
        
        self.tableView.rx.itemSelected
            .subscribe(onNext: {
                switch self.dataSource[$0] {
                case .doneTasks(let model):
                    let taskVC = StoryboardManager.taskViewController(model.id)
                    self.navigationController?.pushViewController(taskVC, animated: true)
                case .allTasks(let model):
                    let taskVC = StoryboardManager.taskViewController(model.id)
                    self.navigationController?.pushViewController(taskVC, animated: true)
                case .unassignedTasks(let model):
                    let taskVC = StoryboardManager.taskViewController(model.id)
                    self.navigationController?.pushViewController(taskVC, animated: true)
                case .myTasks(let model):
                    let taskVC = StoryboardManager.taskViewController(model.id)
                    self.navigationController?.pushViewController(taskVC, animated: true)
                case .noResult(_):
                    break
                }
            }).disposed(by: self.disposeBag)
        
        guard let admins = self.viewModel.eventModel.admins else { return }
        
        if !admins.contains(self.firebaseManager.getCurrentUserUid()) {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    private func registerNibs() {
        self.tableView.register(UINib.init(nibName: Constants.NibNames.eventTask, bundle: nil), forCellReuseIdentifier: Constants.CellIdentifiers.eventTask)
    }
    
    private func bindEventData() {
        self.viewModel.eventName.asObservable()
            .bind(to: self.eventName.rx.text)
            .disposed(by: self.disposeBag)
        
        self.viewModel.eventDate.asObservable()
            .bind(to: self.eventDate.rx.text)
            .disposed(by: self.disposeBag)
        
        self.viewModel.eventPoints.asObservable()
            .bind(to: self.eventPoints.rx.text)
            .disposed(by: self.disposeBag)
        
        self.viewModel.sectionsBehaviourSubject.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
}
//MARK: TableView
extension EventViewController {
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: 1.0))
        let backgroundView = UIView(frame: CGRect(x: 20.0, y: 0.0, width: view.bounds.width - 40.0, height: 1.0))
        backgroundView.backgroundColor = AppColor.gray.withAlphaComponent(0.5)
        view.addSubview(backgroundView)
        return view
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section < dataSource.sectionModels.count else { return UIView() }
        let section = dataSource[section]
        //        guard section.items.count > 0 else { return UIView() }
        
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: 40.0))
        let label = UILabel(frame: CGRect(x: 21.0, y: 18.0, width: tableView.frame.size.width, height: 24.0))
        label.text = section.title + ":"
        label.textColor = AppColor.applePurple
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        view.addSubview(label)
        view.addConstraint(NSLayoutConstraint.init(item: label, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 21.0))
        view.addConstraint(NSLayoutConstraint.init(item: label, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 21.0))
        
        return view
    }
}
