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
    private let dateFormater = DateFormatter()
    var awards: [String:AwardModel] = [:]
    var sections: [AwardSection] = []
    var groupID: String
    var groupModel: GroupModel?
    var userModel: UserModel?
    
    var userPoints: Variable<String> = Variable("")
    var awardsBehaviorSubject: BehaviorSubject<[String:AwardModel]> = BehaviorSubject(value: [:])
    var sectionsBehaviourSubject: BehaviorSubject<[AwardSection]> = BehaviorSubject(value: [])
    
    init(groupID: String, groupModel: GroupModel) {
        self.groupID = groupID
        self.groupModel = groupModel
        self.dateFormater.dateFormat = "dd.MM.YYYY"
        
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
            }).disposed(by: self.disposeBag)
    }
    //MARK: Fetch Data
    func fetchData() {
        self.fetchAwards()
        self.fetchCurrentUser()
    }
    
    private func fetchCurrentUser() {
        let currentUserUID = self.firebaseManager.getCurrentUserUid()
        let userRef = FirebaseReferences().userRef.document(currentUserUID)
        userRef.getDocument(completion: { (document, error) in
            if let document = document {
                guard let userData = document.data() else { return }
                self.userModel = try! FirebaseDecoder().decode(UserModel.self, from: userData)
                self.userPoints.value = String(self.userModel?.points ?? 0)
            } else {
                print("User not exist")
            }
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
                print("Group not exist")
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
    
    //MARK: Exchange
    func exchange(id: String) {
        var awards: [String:[String]] = [:]
        let todayDateString = dateFormater.string(from: Date())
        let currentUserUID = self.firebaseManager.getCurrentUserUid()
        let awardRef = FirebaseReferences().awardRef.document(id)
        let userRef = FirebaseReferences().userRef.document(currentUserUID)
        
        awardRef.getDocument(completion: { (document, error) in
            if let document = document {
                guard let awardData = document.data() else { return }
                guard let points = awardData["available"] as? Int else { return }
                awardRef.updateData(["available":(points-1)])
            } else {
                print("Group not exist")
            }
        })
        
        userRef.getDocument(completion: { (document, error) in
            if let document = document {
                guard let userData = document.data() else { return }
                guard var points = userData["points"] as? Int else { return }
                awards = userData["awards"] as? [String:[String]] ?? [:]
                var dateAwards = awards[todayDateString] ?? []
                dateAwards.append(id)
                awards[todayDateString] = dateAwards
                
                points = points - (self.awards[id]?.cost ?? 0)
                userRef.setData(["awards":awards,
                                 "points":points], merge: true)
                
            } else {
                print("Group not exist")
            }
        })
    }
}
