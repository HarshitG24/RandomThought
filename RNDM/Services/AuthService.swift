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
}
