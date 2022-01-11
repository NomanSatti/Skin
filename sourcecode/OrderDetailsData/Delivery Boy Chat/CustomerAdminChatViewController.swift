//
//  CustomerAdminChatViewController.swift
//  GoFast
//
//  Created by Webkul on 06/09/18.
//  Copyright © 2018 Webkul. All rights reserved.
//

import UIKit
import FirebaseAnalytics
import FirebaseMessaging
import FirebaseInstanceID
import FirebaseDatabase
import JSQMessagesViewController

class CustomerAdminChatViewController: JSQMessagesViewController {
    
    var messages = [JSQMessage]()
    
    var ref: DatabaseReference!
    
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    
    var otherUserId = ""
    var otherUserName = ""
    var otherUserEmail = ""
    var accountType = ""
    
    var childIdKey: String = ""
    var first_unread: Int = 0
    var second_unread: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.navigationItem.title = "Admin".localized //self.senderDisplayName
        
        incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.lightGray)
        
        print((self.senderId))
        print((self.otherUserId))
        print(childIdKey)
        
        self.inputToolbar.contentView.leftBarButtonItem = nil
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NetworkManager.sharedInstance.showLoader()
        
        ref = Database.database().reference().child("DeliveryApp").child("messages").child(accountType).child(childIdKey)
        
        ref.observe(.value, with: { snapshot in
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                var newMessage : JSQMessage!
                
                self.messages.removeAll()
                
                for snap in snapshots {
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        print(postDict)
                        
                        let date  = Date(timeIntervalSince1970: Double(truncating: postDict["timestamp"] as! NSNumber)/1000)
                        
                        newMessage = JSQMessage(senderId: postDict["id"] as? String, senderDisplayName: postDict["name"] as? String, date: date, text: postDict["msg"] as? String)
                        self.messages.append(newMessage)
                    }
                }
                
                self.finishReceivingMessage(animated: true)
                NetworkManager.sharedInstance.dismissLoader()
            }
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        ref.removeAllObservers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Collection view delegates and datasource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource {
        return messages[indexPath.item].senderId == self.senderId ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, avatarImageDataForItemAt indexPath: IndexPath) -> JSQMessageAvatarImageDataSource? {
        return JSQMessagesAvatarImageFactory.avatarImage(withPlaceholder: #imageLiteral(resourceName: "ic_profile"), diameter: 25)!
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        let message = messages[indexPath.item]
        
        // Displaying names above messages
        //Mark: Removing Sender Display Name
        /**
         *  Example on showing or removing senderDisplayName based on user settings.
         *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
         */
        if message.senderId == self.senderId {
            return nil
        }
        
        return NSAttributedString(string: message.senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        //return 17.0
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            return 0.0
        }else {
            return 17.0
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        if (indexPath.item % 3 == 0) {
            return 17.0
        }
        return 0.0
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        /**
         *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
         *  The other label text delegate methods should follow a similar pattern.
         *
         *  Show a timestamp for every 3rd message
         */
        if (indexPath.item % 3 == 0) {
            let message = self.messages[indexPath.item]
            
            return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
        }
        //
        return nil
    }
    
    //MARK:- Send Button Action
    override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
        /**
         *  Sending a message. Your implementation of this method should do *at least* the following:
         *
         *  1. Play sound (optional)
         *  2. Add new id<JSQMessageData> object to your data source
         *  3. Call `finishSendingMessage`
         */
        
        var dict = [String : Any]()
        
        dict["id"] = senderId
        dict["name"] = senderDisplayName
        
        dict["msg"] =  text
        dict["timestamp"] = ServerValue.timestamp()
        
        self.ref.childByAutoId().setValue(dict)
        self.finishSendingMessage()
    }
}
