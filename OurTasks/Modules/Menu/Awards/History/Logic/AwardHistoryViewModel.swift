//
//  AwardHistoryViewModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 20/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase
import RxSwift
import RxDataSources

class AwardHistoryViewModel {
    private let firebaseManager: FirebaseManager = FirebaseManager()
    private let disposeBag = DisposeBag()
    
    var sections: [AwardHistorySection] = []
    var awardModels: [String:[AwardModel]] = [:]
    var awardsBehaviorSubject: BehaviorSubject<[String:[AwardModel]]> = BehaviorSubject(value: [:])
    var sectionsBehaviourSubject: BehaviorSubject<[AwardHistorySection]> = BehaviorSubject(value: [])
    
    init() {
        self.awardsBehaviorSubject
            .flatMap({ (awards) -> Observable<[AwardHistoryCellModel]> in
                var ret: [AwardHistoryCellModel] = []
                let keys = awards.keys
                for key in keys {
                    let values = awards[key] ?? []
                    ret = ret + values.compactMap({ award in
                        return AwardHistoryCellModel(date: key, model: award)
                    })
                }
                return Observable.of(ret)
            })
            .subscribe(onNext: {
                self.sections = [AwardHistorySection.section(items: $0.compactMap({AwardHistoryItemType.award($0)}))]
                self.sectionsBehaviourSubject.onNext(self.sections)
            }).disposed(by: self.disposeBag)
    }
    
    func fetchAwards() {
        let currentUserUID = self.firebaseManager.getCurrentUserUid()
        let userRef = FirebaseReferences().userRef.document(currentUserUID)
        
        userRef.getDocument(completion: { (document, error) in
            if let document = document {
                guard let userData = document.data() else { return }
                guard let awards = document["awards"] as? [String:[String]] else { return }
                self.toAwardModel(awards: awards)
            } else {
                print("User not exist")
            }
        })
    }
    
    func toAwardModel(awards: [String:[String]]) {
        if awards.count == 0 {
            
        } else {
            _ = awards.compactMap({
                let dateStringKey = $0.key
                let dateValues = $0.value
                var dateAwardModels: [AwardModel] = []
                _ = dateValues.compactMap({ award in
                    let awardRef = FirebaseReferences().awardRef.document(award)
                    awardRef.getDocument(completion: { (document, error) in
                        if let document = document {
                            guard let awardData = document.data() else { return }
                            let awardModel = try! FirebaseDecoder().decode(AwardModel.self, from: awardData)
                            dateAwardModels.append(awardModel)
                            if dateValues.count == dateAwardModels.count {
                                self.awardModels[dateStringKey] = dateAwardModels
                                if awards.count == self.awardModels.count {
                                    self.awardsBehaviorSubject.onNext(self.awardModels)
                                }
                            }
                        } else {
                            print("Award not exist")
                        }
                    })
                })
            })
        }
    }
}
