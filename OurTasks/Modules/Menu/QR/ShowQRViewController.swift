//
//  ShowQRViewController.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 23/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class ShowQRViewController: UIViewController {
    
    @IBOutlet weak var QRImgeView: UIImageView!
    @IBOutlet weak var removeBtn: UIButton!
    
    var viewModel: ShowQRViewModel?
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel?.qrImage.asObservable()
            .bind(to: self.QRImgeView.rx.image)
            .disposed(by: self.disposeBag)

    }

    @IBAction func removeQR(_ sender: Any) {
        self.viewModel?.removeQR()
    }
}
