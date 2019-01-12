//
//  LoginSignUpViewController.swift
//  Tinder-Clone
//
//  Created by Chaman Gurjar on 12/01/19.
//  Copyright © 2019 Chaman Gurjar. All rights reserved.
//

import UIKit

class LoginSignUpViewController: UIViewController {
    
    @IBOutlet private weak var usernameTF: UITextField!
    @IBOutlet private weak var passwordTF: UITextField!
    @IBOutlet private weak var loginSignUpButton: UIButton!
    @IBOutlet private weak var changeLoginSignUpModeButton: UIButton!
    
    private var inLoggedInMode = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func loginSignUpUser(_ sender: UIButton) {
        
    }
    
    @IBAction func changeLoginSignUpMode(_ sender: UIButton) {
        if inLoggedInMode {
            loginSignUpButton.setTitle("SignUp", for: .normal)
            changeLoginSignUpModeButton.setTitle("Login", for: .normal)
            inLoggedInMode = false
        } else {
            loginSignUpButton.setTitle("LogIn", for: .normal)
            changeLoginSignUpModeButton.setTitle("SignUp", for: .normal)
            inLoggedInMode = true
        }
    }
    
    
}
