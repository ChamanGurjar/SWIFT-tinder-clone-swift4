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
    
    @IBOutlet weak var matchUserImageView: UIImageView!
    
    private var displayUserId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDraggingGesture()
        updateMatchingImage()
    }
    
    private func setupDraggingGesture() {
        //  Pan Gesture is used to drag element Left or Right.
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(dragElementLeftOrRight(gestureRecognizer:)))
        matchUserImageView.addGestureRecognizer(swipeGesture)
    }
    
    @objc private func dragElementLeftOrRight(gestureRecognizer: UIPanGestureRecognizer) {
        let labelPoint = gestureRecognizer.translation(in: view)
        matchUserImageView.center = CGPoint(x: view.bounds.width / 2 + labelPoint.x, y: view.bounds.height / 2 + labelPoint.y)
        
        let xFromCenter = view.bounds.width / 2 - matchUserImageView.center.x
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        let scale = min(100 / abs(xFromCenter), 1)
        var scaleAndRotated = rotation.scaledBy(x: scale, y: scale)
        matchUserImageView.transform = scaleAndRotated
        
        if gestureRecognizer.state == .ended {
            var acceptedOrRejected = ""
            if matchUserImageView.center.x < (view.bounds.width / 2 - 100) {
                print("Not Interested")
                acceptedOrRejected = "rejected"
            } else if matchUserImageView.center.x > (view.bounds.width / 2 + 100) {
                print("Interested")
                acceptedOrRejected = "accepted"
            }
            
            if acceptedOrRejected != "" && displayUserId != "" {
                PFUser.current()?.addUniqueObject(displayUserId, forKey: acceptedOrRejected)
                
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    if success {
                        self.updateMatchingImage()
                    }
                })
            }
            
            rotation = CGAffineTransform(rotationAngle: 0)
            scaleAndRotated = rotation.scaledBy(x: 1, y: 1)
            matchUserImageView.transform = scaleAndRotated
            
            matchUserImageView.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        }
        
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        PFUser.logOut()
        performSegue(withIdentifier: "goToSignUp", sender: nil)
    }
    
    /*
     Fetch Details for match
     */
    private func updateMatchingImage() {
        if let query = PFUser.query() {
            
            if let isInterestedInWoman = PFUser.current()?["isInterestedInWoman"] {
                query.whereKey("isFemale", equalTo: isInterestedInWoman)
            }
            if let isFemale = PFUser.current()?["isFemale"] {
                query.whereKey("isInterestedInWoman", equalTo: isFemale)
            }
            
            var ignoredUsers: [String] = [] // Users whom the logged in user either accepted or rejected.
            if let acceptedUsers = PFUser.current()?["accepted"] as? [String] {
                ignoredUsers += acceptedUsers
            }
            if let rejectedUsers = PFUser.current()?["rejected"] as? [String] {
                ignoredUsers += rejectedUsers
            }
            query.whereKey("objectId", notContainedIn: ignoredUsers)
            
            query.limit = 1
            query.findObjectsInBackground { (fetchedObjects, err) in
                if let objects = fetchedObjects {
                    for object in objects {
                        if let user = object as? PFUser, let imageFile = user["photo"] as? PFFileObject {
                            imageFile.getDataInBackground(block: { (data, err) in
                                if let imageData = data {
                                    self.matchUserImageView.image = UIImage(data: imageData)
                                    if let objectId = user.objectId {
                                        self.displayUserId = objectId
                                    }
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
}

