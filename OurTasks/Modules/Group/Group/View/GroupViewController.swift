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
import RxCocoa

class GroupViewController: UITableViewController {
    
    enum Constants {
        struct CellIdentifiers {
            static let presentEvent = "groupPresentEvent"
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
        self.tableView.dataSource = nil
        self.tableView.delaysContentTouches = true
        self.dataSource = RxTableViewSectionedReloadDataSource<GroupSection>(configureCell: { dataSource, tableView, indexPath, item in
            switch dataSource[indexPath] {
            case .presentEvents(let model):
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.presentEvent, for: indexPath) as! GroupEventCell
                cell.configure(model)
                return cell
            }
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.sectionsBehaviourSubject.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
//        self.tableView.rx.itemSelected
//            .subscribe(onNext: {
//                switch self.dataSource[$0]{
//
//            })
//            .disposed(by: self.disposeBag)
        
        self.prepare()
        self.viewModel.fetchEventsAndTasks()
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
