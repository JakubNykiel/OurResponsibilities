//
//  QRViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 22/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit
import RxDataSources
import Firebase
import RxSwift
import RxCocoa

class QRViewController: UITableViewController {
    
    enum Constants {
        struct CellIdentifiers {
            static let code = "qrCodeCell"
        }
        
        struct NibNames {
        }
    }
    
    var viewModel: QRViewModel?
    private var firebaseManager = FirebaseManager()
    private var disposeBag: DisposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<QRSection>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = RxTableViewSectionedReloadDataSource<QRSection>(configureCell: { dataSource, tableView, indexPath, item in
            switch dataSource[indexPath] {
            case .code(let model):
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.code, for: indexPath) as! QRCodeCell
                cell.confifure(model)
                return cell
            }
        })

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.prepareOnAppear()
    }
    
    @IBAction func addQR(_ sender: Any) {
        guard let id = self.viewModel?.groupID else { return }
        guard let model = self.viewModel?.groupModel else { return }
        let addQRVC = StoryboardManager.addQRViewController(groupID: id, groupModel: model)
        self.navigationController?.pushViewController(addQRVC, animated: true)
    }
}
// MARK: Prepare
extension QRViewController {
    func prepareOnAppear() {
        self.disposeBag = DisposeBag()
        self.tableView.dataSource = nil
        
        self.viewModel?.sectionsBehaviourSubject.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        self.viewModel?.fetchCodes()
    }
}
//MARK: TableView
extension QRViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
