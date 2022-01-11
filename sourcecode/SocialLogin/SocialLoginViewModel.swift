//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: SocialLoginViewModel.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit

class SocialLoginviewModel: NSObject {
    
    let defaults = UserDefaults.standard
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0...length-1).map{ _ in letters.randomElement()! })
    }
    
    func callingHttppApi(dict: [String: Any], completion: @escaping (Bool) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        
        var requstParams = [String: Any]()
        requstParams["storeId"] = Defaults.storeId
        requstParams["quoteId"] = Defaults.quoteId
        requstParams["token"] = Defaults.deviceToken
        requstParams["customerToken"] = Defaults.customerToken
        requstParams["websiteId"] = UrlParams.defaultWebsiteId
        requstParams["firstName"] = dict["name"]
        requstParams["lastName"] = dict["name"]
        requstParams["email"] = dict["email"] ?? "test12345@gmail.com"
        requstParams["isSocial"] = "1"
        requstParams["pictureURL"] = dict["pictureURL"]
        requstParams["password"] = "".random(length: 10)
        requstParams["becomeSeller"] = "0"
        requstParams["width"] = UrlParams.width
        requstParams["eTag"] = DBManager.sharedInstance.geteTagFromDataBase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "SocialLoginViewController"))
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .post, apiname: .createAccount, currentView: UIViewController()) { [weak self] success, responseObject  in
            if success == 1 {                
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                if jsonResponse["success"].boolValue == true {
                    if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]) {
                        ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: jsonResponse["message"].stringValue)
                        DBManager.sharedInstance.storeDataToDataBase(data: data, eTag: jsonResponse["eTag"].stringValue, hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "SocialLoginViewController"))
                        Defaults.profilePicture = requstParams["pictureURL"] as? String
                    }
                    
                    self?.doFurtherProcessingWithResult(data: jsonResponse) { success in
                        completion(success)
                    }
                } else {
                    if jsonResponse["message"].stringValue.removeWhiteSpace.count == 0 {
                        ShowNotificationMessages.sharedInstance.warningView(message: jsonResponse["message"].stringValue)
                    } else {
                        ShowNotificationMessages.sharedInstance.warningView(message: jsonResponse["message"].stringValue)
                    }
                    completion(false)
                }
            } else if success == 2 {   // Retry in case of error
                NetworkManager.sharedInstance.dismissLoader()
                self?.callingHttppApi(dict: dict) {success in
                    completion(success)
                }
            } else if success == 3 {   // No Changes
                let jsonResponse =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "SocialLoginViewController"))
                self?.doFurtherProcessingWithResult(data: jsonResponse) { success in
                    completion(success)
                }
            }
        }
    }
    
    func doFurtherProcessingWithResult(data: JSON, completion: (Bool) -> Void) {
        //model = NotificationData(json: data)
        self.defaults.set(data["customerEmail"].stringValue, forKey: Defaults.Key.customerName.rawValue)
        self.defaults.set(data["customerToken"].stringValue, forKey: Defaults.Key.customerToken.rawValue)
        self.defaults.set(data["customerName"].stringValue, forKey: Defaults.Key.customerName.rawValue)
        
        if self.defaults.object(forKey: Defaults.quoteId) != nil {
            self.defaults.set(nil, forKey: Defaults.quoteId)
            self.defaults.synchronize()
        }
        //UserDefaults.standard.removeObject(forKey: "quoteId")
        if let profileImage = data["profileImage"].string {
            self.defaults.set(profileImage, forKey: (Defaults.Key.profilePicture.rawValue))
        }
        if let bannerImage  = data["bannerImage"].string {
            self.defaults.set(bannerImage, forKey: Defaults.Key.profileBanner.rawValue)
        }
        //            if data["cartCount"].intValue > 0 {
        //                let cartCount  = data["cartCount"].stringValue
        //                if cartCount != ""{
        //                    self.tabBarController!.tabBar.items?[2].badgeValue = cartCount
        //                }
        //            }
        if data["isAdmin"].intValue == 0 {
            //self.defaults.set("false", forKey: Defaults.Key.isAdmin.rawValue)
            Defaults.isAdmin = false
        } else {
            //self.defaults.set("true", forKey: Defaults.Key.isAdmin.rawValue)
            Defaults.isAdmin = true
        }
        if data["isSeller"].intValue == 0 {
            self.defaults.set("false", forKey: Defaults.Key.isSeller.rawValue)
        } else {
            self.defaults.set("true", forKey: Defaults.Key.isSeller.rawValue)
        }
        if data["isPending"].intValue == 0 {
            self.defaults.set("false", forKey: Defaults.Key.isPending.rawValue)
            
        } else {
            self.defaults.set("true", forKey: Defaults.Key.isPending.rawValue)
        }
        self.defaults.synchronize()
        ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: data["message"].stringValue)
        completion(true)
    }
    
}
