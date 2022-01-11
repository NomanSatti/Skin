//
//  NotificationService.swift
//  NotificationService
//
//  Created by Work on 5/4/20.
//  Copyright © 2020 ranjit. All rights reserved.
//

import UserNotifications
 
class NotificationService: UNNotificationServiceExtension {
 
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        guard let bestAttemptContent = bestAttemptContent else {
            return
        }
        guard let attachmentUrlString = request.content.userInfo["banner_url"] as? String else {
            return
        }
        guard let url = URL(string: attachmentUrlString) else {
            return
        }
        
        URLSession.shared.downloadTask(with: url, completionHandler: { (optLocation: URL?, optResponse: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print("Download file error: \(String(describing: error))")
                return
            }
            guard let location = optLocation else {
                return
            }
            guard let response = optResponse else {
                return
            }
            
            do {
                let lastPathComponent = response.url?.lastPathComponent ?? ""
                var attachmentID = UUID.init().uuidString + lastPathComponent
                
                if response.suggestedFilename != nil {
                    attachmentID = UUID.init().uuidString + response.suggestedFilename!
                }
                
                let tempDict = NSTemporaryDirectory()
                let tempFilePath = tempDict + attachmentID
                
                try FileManager.default.moveItem(atPath: location.path, toPath: tempFilePath)
                let attachment = try UNNotificationAttachment.init(identifier: attachmentID, url: URL.init(fileURLWithPath: tempFilePath))
                
                bestAttemptContent.attachments.append(attachment)
            }
            catch {
                print("Download file error: \(String(describing: error))")
            }
            
            OperationQueue.main.addOperation({() -> Void in
                self.contentHandler?(bestAttemptContent);
            })
        }).resume()
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
 
}
@available(iOSApplicationExtension 10.0, *)
extension UNNotificationAttachment {
    
    static func saveImageToDisk(fileIdentifier: String, data: NSData, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let folderName = ProcessInfo.processInfo.globallyUniqueString
        let folderURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(folderName, isDirectory: true)
        
        do {
            try fileManager.createDirectory(at: folderURL!, withIntermediateDirectories: true, attributes: nil)
            let fileURL = folderURL?.appendingPathComponent(fileIdentifier)
            try data.write(to: fileURL!, options: [])
            let attachment = try UNNotificationAttachment(identifier: fileIdentifier, url: fileURL!, options: options)
            return attachment
        } catch let error {
            print("error \(error)")
        }
        
        return nil
    }
}
