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
import RxCocoa

class EventViewController: UITableViewController {

    enum Constants {
        struct CellIdentifiers {
            static let eventTask = ""
        }
        
        struct NibNames {
            
        }
    }
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventPoints: UILabel!
    
    var viewModel: EventViewModel!
    private let firebaseManager: FirebaseManager = FirebaseManager()
    private var disposeBag: DisposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<EventSection>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareOnLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.prepareOnAppear()
    }
    
    @IBAction func toAddTask(_ sender: Any) {
        let addTaskVC = StoryboardManager.addTaskViewController(self.viewModel.eventID)
        self.navigationController?.pushViewController(addTaskVC, animated: true)
    }
}
//MARK: Preapre
extension EventViewController {
    func prepareOnLoad() {
        
    }
    
    func prepareOnAppear() {
        self.bindEventData()
    }
    
    private func bindEventData() {
        self.viewModel.eventName.asObservable()
            .bind(to: self.eventName.rx.text)
            .disposed(by: self.disposeBag)
        
        self.viewModel.eventDate.asObservable()
            .bind(to: self.eventDate.rx.text)
            .disposed(by: self.disposeBag)
        
        self.viewModel.eventPoints.asObservable()
            .bind(to: self.eventPoints.rx.text)
            .disposed(by: self.disposeBag)
    }
}
