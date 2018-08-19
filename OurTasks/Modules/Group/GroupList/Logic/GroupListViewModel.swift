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
    var userGroups: [String:GroupModel] = [:]
    
    var userGroupsBehaviorSubject: BehaviorSubject<[String:GroupModel]> = BehaviorSubject(value: [:])
    var userInvitesBehaviorSubject: BehaviorSubject<[String:GroupModel]> = BehaviorSubject(value: [:])
    var noGroupUserBehaviorSubject: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var noInvitesBehaviorSubject: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var sectionsBehaviourSubject: BehaviorSubject<[GroupListSection]> = BehaviorSubject(value: [])
    
    private let disposeBag = DisposeBag()
    private var sections: [GroupListSection] = []
    
    init() {
        self.userGroupsBehaviorSubject
            .flatMap({ (userGroups) -> Observable<[UserGroupsCellModel]> in
                let ret: [UserGroupsCellModel] = userGroups.compactMap({
                    return UserGroupsCellModel(id: $0.key, groupModel: $0.value)
                })
                return Observable.of(ret)
            })
            .subscribe(onNext: {
                self.sections = self.sections.filter({ $0.title != GroupListSectionTitle.userGroups.rawValue })
                self.sections.insert(GroupListSection.section(title: .userGroups, items: $0.compactMap({ GroupListItemType.userGroups($0) })), at: 0)
                self.sectionsBehaviourSubject.onNext(self.sections)
            })
            .disposed(by: self.disposeBag)
        
        self.userInvitesBehaviorSubject
            .flatMap({ (userInvites) -> Observable<[UserInvitesCellModel]> in
                let ret: [UserInvitesCellModel] = userInvites.compactMap({
                    return UserInvitesCellModel(id: $0.key, name: $0.value.name, color: $0.value.color, followBtnText: "Follow", followBtnVisible: true)
                })
                return Observable.of(ret)
            })
            .subscribe(onNext: {
                self.sections = self.sections.filter({ $0.title != GroupListSectionTitle.userInvites.rawValue })
                self.sections.insert(GroupListSection.section(title: .userInvites, items: $0.compactMap({ GroupListItemType.userInvites($0) })), at: 1)
                self.sectionsBehaviourSubject.onNext(self.sections)
            })
            .disposed(by: self.disposeBag)
        
        self.noGroupUserBehaviorSubject
            .flatMap({ (noTeams) -> Observable<NoResultCellModel> in
                let ret: NoResultCellModel = {
                    return NoResultCellModel(description: "no_group_user".localize())
                }()
                return Observable.of(ret)
            })
            .subscribe(onNext: {
                self.sections = self.sections.filter({ $0.title != GroupListSectionTitle.userGroups.rawValue })
                self.sections.insert(GroupListSection.section(title: .userGroups, items: [GroupListItemType.noResult($0)]), at: 0)
                self.sectionsBehaviourSubject.onNext(self.sections)
            })
            .disposed(by: self.disposeBag)
        
        self.noInvitesBehaviorSubject
            .flatMap({ (noTeams) -> Observable<NoResultCellModel> in
                let ret: NoResultCellModel = {
                    return NoResultCellModel(description: "no_invites".localize())
                }()
                return Observable.of(ret)
            })
            .subscribe(onNext: {
                self.sections = self.sections.filter({ $0.title != GroupListSectionTitle.userInvites.rawValue })
                self.sections.insert(GroupListSection.section(title: .userInvites, items: [GroupListItemType.noResult($0)]), at: 1)
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
        self.userInvitesBehaviorSubject.onNext([:])
        self.noInvitesBehaviorSubject.onNext(true)
    }
    
    private func toGroupModel(_ groups: [String]) {
        if groups.count == 0 {
            self.noGroupUserBehaviorSubject.onNext(true)
        } else {
            _ = groups.compactMap({ group in
                let groupRef = FirebaseReferences().groupRef.document(group)
                groupRef.getDocument(completion: { (document, error) in
                    if let document = document {
                        guard let groupData = document.data() else { return }
                        let groupModel = try! FirebaseDecoder().decode(GroupModel.self, from: groupData)
                        self.userGroups[document.documentID] = groupModel
                        if groups.count == self.userGroups.count {
                            self.userGroupsBehaviorSubject.onNext(self.userGroups)
                        }
                        
                    } else {
                        print("Group not exist")
                    }
                })
            })
        }
        
    }
    
    
}
