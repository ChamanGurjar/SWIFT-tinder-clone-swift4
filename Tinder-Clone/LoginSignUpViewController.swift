//
//  LoginSignUpViewController.swift
//  Tinder-Clone
//
//  Created by Chaman Gurjar on 12/01/19.
//  Copyright © 2019 Chaman Gurjar. All rights reserved.
//

import UIKit
import Parse

class LoginSignUpViewController: UIViewController {
    
    @IBOutlet private weak var usernameTF: UITextField!
    @IBOutlet private weak var passwordTF: UITextField!
    @IBOutlet private weak var loginSignUpButton: UIButton!
    @IBOutlet private weak var changeLoginSignUpModeButton: UIButton!
    @IBOutlet private weak var errorLabel: UILabel!
    
    
    private var logInMode = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.isHidden = true
    }
    
    
    @IBAction func loginSignUpUser(_ sender: UIButton) {
        if logInMode {
            loginUser()
        } else {
            signUpUser()
        }
    }
    
    @IBAction func changeLoginSignUpMode(_ sender: UIButton) {
        if logInMode {
            loginSignUpButton.setTitle("SignUp", for: .normal)
            changeLoginSignUpModeButton.setTitle("Login", for: .normal)
            logInMode = false
        } else {
            loginSignUpButton.setTitle("LogIn", for: .normal)
            changeLoginSignUpModeButton.setTitle("SignUp", for: .normal)
            logInMode = true
        }
    }
    
    private func signUpUser() {
        let user = PFUser()
        user.username = usernameTF.text!
        user.password = passwordTF.text!
        
        user.signUpInBackground { (success, err) in
            if err != nil {
                self.handleError(err, activity: "SignUp")
            } else {
                print("Hurrah, SignedUp Successfully!")
            }
        }
        
    }
    
    private func loginUser() {
        if let userName = usernameTF.text, let password = passwordTF.text {
            PFUser.logInWithUsername(inBackground: userName, password: password) { (user, err) in
                if err != nil {
                    self.handleError(err, activity: "Login")
                } else {
                    print("Hurrah, LogedIn Successfully!")
                }
            }
        }
        
    }
    
    private func handleError(_ err: Error?, activity: String) {
        var errorMessage = "\(activity) Failed - Please try again."
        if let error = err as NSError?, let errorText = error.userInfo["error"] as? String {
            errorMessage = errorText
        }
        self.errorLabel.isHidden = false
        self.errorLabel.text = errorMessage
    }
    
}
