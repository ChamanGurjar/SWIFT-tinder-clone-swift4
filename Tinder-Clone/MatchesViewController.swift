//
//  MatchesViewController.swift
//  Tinder-Clone
//
//  Created by Chaman Gurjar on 14/01/19.
//  Copyright © 2019 Chaman Gurjar. All rights reserved.
//

import UIKit
import Parse

class MatchesViewController: UIViewController {
    
    @IBOutlet private weak var matchesTableView: UITableView!
    
    private var userProfileImages = [UIImage]()
    private var userIds = [String]()
    private var messages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerDelegateAndDataSourceForTheTable()
        findMatches()
    }
    
    private func findMatches() {
        if let query = PFUser.query() {
            
            query.whereKey("accepted", contains: PFUser.current()?.objectId)
            if let acceptedMatches = PFUser.current()?["accepted"] as? [String] {
                query.whereKey("objectId", containedIn: acceptedMatches)
            }
            
            query.findObjectsInBackground { (objects, err) in
                if let users = objects as? [PFUser] {
                    for user in users {
                        if let imageFile = user["photo"] as? PFFileObject {
                            imageFile.getDataInBackground(block: { (data, err) in
                                if let imageData = data, let userProfileImage = UIImage(data: imageData) {
                                    self.userProfileImages.append(userProfileImage)
                                    if let objectId = user.objectId {
                                        self.userIds.append(objectId)
                                        self.getMessagesFrom(thisUser: objectId)
                                    }
                                }
                                
                                // self.matchesTableView.reloadData()
                            })
                        }
                    }
                }
            }
            
            
        }
    }
    
    private func getMessagesFrom(thisUser senderId: String) {
        let messageQuery = PFQuery(className: "Message")
        if let currentUserId = PFUser.current()?.objectId {
            messageQuery.whereKey("recipient", equalTo: currentUserId)
        }
        messageQuery.whereKey("sender", equalTo: senderId)
        messageQuery.findObjectsInBackground { (fetchedMessages, err) in
            if let messages = fetchedMessages {
                messages.forEach({ (message) in
                    var messageText = "No message from this user."
                    if let content = message["content"] as? String {
                        messageText = content
                        self.messages.append(messageText)
                    }
                    self.matchesTableView.reloadData()
                })
            }
        }
    }
    
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension MatchesViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func registerDelegateAndDataSourceForTheTable() {
        matchesTableView.delegate = self
        matchesTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userProfileImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchTVCell", for: indexPath) as! MatchTableViewCell
        cell.userProfileImage.image = userProfileImages[indexPath.row]
        cell.messageLabel.text = messages[indexPath.row]
        cell.recipientObjectId = userIds[indexPath.row]
        return cell
    }
}
