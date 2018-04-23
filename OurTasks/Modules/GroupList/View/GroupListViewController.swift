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

class GroupListViewController: UIViewController {

    @IBOutlet weak var groupSegmentedControl: UISegmentedControl!
    @IBOutlet weak var groupListTableView: UITableView!
    @IBOutlet weak var arButton: UIBarButtonItem!
    
    private let viewModel: GroupListViewModel = GroupListViewModel()
    private let firebaseManager: FirebaseManager = FirebaseManager()
    private var dataSource: RxTableViewSectionedReloadDataSource<GroupSection>!
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        //TODO: viewModel configure for rxdatasources
        self.dataSource = RxTableViewSectionedReloadDataSource<GroupSection>(configureCell: { dataSource, tableView, indexPath, item in
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.prepare()
        self.viewModel.groupsFetched.asObservable()
            .subscribe(onNext: { (_) in
                self.groupListTableView.reloadData()
            }).disposed(by: self.disposeBag)
        self.groupListTableView.reloadData()
    }
    
    private func prepare() {
        self.viewModel.userGroups.value = []
        self.viewModel.getUserGroups()
        self.groupListTableView.delegate = self
        self.groupListTableView.dataSource = self
    }
    
    @IBAction func addGroupView(_ sender: Any) {
        let addGroupVC = StoryboardManager.addGroupViewController()
//        self.present(addGroupVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(addGroupVC, animated: true)
    }
    
    @IBAction func presentAR(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "ARKit", bundle: nil)
        let groupListVC = storyBoard.instantiateViewController(withIdentifier: "arKitViewController")
        self.present(groupListVC, animated: true, completion: nil)
    }
    @IBAction func changeGroupList(_ sender: Any) {
        
    }
}
extension GroupListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.userGroups.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! GroupCell
        let model = self.viewModel.userGroups.value[indexPath.row]
        cell.configure(group: model)
        return cell
    }
    
    
}
