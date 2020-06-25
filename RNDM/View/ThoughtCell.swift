//
//  ThoughtCell.swift
//  RNDM
//
//  Created by Harshit Gajjar on 6/25/20.
//  Copyright © 2020 ThinkX. All rights reserved.
//

import UIKit

class ThoughtCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var thoughttxt: UILabel!
    @IBOutlet weak var likes: UILabel!
    
    func configureCell(thought: Thought){
        self.likes.text = String(thought.numLikes)
        self.username.text = thought.username
        self.thoughttxt.text = thought.thoughtTxt
      
        let formatter =  DateFormatter()
        formatter.dateFormat = "MMM d, hh:mm"
        let timestmp = formatter.string(from: thought.timestamp)
        timestamp.text = timestmp
    }

}
