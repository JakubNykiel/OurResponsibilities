//
//  AwardHistoryViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 20/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit
import RxDataSources
import Firebase
import RxSwift
import RxCocoa

class AwardHistoryViewController: UITableViewController {

    enum Constants {
        struct CellIdentifiers {
            static let award = "awardHistoryCell"
        }
        
        struct NibNames {
        }
    }
    
    var viewModel: AwardHistoryViewModel?
    private var firebaseManager = FirebaseManager()
    private var disposeBag: DisposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<AwardHistorySection>!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareOnLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.prepareOnAppear()
    }
}
//MARK: Preapre
extension AwardHistoryViewController {
    
    func prepareOnLoad() {
        self.navigationItem.title = "history_award".localize()
        
        self.dataSource = RxTableViewSectionedReloadDataSource<AwardHistorySection>(configureCell: { dataSource, tableView, indexPath, item in
            switch dataSource[indexPath] {
            case .award(let model):
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.award, for: indexPath) as! AwardHistoryCell
                cell.configure(model)
                return cell
            }
        })
    }
    
    func prepareOnAppear() {
        
        self.disposeBag = DisposeBag()
        self.tableView.dataSource = nil
        
        self.viewModel?.sectionsBehaviourSubject.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        self.viewModel?.fetchAwards()
    }
}
//MARK: TableView
extension AwardHistoryViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
