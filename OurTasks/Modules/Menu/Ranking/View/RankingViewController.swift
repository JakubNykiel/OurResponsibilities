//
//  RankingViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 11/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase
import RxSwift
import RxDataSources

class RankingViewController: UITableViewController {

    @IBOutlet weak var rankingSegmented: UISegmentedControl!
    
    var viewModel: RankingViewModel?
    private let firebaseManager: FirebaseManager = FirebaseManager()
    private var dataSource = RxTableViewSectionedReloadDataSource<RankingSection>(configureCell: { dataSource, tableView, indexPath, item in
        switch dataSource[indexPath] {
        case .group(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: "rankingCell", for: indexPath) as! RankingCell
            cell.positionLbl.text = String((indexPath.row) + 1)
            cell.configureGroup(model)
            return cell
        case .event(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: "rankingCell", for: indexPath) as! RankingCell
            cell.positionLbl.text = String((indexPath.row) + 1)
            cell.configureEvent(model)
            return cell
        case .noResult(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: "noResultCell", for: indexPath) as! NoResultCell
            cell.descLbl.text = model.description
            return cell
        }
    })
    
    private var disposeBag: DisposeBag!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareOnLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.prepareOnAppear()
    }
    
    @IBAction func changeRanking(_ sender: Any) {
        self.viewModel?.selectedSegment.value = self.rankingSegmented.selectedSegmentIndex
    }
}
extension RankingViewController {
    func prepareOnLoad() {
        self.viewModel?.prepareData()
    }
    
    func prepareOnAppear() {
        self.disposeBag = DisposeBag()
        self.tableView.dataSource = nil
        
        self.viewModel?.sectionsBehaviourSubject.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        
    }
}
//MARK: Tableview
extension RankingViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard section < self.viewModel?.sections.count ?? 0 else { return UIView() }
        let sectionData = dataSource[section]
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: 40.0))
        let label = UILabel(frame: CGRect(x: 20.0, y: 18.0, width: tableView.frame.size.width, height: 24.0))
        label.text = sectionData.title
        
        label.textColor = AppColor.applePurple
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        view.addSubview(label)
        
        view.addConstraint(NSLayoutConstraint.init(item: label, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 21.0))
        view.addConstraint(NSLayoutConstraint.init(item: label, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 21.0))
        
        return view
    }
}
