//
//  CommentCell.swift
//  RNDM
//
//  Created by Harshit Gajjar on 6/26/20.
//  Copyright © 2020 ThinkX. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var comment: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(comment: Comment){
        self.username.text = comment.username
        self.comment.text = comment.commentTxt
        
        let formatter =  DateFormatter()
        formatter.dateFormat = "MMM d, hh:mm"
        let timestmp = formatter.string(from: comment.timestamp)
        timestamp.text = timestmp
    }

}

