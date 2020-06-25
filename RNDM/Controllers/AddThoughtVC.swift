//
//  AddThoughtVC.swift
//  RNDM
//
//  Created by Harshit Gajjar on 6/25/20.
//  Copyright © 2020 ThinkX. All rights reserved.
//

import UIKit
import Firebase

class AddThoughtVC: UIViewController {

    // MARK:- Outlets
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var thoughtTextView: UITextView!
    @IBOutlet weak var postBtn: UIButton!
    
     // MARK:- Variables
    private var selectedSegment = "funny"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postBtn.layer.cornerRadius = 4
        thoughtTextView.layer.cornerRadius = 4
        thoughtTextView.text = "Enter your thought..."
        thoughtTextView.textColor = UIColor.lightGray
        thoughtTextView.delegate = self
    }
    
     // MARK:- Actions
    
    @IBAction func postThought(_ sender: Any) {
        
        if let txt = self.thoughtTextView.text, let username = self.usernameTxtField.text{
            let thoughtDictionaryData: [String : Any] = [
                CATEGORY: self.selectedSegment,
                NUM_COMMENTS: 0,
                NUM_LIKES: 0,
                THOUGHT_TXT: txt,
                USERNAME : username,
                TIMESTAMP : FieldValue.serverTimestamp()
                ]
            
            DataService.instance.addDocument(userData: thoughtDictionaryData) { (uploadComplete) in
                if uploadComplete{
                    // successful
                    self.categorySegmentedControl.selectedSegmentIndex = 0
                    self.thoughtTextView.text = "Enter your thought..."
                    self.thoughtTextView.textColor = UIColor.lightGray
                    self.usernameTxtField.text = ""
                }else{
                    debugPrint("error uploading the document")
                }
            }
        }
    }
    
    
    @IBAction func segmentChanged(_ sender: Any) {
    
        switch categorySegmentedControl.selectedSegmentIndex {
        case 0:
            self.selectedSegment = Categories.funny.rawValue
            break
            
        case 1:
            self.selectedSegment = Categories.serious.rawValue
            break
            
        case 2:
            self.selectedSegment = Categories.crazy.rawValue
            break
        default:
            self.selectedSegment = Categories.popular.rawValue
            break
        }
    }
}

extension AddThoughtVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.thoughtTextView.text = ""
        self.thoughtTextView.textColor = UIColor.darkGray
    }
}
