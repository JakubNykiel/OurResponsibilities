//
//  GroupViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 01.05.2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit
import RxDataSources
import Firebase
import RxSwift

class GroupViewController: UITableViewController {
    
    enum Constants {
        struct CellIdentifiers {
            static let groupEvent = "groupEvent"
            static let noResult = "noResultCell"
        }
        
        struct NibNames {
            
        }
    }
    
    var viewModel: GroupViewModel!
    private let firebaseManager: FirebaseManager = FirebaseManager()
    private var disposeBag: DisposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<GroupSection>!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = RxTableViewSectionedReloadDataSource<GroupSection>(configureCell: { dataSource, tableView, indexPath, item in
            switch dataSource[indexPath] {
            case .pastEvents(let model):
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.groupEvent, for: indexPath) as! GroupEventCell
                cell.configure(model)
                return cell
                
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
        
        self.tableView.dataSource = nil
        self.tableView.tableFooterView = UIView()
        
        self.viewModel.sectionsBehaviourSubject.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
       
        self.tableView.rx.itemSelected
            .subscribe(onNext: {
                //ADD Task option in FUTURE
                switch self.dataSource[$0] {
                case .futureEvents(let model), .presentEvents(let model), .pastEvents(let model):
                    let eventVC = StoryboardManager.eventViewController(model.eventModel, eventID: model.id)
                    self.navigationController?.pushViewController(eventVC, animated: true)
                default:
                    break
                }
               
            })
            .disposed(by: self.disposeBag)
        
        self.prepare()
        self.viewModel.prepareEventsAndTasks()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
    
    @IBAction func toAddEvent(_ sender: Any) {
        let addEventVC = StoryboardManager.addEventViewController(self.viewModel.groupID)
        self.navigationController?.pushViewController(addEventVC, animated: true)
    }
    
    private func prepare() {
        self.prepareNavigation()
    }

}
// MARK: Prepare
extension GroupViewController {
    private func prepareNavigation() {
        let groupColor = self.viewModel.groupModel.color.hexStringToUIColor()
        self.navigationItem.title = self.viewModel.groupModel.name.capitalized
        self.navigationController?.navigationBar.backgroundColor = groupColor.withAlphaComponent(0.2)
    }
}
// MARK: TableView
extension GroupViewController {
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
     
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
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
