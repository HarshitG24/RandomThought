//
//  AuthService.swift
//  RNDM
//
//  Created by Harshit Gajjar on 6/26/20.
//  Copyright © 2020 ThinkX. All rights reserved.
//

import Foundation
import Firebase

let USER_REF = Firestore.firestore().collection("users")

class AuthService{
    static let instance = AuthService()
    private(set) public var USER_REF_BASE = USER_REF
    private(set) public var handle: AuthStateDidChangeListenerHandle?
    
    func createUser(uid: String, userData: [String: Any], handler: @escaping (_ userCreated: Bool) -> ()){
        
        USER_REF_BASE.document(uid).setData(userData) { (error) in
            if let err = error{
                debugPrint(err.localizedDescription)
                handler(false)
            }else{
                handler(true)
            }
        }
    }
    
    func loginUser(email: String, pass: String, handler: @escaping (_ status: Bool) -> ()){
        Auth.auth().signIn(withEmail: email, password: pass) { (authData, error) in
            if let err = error{
                debugPrint(err.localizedDescription)
                handler(false)
            }
            
            if let data = authData?.user{
                print(data)
                handler(true)
            }
        }
    }
    
    func authActionListener(handler: @escaping (_ isLoggedIn: Bool) -> ()){
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user == nil{
                // user not logged in
                handler(false)
            }else{
                // user is logged in
                handler(true)
            }
        })
    }
    
    func logoutUser(){
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
        }catch{
            debugPrint(error.localizedDescription)
        }
    }
}
