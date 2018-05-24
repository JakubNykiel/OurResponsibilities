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

class AddGroupViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var groupColorLbl: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var groupColorsCollection: UICollectionView!
    private let viewModel: AddGroupViewModel = AddGroupViewModel()
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareTexts()
        groupColorsCollection.delegate = self
        groupColorsCollection.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideKeyboardWhenTappedAround()
        self.containerDependOnKeyboardBottomConstrain = bottomConstraint
        self.watchForKeyboard()
        self.configureTextFields()

        self.viewModel.groupAdded.asObservable()
            .subscribe(onNext: {
                if $0 {
                    self.navigationController?.popViewController(animated: true)
                }
            }).disposed(by: self.disposeBag)
    }
    
    private func configureTextFields() {
        self.groupNameTextField.setBottomBorder()
    }
    
    private func prepareGroupModel() {
        let currentUserUid = self.viewModel.getCurrentUserUid()
        let groupName = self.groupNameTextField.text ?? ""
        let colorString: String = self.viewModel.prepareColorForGroup(self.groupColorsCollection.indexPathsForVisibleItems.first?.row ?? 0)
        self.viewModel.groupModel = GroupModel(name: groupName, createDate: self.viewModel.getTodayDate(), color: colorString, users: nil, events: nil, admins: [currentUserUid:0], userInteraction: false)
    }
    
    @IBAction func nextColor(_ sender: Any) {
        guard let indexPath = self.groupColorsCollection.indexPathsForVisibleItems.first else { return }
        let nextIndexPath = IndexPath(item: indexPath.item + 1, section: indexPath.section)
        if nextIndexPath.row < self.viewModel.colors.count {
            self.groupColorsCollection.scrollToItem(at: nextIndexPath, at: .left, animated: true)
        }
    }
    @IBAction func prevColor(_ sender: Any) {
        guard let indexPath = self.groupColorsCollection.indexPathsForVisibleItems.first else { return }
        let nextIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
        if nextIndexPath.row >= 0 {
            self.groupColorsCollection.scrollToItem(at: nextIndexPath, at: .right, animated: true)
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
//MARK: Localize
extension AddGroupViewController {
    private func prepareTexts() {
        self.titleLabel.text = "addGroupTitle".localize()
        self.groupNameTextField.placeholder = "group_name".localize()
        self.groupColorLbl.text = "group_color".localize()
        self.addBtn.setTitle("add_group".localize(), for: .normal)
    }
}
