//
//  UpdateCommentVC.swift
//  RNDM
//
//  Created by Harshit Gajjar on 6/26/20.
//  Copyright © 2020 ThinkX. All rights reserved.
//

import UIKit

class UpdateCommentVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var userComment: UITextView!
    @IBOutlet weak var updateBtn: UIButton!
    
    //MARK:- Variables
    var commentData: (comment: Comment, thought: Thought)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateBtn.layer.cornerRadius = 10
        userComment.text = commentData.comment.commentTxt!
    }
    
    @IBAction func updateBtnPressed(_ sender: Any) {
       
        guard let txt = self.userComment.text else { return }
        DataService.instance.updateComment(comment: commentData.comment, thought: commentData.thought, txt: txt){ (status) in
            
            if status{
                print("success")
            }else{
                print("error updating")
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
}
