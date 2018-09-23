//
//  AddQRViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 22/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit

class AddQRViewController: UITableViewController, UserSelectedDelegate{
    
    @IBOutlet weak var userLbl: UILabel!
    @IBOutlet weak var userTF: UITextField!
    @IBOutlet weak var QRSwitch: UISwitch!
    
    var viewModel: AddQRViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareOnLoad()
    }
    
    @IBAction func qrSwitchAction(_ sender: Any) {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    @IBAction func generateQR(_ sender: Any) {
        let model = QRCodeModel(main: self.QRSwitch.isOn, user: self.userTF.text ?? "", groupID: self.viewModel?.groupID ?? "")
        self.viewModel?.qrModel = model
        self.viewModel?.generateQR()
    }
}
//MARK Prepare
extension AddQRViewController {
    
    func prepareOnLoad() {
        self.userTF.tag = 4
        self.userTF.setBottomBorder()
        self.userTF.delegate = self
    }
    
    func prepareTexts() {
        self.navigationController?.title = "Dodaj QR"
        self.userLbl.text = "task_assigned".localize()
        self.userTF.placeholder = "choose_user".localize()
    }
}
//MARK TextField
extension AddQRViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
}
//MARK: TableView
extension AddQRViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.QRSwitch.isOn && indexPath.row == 1 {
            return 0
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let modalVC = StoryboardManager.usersViewController(groupID: self.viewModel?.groupID ?? "")
            modalVC.delegate = self
            self.present(modalVC, animated: true, completion: nil)
        }
    }
}
// MARK: Delegate
extension AddQRViewController {
    func userSelected(user: [String : UserModel]) {
        self.viewModel?.user = user
        self.userTF.text = user.first?.value.username
    }
}
