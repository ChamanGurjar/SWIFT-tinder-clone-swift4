//
//  UpdateViewController.swift
//  Tinder-Clone
//
//  Created by Chaman Gurjar on 12/01/19.
//  Copyright © 2019 Chaman Gurjar. All rights reserved.
//

import UIKit
import Parse

class UpdateViewController: UIViewController {
    
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet weak var genderSwitch: UISwitch!
    @IBOutlet weak var interestedGenderSwitch: UISwitch!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.isHidden = true
    }
    
    @IBAction func chooseUserProfileImage(_ sender: UIButton) {
        chooseImage()
    }
    
    @IBAction func updateUSerProfile(_ sender: UIButton) {
        PFUser.current()?["isFemale"] = genderSwitch.isOn
        PFUser.current()?["isInterestedInWoman"] = interestedGenderSwitch.isOn
        
        if let image = profileImageView.image, let imageData = image.pngData() {
            PFUser.current()?["photo"] = PFFileObject(name: "image.png", data: imageData)
        }
        
        PFUser.current()?.saveInBackground(block: { (success, err) in
            if err != nil {
                self.handleError(err)
            } else {
                print("Update Successful!")
            }
        })
    }
    
    private func handleError(_ err: Error?) {
        var errorMessage = "Update Failed - Please try again."
        if let error = err as NSError?, let errorText = error.userInfo["error"] as? String {
            errorMessage = errorText
        }
        self.errorLabel.isHidden = false
        self.errorLabel.text = errorMessage
    }
    
}

extension UpdateViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    private func chooseImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            profileImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
}
