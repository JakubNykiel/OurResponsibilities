//
//  UserViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 04/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit
import RxSwift

protocol UserSelectedDelegate {
    func userSelected(user: [String : UserModel])
}

class UserViewController: UITableViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var viewModel: UserViewModel?
    var delegate: UserSelectedDelegate?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareOnLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareOnApperar()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
}
// MARK: Prepare
extension UserViewController {
    func prepareOnApperar() {
        self.titleLabel.text = "choose_user".localize()
        
        self.viewModel?.eventID.asObservable()
            .subscribe(onNext: {
                self.viewModel?.getAllUsersFromGroup($0)
            }).disposed(by: self.disposeBag)
        
        self.viewModel?.dataBinded.asObservable()
            .subscribe(onNext: {
                if $0 {
                    self.tableView.reloadData()
                }
            }).disposed(by: self.disposeBag)
    }
    
    func prepareOnLoad() {
        
    }
}
// MARK: TableView
extension UserViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
        guard let userID = self.viewModel?.usersKey[indexPath.row] else { return UITableViewCell() }
        cell.name.text = self.viewModel?.users[userID]?.username
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.users.count ?? 0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let userKey = self.viewModel?.usersKey[indexPath.row] else { return }
        guard let userValue = self.viewModel?.users[userKey] else { return }
        self.delegate?.userSelected(user: [userKey : userValue])
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
