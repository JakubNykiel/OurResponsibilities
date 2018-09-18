//
//  AwardsViewModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 17/09/2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase
import RxSwift

class AwardsViewModel {
    
    private let firebaseManager: FirebaseManager = FirebaseManager()
    private let disposeBag = DisposeBag()
    var awards: [String:AwardModel] = [:]
    var sections: [AwardSection] = []
    var groupID: String
    var groupModel: GroupModel?
    
    var awardsBehaviorSubject: BehaviorSubject<[String:AwardModel]> = BehaviorSubject(value: [:])
    var sectionsBehaviourSubject: BehaviorSubject<[AwardSection]> = BehaviorSubject(value: [])
    
    init(groupID: String, groupModel: GroupModel) {
        self.groupID = groupID
        self.groupModel = groupModel
        self.fetchAwards()
        
        self.awardsBehaviorSubject
            .flatMap({ (awards) -> Observable<[AwardCellModel]> in
                let ret: [AwardCellModel] = awards.compactMap({
                    return AwardCellModel(id: $0.key, model: $0.value)
                })
                return Observable.of(ret)
            })
            .subscribe(onNext: {
                self.sections = [AwardSection.section(items: $0.compactMap({AwardItemType.award($0)}))]
                self.sectionsBehaviourSubject.onNext(self.sections)
            })
    }
    
    private func fetchAwards() {
        let groupRef = FirebaseReferences().groupRef.document(self.groupID)
        groupRef.getDocument(completion: { (document, error) in
            if let document = document {
                guard let groupData = document.data() else { return }
                guard let awards = groupData["awards"] as? [String] else { return }
                self.toAwardModel(awards)
            } else {
                print("User not exist")
            }
        })
    }
    
    private func toAwardModel(_ awards: [String]) {
        if awards.count == 0 {
            
        } else {
            _ = awards.compactMap({ award in
                let awardRef = FirebaseReferences().awardRef.document(award)
                awardRef.getDocument(completion: { (document, error) in
                    if let document = document {
                        guard let awardData = document.data() else { return }
                        let awardModel = try! FirebaseDecoder().decode(AwardModel.self, from: awardData)
                        self.awards[document.documentID] = awardModel
                        if awards.count == self.awards.count {
                            self.awardsBehaviorSubject.onNext(self.awards)
                        }
                    } else {
                        print("Award not exist")
                    }
                })
            })
        }
    }
}
