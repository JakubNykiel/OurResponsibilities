//
//  AddGroupViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 04/11/2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import UIKit
import Firebase
import RxSwift

class AddGroupViewController: UITableViewController {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var addToGroupLbl: UILabel!
    @IBOutlet weak var addToGroupTF: UITextField!
    @IBOutlet weak var addToGroupBtn: UIButton!
    @IBOutlet weak var addToGroupDesc: UILabel!
    
    @IBOutlet weak var groupColorLbl: UILabel!
    @IBOutlet weak var groupColorCollection: UICollectionView!
    
    @IBOutlet weak var addBtn: UIButton!
    
    
    private let viewModel: AddGroupViewModel = AddGroupViewModel()
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareTexts()
        groupColorCollection.delegate = self
        groupColorCollection.dataSource = self
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addBtn.isEnabled = false
        self.hideKeyboardWhenTappedAround()
        self.configureTextFields()
        
        self.validation()
        
        self.viewModel.groupAdded.asObservable()
            .subscribe(onNext: {
                if $0 {
                    self.navigationController?.popViewController(animated: true)
                }
            }).disposed(by: self.disposeBag)
    }
    
    private func configureTextFields() {
        self.nameTF.setBottomBorder()
        self.addToGroupTF.setBottomBorder()
    }
    
    private func prepareGroupModel() {
        let currentUserUid = self.viewModel.getCurrentUserUid()
        let groupName = self.nameTF.text ?? ""
        let colorString: String = self.viewModel.prepareColorForGroup(self.groupColorCollection.indexPathsForVisibleItems.first?.row ?? 0)
        self.viewModel.users[currentUserUid] = 0
        self.viewModel.groupModel = GroupModel(name: groupName, createDate: self.viewModel.getTodayDate(), color: colorString, users: self.viewModel.users, events: nil, admins: [currentUserUid:0])
    }
    
    @IBAction func addToGroupAction(_ sender: Any) {
        self.viewModel.addUserUid(email: self.addToGroupTF.text!)
    }
    
    @IBAction func nextColor(_ sender: Any) {
        guard let indexPath = self.groupColorCollection.indexPathsForVisibleItems.first else { return }
        let nextIndexPath = IndexPath(item: indexPath.item + 1, section: indexPath.section)
        if nextIndexPath.row < self.viewModel.colors.count {
            self.groupColorCollection.scrollToItem(at: nextIndexPath, at: .left, animated: true)
        }
    }
    @IBAction func prevColor(_ sender: Any) {
        guard let indexPath = self.groupColorCollection.indexPathsForVisibleItems.first else { return }
        let nextIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
        if nextIndexPath.row >= 0 {
            self.groupColorCollection.scrollToItem(at: nextIndexPath, at: .right, animated: true)
        }
    }
    
    @IBAction func addGroup(_ sender: Any) {
        self.prepareGroupModel()
        self.viewModel.addGroupToDatabase()
    }
    
}
extension AddGroupViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "groupColor", for: indexPath) as UICollectionViewCell
        cell.layer.cornerRadius = 5.0
        cell.backgroundColor = self.viewModel.colors[indexPath.row]
        return cell
    }

}
//MARK: Prepare
extension AddGroupViewController {
    private func validation() {
        let nameValid = nameTF.rx.text.orEmpty.map{ $0.count > 0 }.share(replay: 1)
        
        self.addBtn.setTitleColor(AppColor.gray, for: .disabled)

        nameValid.asObservable()
            .bind(to: self.addBtn.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
//MARK: Localize
extension AddGroupViewController {
    private func prepareTexts() {
        self.navigationItem.title = "add_group".localize()
        self.nameTF.placeholder = "group_name".localize()
        self.groupColorLbl.text = "group_color".localize()
        self.addBtn.setTitle("add_group".localize(), for: .normal)
    }
}
