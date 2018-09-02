//
//  AddEventViewModel.swift
//  OurTasks
//
//  Created by Jakub Nykiel on 25.05.2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import Firebase
import RxSwift

class AddEventViewModel {
    let db = Firestore.firestore()
    var ref: DocumentReference?
    var eventModel: EventModel?
    private var currentUser: User? = Auth.auth().currentUser
    var eventAdded: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var groupID: String = ""
    var events: [String] = []
    var users: [String] = []
    
    init(groupID: String) {
        self.groupID = groupID
        self.getGroupInfo()
    }
    
    func addEventToDatabase() {
        let batch = db.batch()
        guard let eventData = eventModel.asDictionary() else { return }
        guard let userUID = self.currentUser?.uid else { return }
        
        let eventRef = self.db.collection(FirebaseModel.events.rawValue).document()
        batch.setData(eventData, forDocument: eventRef)
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write succeeded.")
                self.events.append(eventRef.documentID)
                self.addEventToUser(id: eventRef.documentID)
                self.addEventToGroup(id: eventRef.documentID)
                
            }
        }
        
    }
    
    func addEventToUser(id: String) {
        
        let userRef = self.db.collection(FirebaseModel.users.rawValue)
        for user in self.users {
            userRef.document(user).updateData([FirebaseModel.events.rawValue : events])
        }
    }
    
    func addEventToGroup(id: String) {
        let groupRef = self.db.collection(FirebaseModel.groups.rawValue).document(self.groupID)
        groupRef.updateData([FirebaseModel.events.rawValue : events])
        self.eventAdded.onNext(true)
    }
    
    func getGroupInfo() {
        let groupRef = self.db.collection(FirebaseModel.groups.rawValue).document(self.groupID)
        
        groupRef.getDocument { (document,error) in
            if let document = document {
                print("Document data: \(String(describing: document.data()))")
                guard let data = document.data() else { return }
                guard let events: [String] = data[FirebaseModel.events.rawValue] as? [String] else { return }
                guard let users: [String:Int] = data[FirebaseModel.users.rawValue] as? [String:Int] else { return }
                users.compactMap({
                    self.users.append($0.key)
                })
                self.events = events
            } else {
                print("Document does not exist")
            }
        }
    }
}
