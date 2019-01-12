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
    @IBOutlet weak var swipeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDraggingGesture()
    }
    
    private func setupDraggingGesture() {
        //  Pan Gesture is used to drag element Left or Right.
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(dragElementLeftOrRight(gestureRecognizer:)))
        swipeLabel.addGestureRecognizer(swipeGesture)
    }
    
    @objc private func dragElementLeftOrRight(gestureRecognizer: UIPanGestureRecognizer) {
        let labelPoint = gestureRecognizer.translation(in: view)
        swipeLabel.center = CGPoint(x: view.bounds.width / 2 + labelPoint.x, y: view.bounds.height / 2 + labelPoint.y)
        
        if gestureRecognizer.state == .ended {
            if swipeLabel.center.x < (view.bounds.width / 2 - 100) {
                print("Not Interested")
            } else if swipeLabel.center.x > (view.bounds.width / 2 + 100) {
                print("Interested")
            }
            
            swipeLabel.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        }
    }
    
    
}

