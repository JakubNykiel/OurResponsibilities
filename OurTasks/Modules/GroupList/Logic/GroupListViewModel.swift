//
//  GroupListViewModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 19.12.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase
import RxSwift

class GroupListViewModel {
    
    private let firebaseManager: FirebaseManager = FirebaseManager()
    var userGroups: Variable<[GroupModel]> = Variable([])
    
    var userGroupsBehaviorSubject: BehaviorSubject<[GroupModel]> = BehaviorSubject(value: [])
    var userInvitesBehaviorSubject: BehaviorSubject<[GroupModel]> = BehaviorSubject(value: [])
    var sectionsBehaviourSubject: BehaviorSubject<[GroupSection]> = BehaviorSubject(value: [])
    
    private let disposeBag = DisposeBag()
    private var sections: [GroupSection] = []
    
    init() {
        self.userGroupsBehaviorSubject
            .flatMap({ (userGroups) -> Observable<[UserGroupsCellModel]> in
                let ret: [UserGroupsCellModel] = userGroups.compactMap({
                    return UserGroupsCellModel(name: $0.name)
                })
                return Observable.of(ret)
            })
            .subscribe(onNext: {
                self.sections = self.sections.filter({ $0.title != GroupSectionTitle.userGroups.rawValue })
                self.sections.insert(GroupSection.section(title: .userGroups, items: $0.compactMap({ GroupItemType.userGroups($0) })), at: 0)
                self.sectionsBehaviourSubject.onNext(self.sections)
            })
            .disposed(by: self.disposeBag)
        
        self.userInvitesBehaviorSubject
            .flatMap({ (userInvites) -> Observable<[UserInvitesCellModel]> in
                let ret: [UserInvitesCellModel] = userInvites.compactMap({
                    return UserInvitesCellModel(name: $0.name, followBtnText: "Follow", followBtnVisible: true)
                })
                return Observable.of(ret)
            })
            .subscribe(onNext: {
                self.sections = self.sections.filter({ $0.title != GroupSectionTitle.userInvites.rawValue })
                self.sections.insert(GroupSection.section(title: .userInvites, items: $0.compactMap({ GroupItemType.userInvites($0) })), at: 1)
                self.sectionsBehaviourSubject.onNext(self.sections)
            })
            .disposed(by: self.disposeBag)
    }
    
    func toggleFollow(teamAtIndex: Int) {
        //TODO: dodaj grupe przy nacisnieciu follow i odśwież widoki
    }

    
    func getUserGroups() {
        guard let uid = self.firebaseManager.currentUser?.uid else { return }
        let userGroupsRef = self.firebaseManager.db.collection(FirebaseModel.users.rawValue).document(uid)
        userGroupsRef.getDocument { (document, error) in
            if let document = document {
                guard let data = document.data() else { return }
                guard let groups: [String] = data["groups"] as? [String] else { return }
                self.toGroupModel(groups)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func getInvitesGroups() {
        
    }
    
    private func toGroupModel(_ groups: [String]) {
        let userGroups = groups.compactMap({ group in
            let groupRef = FirebaseReferences().groupRef.document(group)
            groupRef.getDocument(completion: { (document, error) in
                if let document = document {
                    guard let groupData = document.data() else { return }
                    let groupModel = try! FirebaseDecoder().decode(GroupModel.self, from: groupData)
                    self.userGroups.value.append(groupModel)
                    if groups.count == self.userGroups.value.count {
                        self.userGroupsBehaviorSubject.onNext(self.userGroups.value)
                    }
                    
                } else {
                    print("Group not exist")
                }
            })
        })
    }
    
    
}
