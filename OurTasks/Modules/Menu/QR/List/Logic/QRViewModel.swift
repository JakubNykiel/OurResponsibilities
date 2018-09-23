//
//  QRViewModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 22/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase
import RxSwift

class QRViewModel {
    
    private let firebaseManager: FirebaseManager = FirebaseManager()
    private let disposeBag = DisposeBag()
    
    var qrCodes: [String:QRCodeModel] = [:]
    var sections: [QRSection] = []
    var groupID: String
    var groupModel: GroupModel?
    
    var qrCodesBehaviorSubject: BehaviorSubject<[String:QRCodeModel]> = BehaviorSubject(value: [:])
    var sectionsBehaviourSubject: BehaviorSubject<[QRSection]> = BehaviorSubject(value: [])
    
    init(groupID: String, groupModel: GroupModel) {
        self.groupID = groupID
        self.groupModel = groupModel
        
        self.qrCodesBehaviorSubject
            .flatMap({ (codes) -> Observable<[QRCellModel]> in
                let ret: [QRCellModel] = codes.compactMap({
                    return QRCellModel(id: $0.key, model: $0.value)
                })
                return Observable.of(ret)
            })
            .subscribe(onNext: {
                self.sections = [QRSection.section(items: $0.compactMap({QRItemType.code($0)}))]
                self.sectionsBehaviourSubject.onNext(self.sections)
            }).disposed(by: self.disposeBag)
    }
    
    func fetchCodes() {
        
    }
}
