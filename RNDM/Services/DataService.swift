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
    
    func addDocument(userData: Dictionary<String, Any>, uploadComplete: @escaping (Bool) -> ()){
        
        REF_BASE.addDocument(data: userData) { (error) in
            if error != nil{
                uploadComplete(false)
            }else{
                uploadComplete(true)
            }
        }
    }
}
