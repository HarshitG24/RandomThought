//
//  CommentsVC.swift
//  RNDM
//
//  Created by Harshit Gajjar on 6/26/20.
//  Copyright © 2020 ThinkX. All rights reserved.
//

import UIKit
import Firebase

class CommentsVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var commentsTV: UITableView!
    @IBOutlet weak var addCommentTxtField: UITextField!
    @IBOutlet weak var sendComment: UIButton!
    @IBOutlet weak var keyboardView: UIView!
    
    // MARK:- Variables
    var thought: Thought!
    var comments = [Comment]()
    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let name = Auth.auth().currentUser?.displayName{
            self.username = name
        }
        
        self.view.bindToKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DataService.instance.getAllComments(uid: self.thought.docuemntId) { (allComments) in
            
            print("count: \(allComments.count)")
            self.comments = allComments
            self.commentsTV.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        DataService.instance.removeCommentListener()
    }
    
    
    @IBAction func postCommentBtn(_ sender: Any) {
        guard let comment = self.addCommentTxtField.text else { return }
        
        let commentData: [String: Any] = [
            "commentTxt": comment,
            TIMESTAMP: FieldValue.serverTimestamp(),
            USERNAME: self.username!
        ]
        
        DataService.instance.addComment(uid: self.thought.docuemntId, commentData: commentData) { (status) in
            
            if status{
                DispatchQueue.main.async {
                     self.addCommentTxtField.text = ""
                    self.addCommentTxtField.resignFirstResponder() // to dismiss keyboard after comment posted
                }
            }else{
                print("error posting comment")
            }
        }
    }
    
}

extension CommentsVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentCell else { return UITableViewCell()}
        
        cell.configureCell(comment: comments[indexPath.row])
        
        return cell
    }
    
    
}
