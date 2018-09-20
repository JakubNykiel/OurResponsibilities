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

class AwardsViewController: UITableViewController, AwardProtocol {
    
    enum Constants {
        struct CellIdentifiers {
            static let award = "awardCell"
        }
        
        struct NibNames {
        }
    }
    
    @IBOutlet weak var pointsTitleLbl: UILabel!
    @IBOutlet weak var pointLbl: UILabel!
    @IBOutlet weak var historyAwardBtn: UIButton!
    
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
                cell.delegate = self
                cell.configure(model)
                if model.model.cost > (self.viewModel?.userModel?.points ?? 0) || model.model.available == 0 {
                    cell.enable(on: false)
                } else {
                    cell.enable(on: true)
                }
                return cell
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.prepareOnAppear()
        self.viewModel?.fetchData()
        
        self.viewModel?.userPoints.asObservable()
            .bind(to: self.pointLbl.rx.text)
            .disposed(by: self.disposeBag)
        
    }
    
    @IBAction func toHistoryExchangeAwards(_ sender: Any) {
        let awardHistoryVC = StoryboardManager.awardHistoryViewController()
        self.navigationController?.pushViewController(awardHistoryVC, animated: true)
    }
    
    
    @IBAction func addAward(_ sender: Any) {
        guard let id = self.viewModel?.groupID else { return }
        guard let model = self.viewModel?.groupModel else { return }
        let addAwardVC = StoryboardManager.addAwardViewController(groupID: id, groupModel: model, awardModel: nil)
        self.navigationController?.pushViewController(addAwardVC, animated: true)
    }
    
    //MARK Protocol
    func editTap(id: String, model: AwardModel) {
        guard let groupID = self.viewModel?.groupID else { return }
        guard let groupModel = self.viewModel?.groupModel else { return }
        let editVC = StoryboardManager.addAwardViewController(groupID: groupID, groupModel: groupModel, awardModel: [id:model])
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    func exchangeTap(id: String) {
        self.viewModel?.exchange(id: id)
    }
}
//MARK: Prepare
extension AwardsViewController {
    func prepareOnAppear() {
        self.prepareTexts()
        self.disposeBag = DisposeBag()
        self.tableView.dataSource = nil
        
        self.viewModel?.sectionsBehaviourSubject.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
    
    func prepareTexts() {
        self.pointsTitleLbl.text = "your_points".localize()
        self.historyAwardBtn.setTitle("history_award".localize(), for: .normal)
    }
}
//MARK: TableView
extension AwardsViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
}
