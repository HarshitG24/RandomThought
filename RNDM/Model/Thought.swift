//
//  Thought.swift
//  RNDM
//
//  Created by Harshit Gajjar on 6/25/20.
//  Copyright © 2020 ThinkX. All rights reserved.
//

import Foundation

class Thought{
    private(set) public var username: String!
    private(set) public var numLikes: Int!
    private(set) public var numComments: Int!
    private(set) public var timestamp: Date!
    private(set) public var thoughtTxt: String!
    private(set) public var docuemntId: String!
    private(set) public var userId: String
    
    init(username: String, like: Int, comment: Int, time: Date, txt: String, id: String, uid: String) {
        self.docuemntId = id
        self.numComments = comment
        self.numLikes = like
        self.timestamp = time
        self.username = username
        self.thoughtTxt = txt
        self.userId = uid
    }
}
