//
//  AwardsViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 17/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit
import RxDataSources
import Firebase
import RxSwift
import RxCocoa

class AwardsViewController: UITableViewController {
    
    enum Constants {
        struct CellIdentifiers {
            static let award = "awardCell"
        }
        
        struct NibNames {
        }
    }
    
    var viewModel: AwardsViewModel?
    private var firebaseManager = FirebaseManager()
    private var disposeBag: DisposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<AwardSection>!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let admins = self.viewModel?.groupModel?.admins else { return }
        
        if !admins.contains(self.firebaseManager.getCurrentUserUid()) {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        self.dataSource = RxTableViewSectionedReloadDataSource<AwardSection>(configureCell: { dataSource, tableView, indexPath, item in
            switch dataSource[indexPath] {
            case .award(let model):
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.award, for: indexPath) as! AwardCell
                cell.enable(on: false)
                return cell
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.prepareOnAppear()
        
        
    }
    @IBAction func addAward(_ sender: Any) {
        guard let id = self.viewModel?.groupID else { return }
        guard let model = self.viewModel?.groupModel else { return }
        let addAwardVC = StoryboardManager.addAwardViewController(groupID: id, groupModel: model)
        self.navigationController?.pushViewController(addAwardVC, animated: true)
    }
}
//MARK: Prepare
extension AwardsViewController {
    func prepareOnAppear() {
        self.disposeBag = DisposeBag()
        self.tableView.dataSource = nil
        
        self.viewModel?.sectionsBehaviourSubject.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
}
//MARK: TableView
extension AwardsViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96.0
    }
}
extension UITableViewCell {
    func enable(on: Bool) {
        self.isUserInteractionEnabled = on
        for view in contentView.subviews {
            self.isUserInteractionEnabled = on
            view.alpha = on ? 1 : 0.5
        }
    }
}
