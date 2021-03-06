//
//  GroupListViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 03/10/2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase
import RxSwift
import RxDataSources

class GroupListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: GroupListViewModel!
    private let firebaseManager: FirebaseManager = FirebaseManager()
    private var dataSource = RxTableViewSectionedReloadDataSource<GroupListSection>(configureCell: { dataSource, tableView, indexPath, item in
        switch dataSource[indexPath] {
        case .userGroups(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: "userGroupCell", for: indexPath) as! GroupCell
            cell.configure(model)
            return cell
        case .userTasks(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: "groupTaskCell", for: indexPath) as! GroupTaskCell
            cell.configure(model)
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
        self.prepareTexts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.disposeBag = DisposeBag()
        let dataSource = self.dataSource
    
        self.viewModel.sectionsBehaviourSubject.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        self.tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected
            .subscribe(onNext: {
                switch self.dataSource[$0]{
                case .userGroups(let model):
                    let menuVC = StoryboardManager.menuViewController(groupID: model.id, groupModel: model.groupModel)
                    self.present(menuVC, animated: true, completion: nil)
                    return
                case .userTasks(let model):
                    let taskVC = StoryboardManager.taskViewController(model.id)
                    self.navigationController?.pushViewController(taskVC, animated: true)
                default: return
                }
            })
            .disposed(by: self.disposeBag)

        self.prepare()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func prepare() {
        self.viewModel.userGroups = [:]
        self.viewModel.getUserGroups()
//        self.viewModel.getInvitesGroups()
    }
    
    @IBAction func addGroupView(_ sender: Any) {
        let addGroupVC = StoryboardManager.addGroupViewController()
        self.navigationController?.pushViewController(addGroupVC, animated: true)
    }
    
}
extension GroupListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: 1.0))
        let backgroundView = UIView(frame: CGRect(x: 20.0, y: 0.0, width: view.bounds.width - 40.0, height: 1.0))
        backgroundView.backgroundColor = AppColor.gray.withAlphaComponent(0.5)
        view.addSubview(backgroundView)
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard section < dataSource.sectionModels.count else { return UIView() }
        let section = dataSource[section]
        
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: 40.0))
        let label = UILabel(frame: CGRect(x: 20.0, y: 18.0, width: tableView.frame.size.width, height: 24.0))
        label.text = section.title + ":"
        label.textColor = AppColor.applePurple
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        view.addSubview(label)

        view.addConstraint(NSLayoutConstraint.init(item: label, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 21.0))
        view.addConstraint(NSLayoutConstraint.init(item: label, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 21.0))
        
        return view
    }
}
//MARK: Localize
extension GroupListViewController {
    private func prepareTexts() {
        self.navigationItem.title = "groups".localize()
    }
}
