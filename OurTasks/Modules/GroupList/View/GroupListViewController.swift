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

    @IBOutlet weak var arButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: GroupListViewModel!
    private let firebaseManager: FirebaseManager = FirebaseManager()
    private var dataSource = RxTableViewSectionedReloadDataSource<GroupListSection>(configureCell: { dataSource, tableView, indexPath, item in
        switch dataSource[indexPath] {
        case .userGroups(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: "userGroupCell", for: indexPath) as! GroupCell
            cell.configure(model)
            return cell
        case .userInvites(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: "userGroupInvitesCell", for: indexPath) as! GroupInviteCell
            cell.configure(model)
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

        self.prepare()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    private func prepare() {
        self.viewModel.userGroups.value = []
        self.viewModel.getUserGroups()
        self.viewModel.getInvitesGroups()
    }
    
    @IBAction func addGroupView(_ sender: Any) {
        let addGroupVC = StoryboardManager.addGroupViewController()
        self.navigationController?.pushViewController(addGroupVC, animated: true)
    }
    
    @IBAction func presentAR(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "ARKit", bundle: nil)
        let groupListVC = storyBoard.instantiateViewController(withIdentifier: "arKitViewController")
        self.present(groupListVC, animated: true, completion: nil)
    }
    
}
extension GroupListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard section < dataSource.sectionModels.count else { return UIView() }
        let section = dataSource[section]
//        guard section.items.count > 0 else { return UIView() }
        
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: 50.0))
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
//MARK: Localize
extension GroupListViewController {
    private func prepareTexts() {
        self.navigationItem.title = "groups".localize()
    }
}
