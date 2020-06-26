//
//  CommentsVC.swift
//  RNDM
//
//  Created by Harshit Gajjar on 6/26/20.
//  Copyright © 2020 ThinkX. All rights reserved.
//

import UIKit

class CommentsVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var commentsTV: UITableView!
    @IBOutlet weak var addCommentTxtField: UITextField!
    @IBOutlet weak var sendComment: UIButton!
    @IBOutlet weak var keyboardView: UIView!
    
    // MARK:- Variables
    var thought: Thought!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func postCommentBtn(_ sender: Any) {
    }
    
}
