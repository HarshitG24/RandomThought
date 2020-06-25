//
//  DataService.swift
//  RNDM
//
//  Created by Harshit Gajjar on 6/25/20.
//  Copyright © 2020 ThinkX. All rights reserved.
//

import Foundation
import Firebase

let FIRESTORE_REF = Firestore.firestore().collection("thoughts;")

class DataService{
    
    static let instance = DataService() // making it a singletone class
    private(set) public var REF_BASE = FIRESTORE_REF
    private(set) public var ACTION_LISTENER: ListenerRegistration!
    
    func addDocument(userData: Dictionary<String, Any>, uploadComplete: @escaping (Bool) -> ()){
        
        REF_BASE.addDocument(data: userData) { (error) in
            if error != nil{
                uploadComplete(false)
            }else{
                uploadComplete(true)
            }
        }
    }
    
    func getAllDocuments(category: String ,handler: @escaping ([Thought]?, Error?) -> ()){
        ACTION_LISTENER = REF_BASE
            .whereField(CATEGORY, isEqualTo: category)
        .order(by: TIMESTAMP, descending: true)
            .addSnapshotListener { (querySnapShot, error) in
//            var tgtArr = [Thought]()
            
            if let err = error{
                handler(nil, err)
            }else{
                guard let snap = querySnapShot else { return }
                
//                for document in snap.documents{
//                    let data =  document.data()
//                    let thought = Thought(
//                        username: data[USERNAME] as? String ?? "",
//                        like: data[NUM_LIKES] as? Int ?? 0,
//                        comment: data[NUM_COMMENTS] as? Int ?? 0,
//                        time: data[TIMESTAMP] as?  Date ?? Date(),
//                        txt: data[THOUGHT_TXT] as? String ?? "",
//                        id: document.documentID
//                    )
//                    tgtArr.append(thought)
//                }
//                tgtArr = self.parseData(snap: snap)
                
                handler(self.parseData(snap: snap), nil)
            }
        }
    }
    
    func removeListener(){
        ACTION_LISTENER.remove()
    }
    
    func getPopularDocuments(handler: @escaping ([Thought]?, Error?) -> ()){
        ACTION_LISTENER = REF_BASE
        .order(by: NUM_LIKES, descending: true)
            .addSnapshotListener { (querySnapShot, error) in
  //          var tgtArr = [Thought]()
            
            if let err = error{
                handler(nil, err)
            }else{
                guard let snap = querySnapShot else { return }
                
//                for document in snap.documents{
//                    let data =  document.data()
//                    let thought = Thought(
//                        username: data[USERNAME] as? String ?? "",
//                        like: data[NUM_LIKES] as? Int ?? 0,
//                        comment: data[NUM_COMMENTS] as? Int ?? 0,
//                        time: data[TIMESTAMP] as?  Date ?? Date(),
//                        txt: data[THOUGHT_TXT] as? String ?? "",
//                        id: document.documentID
//                    )
//
//                    tgtArr.append(thought)
//                }
//                tgtArr = self.parseData(snap: snap)
                
                handler(self.parseData(snap: snap), nil)
            }
        }
    }
    
    func parseData(snap: QuerySnapshot) -> [Thought]{
        var tgtArr = [Thought]()
        for document in snap.documents{
            let data =  document.data()
            let thought = Thought(
                username: data[USERNAME] as? String ?? "",
                like: data[NUM_LIKES] as? Int ?? 0,
                comment: data[NUM_COMMENTS] as? Int ?? 0,
                time: data[TIMESTAMP] as?  Date ?? Date(),
                txt: data[THOUGHT_TXT] as? String ?? "",
                id: document.documentID
            )
         
            tgtArr.append(thought)
        }
        
        return tgtArr
    }
    
    func likeTheThought(thought: Thought){
        FIRESTORE_REF.document(thought.docuemntId).setData([NUM_LIKES: thought.numLikes + 1], merge: true)
        
        // we use merge so that, it only updates that specific data entry and not override the whole document
    }
}
