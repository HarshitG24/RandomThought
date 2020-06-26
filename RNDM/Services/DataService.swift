//
//  DataService.swift
//  RNDM
//
//  Created by Harshit Gajjar on 6/25/20.
//  Copyright © 2020 ThinkX. All rights reserved.
//

import Foundation
import Firebase

let firestore =  Firestore.firestore()
let FIRESTORE_REF = firestore.collection("thoughts")

class DataService{
    
    static let instance = DataService() // making it a singletone class
    private(set) public var REF_BASE = FIRESTORE_REF
    private(set) public var FIREBASE_REF = firestore
    private(set) public var ACTION_LISTENER: ListenerRegistration!
    private(set) public var COMMENT_LISTENER: ListenerRegistration!
    
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
            
            if let err = error{
                handler(nil, err)
            }else{
                guard let snap = querySnapShot else { return }
                handler(self.parseData(snap: snap), nil)
            }
        }
    }
    
    func removeListener(){
        ACTION_LISTENER.remove()
    }
    
    func removeCommentListener(){
        COMMENT_LISTENER.remove()
    }
    
    func getPopularDocuments(handler: @escaping ([Thought]?, Error?) -> ()){
        ACTION_LISTENER = REF_BASE
        .order(by: NUM_LIKES, descending: true)
            .addSnapshotListener { (querySnapShot, error) in
            
            if let err = error{
                handler(nil, err)
            }else{
                guard let snap = querySnapShot else { return }
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
                id: document.documentID,
                uid: data[USER_ID] as? String ?? ""
            )
         
            tgtArr.append(thought)
        }
        
        return tgtArr
    }
    
    func parseComments(snap: QuerySnapshot) -> [Comment]{
        var commentArr = [Comment]()
        for document in snap.documents{
            let data =  document.data()
            let comment = Comment(
                username: data[USERNAME] as? String ?? "",
                time: data[DATE_CREATED] as? Date ?? Date(),
                txt: data["commentTxt"] as? String ?? "",
                uid: data[USER_ID] as? String ?? "",
                documentId: document.documentID 
             )
            commentArr.append(comment)
        }
        
        return commentArr
    }
    
    func likeTheThought(thought: Thought){
        FIRESTORE_REF.document(thought.docuemntId).setData([NUM_LIKES: thought.numLikes + 1], merge: true)
        
        // we use merge so that, it only updates that specific data entry and not override the whole document
    }
    
    func addComment(uid: String, commentData: [String: Any], handler: @escaping (_ status: Bool) -> ()){
        
        let thoughtRef = REF_BASE.document(uid)
        
        FIREBASE_REF.runTransaction({ (transaction, error) -> Any? in
            let thoughtDocument: DocumentSnapshot!
            
            do{
                try thoughtDocument = transaction.getDocument(thoughtRef)
            }catch{
                return nil
            }
            
            guard let oldNumComments = thoughtDocument.data()![NUM_COMMENTS] as? Int else {return nil}
            
            transaction.updateData([NUM_COMMENTS: oldNumComments + 1], forDocument: thoughtRef)
            
            let newCommentRef = thoughtRef.collection(COMMENTS).document()
            
            let cData: [String: Any] = [
                "commentTxt": commentData["commentTxt"]!,
                TIMESTAMP: commentData[TIMESTAMP]!,
                USERNAME: commentData[USERNAME]!,
                USER_ID: commentData[USER_ID]!,
                DOCUMENT_ID: newCommentRef.documentID
            ]
            
            transaction.setData(cData, forDocument: newCommentRef)
            handler(true)
            
            return nil
        }) { (object, error) in
            
            if error != nil{
                handler(false)
            }else{
                handler(true)
            }
        }
    }
    
    
    func getAllComments(uid: String, handler: @escaping (_ comments: [Comment]) -> ()){
        
        COMMENT_LISTENER = REF_BASE
            .document(uid)
            .collection(COMMENTS)
            .order(by: TIMESTAMP, descending: true)
            .addSnapshotListener({ (querySnapShot, error) in
                
                guard let snap = querySnapShot else {return}
                handler(self.parseComments(snap: snap))
            })
    }
    
    func deleteComment(uid: String, cid: String, handler: @escaping (_ status: Bool) -> ()){
        
        let thoughtRef = REF_BASE.document(uid)
               
               FIREBASE_REF.runTransaction({ (transaction, error) -> Any? in
                   let thoughtDocument: DocumentSnapshot!
                   
                   do{
                       try thoughtDocument = transaction.getDocument(thoughtRef)
                   }catch{
                       return nil
                   }
                   
                   guard let oldNumComments = thoughtDocument.data()![NUM_COMMENTS] as? Int else {return nil}
                   
                   transaction.updateData([NUM_COMMENTS: oldNumComments - 1], forDocument: thoughtRef)

// below is way to show simple delete function
                
//                self.REF_BASE
//                        .document(uid)  // thoughts / document
//                        .collection(COMMENTS)  // thoughts / document / comments
//                        .document(cid)
//                            .delete { (error) in
//
//                                if error != nil{
//                                    handler(false)
//                                }else{
//                                    handler(true)
//                                }
//                        }
                let deleteRef = self.REF_BASE.document(uid).collection(COMMENTS).document(cid)
                transaction.deleteDocument(deleteRef)
                
                   handler(true)
                   
                   return nil
               }) { (object, error) in
                   
                   if error != nil{
                       handler(false)
                   }else{
                       handler(true)
                   }
               }
    }
    
    func updateComment(comment: Comment, thought: Thought, txt: String, handler: @escaping (_ status: Bool) -> ()){
        
        REF_BASE
            .document(thought.docuemntId)
            .collection(COMMENTS)
            .document(comment.documentId)
            .setData(["commentTxt": txt], merge: true) { (error) in
                if error != nil{
                    handler(false) // failure in updating
                }else{
                    handler(true)  // success in updating
                }
        }
    }
    
    func deleteThought(uid: String, handler: @escaping (_ status: Bool) -> ()){
        REF_BASE.document(uid).delete { (error) in
            
            if error !=  nil{
                handler(false)
            }else{
                handler(true)
            }
        }
    }
}
