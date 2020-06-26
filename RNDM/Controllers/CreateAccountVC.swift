//
//  CreateAccountVC.swift
//  RNDM
//
//  Created by Harshit Gajjar on 6/26/20.
//  Copyright © 2020 ThinkX. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountVC: UIViewController {

    //MARK:- Outlets
    
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passTxtField: UITextField!
    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var createUserBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createUserBtn.layer.cornerRadius = 10
        cancelBtn.layer.cornerRadius = 10
    }
    
    @IBAction func createUserBtnPressed(_ sender: Any) {
        
        if let email = emailTxtField.text, let pass = passTxtField.text, let username = usernameTxtField.text{
            
            Auth.auth().createUser(withEmail: email, password: pass) { (authData, error) in
                
                if let err = error{
                    debugPrint(err.localizedDescription)
                }
                
                let changerequest = authData?.user.createProfileChangeRequest()
                changerequest?.displayName = username
                changerequest?.commitChanges(completion: { (error) in
                    if let err = error{
                        debugPrint(err.localizedDescription)
                    }
                })
                
                guard let uid = authData?.user.uid else { return }
                
                let userData: [String : Any] = [
                    USERNAME: username,
                    DATE_CREATED: FieldValue.serverTimestamp()
                ]
                AuthService.instance.createUser(uid: uid, userData: userData) { (accountCreated) in
                    
                    if accountCreated{
                        print("success")
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        print("error creating account")
                    }
                }
            }
        }
        
    }
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
