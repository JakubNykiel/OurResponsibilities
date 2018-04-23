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
import RxCocoa
import RxDataSources

class GroupListViewController: UITableViewController {

    @IBOutlet weak var arButton: UIBarButtonItem!
    
    var viewModel: GroupListViewModel!
    private let firebaseManager: FirebaseManager = FirebaseManager()
    private var dataSource: RxTableViewSectionedReloadDataSource<GroupSection>!
    
    private var disposeBag: DisposeBag!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delaysContentTouches = false
        self.tableView.dataSource = nil
        self.tableView.delegate = nil
        self.dataSource = RxTableViewSectionedReloadDataSource<GroupSection>(configureCell: { dataSource, tableView, indexPath, item in
            switch dataSource[indexPath] {
            case .userGroups(let model):
                let cell = tableView.dequeueReusableCell(withIdentifier: "userGroupCell", for: indexPath) as! GroupCell
                cell.configure(model)
                return cell
            case .userInvites(let model):
                let cell = tableView.dequeueReusableCell(withIdentifier: "userGroupInvitesCell", for: indexPath) as! GroupInviteCell
                cell.configure(model)
                return UITableViewCell()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.disposeBag = DisposeBag()
    
        self.viewModel.sectionsBehaviourSubject.asObservable()
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)

        self.prepare()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    private func prepare() {
        self.viewModel.userGroups.value = []
        self.viewModel.getUserGroups()
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
extension GroupListViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
}
