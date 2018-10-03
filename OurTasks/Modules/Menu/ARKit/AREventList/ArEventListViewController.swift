//
//  ArEventListViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 25/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit
import RxDataSources
import Firebase
import RxSwift

class ArEventListViewController: UITableViewController {
    
    enum Constants {
        struct CellIdentifiers {
            static let groupEvent = "groupEvent"
            static let noResult = "noResultCell"
        }
        
        struct NibNames {
            
        }
    }
    
    var viewModel: AREventListViewModel!
    private let firebaseManager: FirebaseManager = FirebaseManager()
    private var disposeBag: DisposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<AREventListSection>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = RxTableViewSectionedReloadDataSource<AREventListSection>(configureCell: { dataSource, tableView, indexPath, item in
            switch dataSource[indexPath] {
            case .presentEvents(let model):
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.groupEvent, for: indexPath) as! GroupEventCell
                cell.configure(model)
                return cell
                
            case .futureEvents(let model):
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.groupEvent, for: indexPath) as! GroupEventCell
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
        self.disposeBag = DisposeBag()
        self.navigationController?.isNavigationBarHidden = false
        self.tableView.dataSource = nil
        self.tableView.tableHeaderView = UIView()
        self.tableView.tableFooterView = UIView()
        
        self.viewModel.getEvents()
        
        self.viewModel.sectionsBehaviourSubject.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        self.tableView.rx.itemSelected
            .subscribe(onNext: {
                switch self.dataSource[$0] {
                case .futureEvents(let model), .presentEvents(let model):
                    let eventVC = StoryboardManager.addTaskViewController(self.viewModel.groupID, model.id, state: .add, position: self.viewModel.position, scale: self.viewModel.scale, taskModel: nil)
                    self.navigationController?.pushViewController(eventVC, animated: true)
                default:
                    break
                }
                
            })
            .disposed(by: self.disposeBag)
        
        self.prepare()
        self.viewModel.prepareEventsAndTasks()
    }
    
    private func prepare() {
        self.prepareNavigation()
    }
}
// MARK: Prepare
extension ArEventListViewController {
    private func prepareNavigation() {
        let groupColor = self.viewModel.groupModel.color.hexStringToUIColor()
        self.navigationItem.title = self.viewModel.groupModel.name.capitalized
        self.navigationController?.navigationBar.backgroundColor = groupColor.withAlphaComponent(0.2)
        let admins = self.viewModel.groupModel.admins
        if !admins.contains(self.firebaseManager.getCurrentUserUid()) {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
}
//MARK: TableView
extension ArEventListViewController {
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36.0
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
