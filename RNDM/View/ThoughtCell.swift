//
//  ThoughtCell.swift
//  RNDM
//
//  Created by Harshit Gajjar on 6/25/20.
//  Copyright © 2020 ThinkX. All rights reserved.
//

import UIKit
import Firebase

class ThoughtCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var thoughttxt: UILabel!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var likesImg: UIImageView!
    @IBOutlet weak var numCommentslbl: UILabel!
    @IBOutlet weak var menuOptions: UIImageView!
    
    //MARK:- Variables
    var thought: Thought!
    var delegate: ThoughtDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(likeBtnTapped))
        likesImg.addGestureRecognizer(tapGesture)
        likesImg.isUserInteractionEnabled = true
    }
    
    @objc func likeBtnTapped(){
        DataService.instance.likeTheThought(thought: self.thought)
    }
    
    func configureCell(thought: Thought, delegate: ThoughtDelegate){
        self.menuOptions.isHidden = true
        self.thought = thought
        self.delegate = delegate
        self.likes.text = String(thought.numLikes)
        self.username.text = thought.username
        self.thoughttxt.text = thought.thoughtTxt
        self.numCommentslbl.text = String(thought.numComments)
      
        let formatter =  DateFormatter()
        formatter.dateFormat = "MMM d, hh:mm"
        let timestmp = formatter.string(from: thought.timestamp)
        timestamp.text = timestmp
        
        if thought.userId == Auth.auth().currentUser?.uid{
            self.menuOptions.isHidden = false
            self.menuOptions.isUserInteractionEnabled = true
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(showMenu))
            menuOptions.addGestureRecognizer(tap)
        }
    }
    
    @objc func showMenu(){
        delegate?.thoughtOptionTapped(thought: self.thought)
    }

}
