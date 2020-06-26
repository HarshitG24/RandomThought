//
//  Protocols.swift
//  RNDM
//
//  Created by Harshit Gajjar on 6/26/20.
//  Copyright © 2020 ThinkX. All rights reserved.
//

import Foundation

protocol ThoughtDelegate {
    func thoughtOptionTapped(thought: Thought)
}

protocol CommentDelegate {
    func commentOptionTapped(comment: Comment)
}
