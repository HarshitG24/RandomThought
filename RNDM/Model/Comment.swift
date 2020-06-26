//
//  Comment.swift
//  RNDM
//
//  Created by Harshit Gajjar on 6/26/20.
//  Copyright © 2020 ThinkX. All rights reserved.
//

import Foundation

class Comment{
    private(set) public var username: String!
    private(set) public var timestamp: Date!
    private(set) public var commentTxt: String!
    
    init(username: String, time: Date, txt: String) {
        self.timestamp = time
        self.username = username
        self.commentTxt = txt
    }
}
