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

class GroupListViewController: UIViewController {

    @IBOutlet weak var groupSegmentedControl: UISegmentedControl!
    @IBOutlet weak var groupListTableView: UITableView!
    
    private let viewModel: GroupListViewModel = GroupListViewModel()
    private let firebaseManager: FirebaseManager = FirebaseManager()
    private let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.prepare()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel.groupsFetched.asObservable()
            .subscribe(onNext: { (_) in
                self.groupListTableView.reloadData()
            }).disposed(by: self.disposeBag)
    }
    
    private func prepare() {
        self.viewModel.getUserGroups()
        self.groupListTableView.delegate = self
        self.groupListTableView.dataSource = self
    }
    
    @IBAction func addGroupView(_ sender: Any) {
        let addGroupVC = StoryboardManager.addGroupViewController()
        self.present(addGroupVC, animated: true, completion: nil)
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
