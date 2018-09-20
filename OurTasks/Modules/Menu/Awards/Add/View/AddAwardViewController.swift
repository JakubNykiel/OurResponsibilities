//
//  AddAwardViewController.swift
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

class AddAwardViewController: UITableViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var pointsLbl: UILabel!
    @IBOutlet weak var pointsTF: UITextField!
    
    @IBOutlet weak var availableLbl: UILabel!
    @IBOutlet weak var availableTF: UITextField!
    
    @IBOutlet weak var addBtn: UIButton!
    
    var viewModel: AddAwardViewModel?
    private let disposeBag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareTexts()
        self.prepareTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.prepareOnAppear()
    }
    
    @IBAction func addAction(_ sender: Any) {
        self.viewModel?.awardModel = AwardModel(name: self.nameTF.text ?? "", group: self.viewModel?.groupID ?? "", cost: Int(self.pointsTF.text ?? "0")!, available: Int(self.availableTF.text ?? "0")!)
        if self.viewModel?.awardModelToUpdate == nil {
            self.viewModel?.addTaskToDatabase()
        } else {
            self.viewModel?.updateAward()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
}
// MARK: Prepare
extension AddAwardViewController {
    
    func prepareOnAppear() {
       self.viewModel?.awardModelToUpdate.asObservable()
        .subscribe(onNext: { (awardModel) in
            guard let awardModel = awardModel?.values.first else { return }
            self.nameTF.text = awardModel.name
            self.pointsTF.text = String(awardModel.cost)
            self.availableTF.text = String(awardModel.available)
        }).disposed(by: self.disposeBag)
    }
    
    func prepareTexts() {
        self.navigationItem.title = "award".localize()
        self.nameLbl.text = "name".localize()
        self.pointsLbl.text = "point_price".localize()
        self.availableLbl.text = "available".localize()
    }
    
    func prepareTextFields() {
        self.nameTF.setBottomBorder()
        self.pointsTF.setBottomBorder()
        self.availableTF.setBottomBorder()
    }
}
