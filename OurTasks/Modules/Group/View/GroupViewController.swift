//
//  GroupViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 01.05.2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit
import RxDataSources

class GroupViewController: UIViewController {
    
    var viewModel: GroupViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.prepare()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
    
    @IBAction func toAddEvent(_ sender: Any) {
        let addEventVC = StoryboardManager.addEventViewController(self.viewModel.groupID)
        self.navigationController?.pushViewController(addEventVC, animated: true)
    }
    
    private func prepare() {
        self.prepareNavigation()
    }

}
// MARK: Prepare
extension GroupViewController {
    private func prepareNavigation() {
        let groupColor = self.viewModel.groupModel.color.hexStringToUIColor()
        self.navigationItem.title = self.viewModel.groupModel.name.capitalized
        self.navigationController?.navigationBar.backgroundColor = groupColor.withAlphaComponent(0.2)
    }
}
