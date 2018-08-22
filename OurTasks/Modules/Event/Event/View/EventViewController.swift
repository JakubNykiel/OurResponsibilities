//
//  EventViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 19/08/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit
import RxDataSources
import Firebase
import RxSwift

class EventViewController: UITableViewController {

    enum Constants {
        struct CellIdentifiers {
            static let eventTask = ""
        }
        
        struct NibNames {
            
        }
    }
    
    var viewModel: EventViewModel!
    private let firebaseManager: FirebaseManager = FirebaseManager()
    private var disposeBag: DisposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<EventSection>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func toAddTask(_ sender: Any) {
        let addTaskVC = StoryboardManager.addTaskViewController(self.viewModel.eventID)
        self.navigationController?.pushViewController(addTaskVC, animated: true)
    }
}
