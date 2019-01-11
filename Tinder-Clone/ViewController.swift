//
//  ViewController.swift
//  Tinder-Clone
//
//  Created by Chaman Gurjar on 11/01/19.
//  Copyright © 2019 Chaman Gurjar. All rights reserved.
//

import UIKit
import Parse

//Parse Server Setup/Installed At :- https://www.back4app.com
class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveCustomObject()
    }
    
    private func saveCustomObject() {
        let customTestObect = PFObject(className: "CustomTestObect")
        customTestObect["checking"] = "isParseConnected"
        customTestObect.saveInBackground { (success, error) in
            if success {
                print("Hurrah, Successfully conected to parse server and saved object. Cheers")
            }
        }
    }
    
}

