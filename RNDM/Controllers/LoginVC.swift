//
//  LoginVC.swift
//  RNDM
//
//  Created by Harshit Gajjar on 6/26/20.
//  Copyright © 2020 ThinkX. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    // MARK:- Outlets
    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginBtn.layer.cornerRadius = 10
        signUpBtn.layer.cornerRadius = 10
    }
    
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        guard let email = usernameTxtField.text,
            let pass = passwordTxtField.text else {return}
        
        AuthService.instance.loginUser(email: email, pass: pass) { (status) in
            if status{
                self.dismiss(animated: true, completion: nil)
            }else{
                print("error creating account")
            }
        }
    }
    
    @IBAction func signUpBtnPressed(_ sender: Any) {
    }
}
