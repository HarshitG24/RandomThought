//
//  CommentCell.swift
//  RNDM
//
//  Created by Harshit Gajjar on 6/26/20.
//  Copyright © 2020 ThinkX. All rights reserved.
//

import UIKit
import Firebase

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var menuOptions: UIImageView!
    
    //MARK:- Variables
    var commen: Comment!
    var delegate: CommentDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(comment: Comment, delegate: CommentDelegate){
        menuOptions.isHidden = true
        self.username.text = comment.username
        self.comment.text = comment.commentTxt
        self.delegate = delegate
        self.commen = comment
        
        let formatter =  DateFormatter()
        formatter.dateFormat = "MMM d, hh:mm"
        let timestmp = formatter.string(from: comment.timestamp)
        timestamp.text = timestmp
        
        if comment.userId == Auth.auth().currentUser?.uid{
            self.menuOptions.isHidden = false
            self.menuOptions.isUserInteractionEnabled = true
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(showMenu))
            menuOptions.addGestureRecognizer(tap)
        }
    }

    @objc func showMenu(){
        delegate?.commentOptionTapped(comment: self.commen)
       }
}

