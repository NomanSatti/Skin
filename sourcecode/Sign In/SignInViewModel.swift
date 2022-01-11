//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: SignInViewModel.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit

class SignInViewModel: NSObject {
    
    let defaults = UserDefaults.standard
    
    private var apiName: WhichApiCall = .checkoutAddress
    func callingHttppApi(dict: [String: Any], apiCall: WhichApiCall, completion: @escaping (Bool) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        
        var requstParams = [String: Any]()
        requstParams["storeId"] = Defaults.storeId
        requstParams["quoteId"] = Defaults.quoteId
        requstParams["token"] = Defaults.deviceToken
        requstParams["customerToken"] = Defaults.customerToken
        requstParams["websiteId"] = UrlParams.defaultWebsiteId
        requstParams["width"] = UrlParams.width
        if apiCall == .login {
            apiName = .login
            requstParams["username"] = dict["username"]
            requstParams["password"] = dict["password"]
        } else {
            apiName = .forgetPassword
            requstParams["email"] = dict["username"]
        }
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .post, apiname: apiName, currentView: UIViewController()) { [weak self] success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            if success == 1 {
                guard let dict = responseObject as? NSDictionary else {
                    ShowNotificationMessages.sharedInstance.warningView(message: "somethingwentwrong".localized)
                    return
                }
                let responseJSON = JSON(dict)
                if let storeId = responseJSON["storeId"].string, storeId != "0" {
                    self?.defaults.set(storeId, forKey: "storeId")
                }
                self?.doFurtherProcessingWithResult(data: responseJSON) { success in
                    completion(success)
                }
            } else if success == 2 {
                NetworkManager.sharedInstance.dismissLoader()
                self?.callingHttppApi(dict: dict, apiCall: apiCall) {success in
                    completion(success)
                }
            }
        }
    }
    
    func doFurtherProcessingWithResult(data: JSON, completion: (Bool) -> Void) {
        
        if apiName == .login {
            if data["success"].boolValue == true {
                Defaults.customerEmail = data["customerEmail"].stringValue
                Defaults.customerToken = data["customerToken"].stringValue
                Defaults.customerName = data["customerName"].stringValue
                Defaults.quoteId = ""
                Defaults.profilePicture = data["profileImage"].stringValue
                Defaults.profileBanner = data["bannerImage"].stringValue
                Defaults.cartBadge = data["cartCount"].stringValue
                
                if data["isAdmin"].intValue == 0 {
                    Defaults.isAdmin = false
                } else {
                    Defaults.isAdmin = true
                }
                if data["isSupplier"].intValue == 0 || data["isPending"].intValue == 1 {
                    Defaults.isSupplier = false
                } else {
                    Defaults.isSupplier = true
                }
                if data["isSeller"].intValue == 0 || data["isPending"].intValue == 1 {
                    Defaults.isSeller = false
                } else {
                    Defaults.isSeller = true
                }
                if data["isPending"].intValue == 0 {
                    self.defaults.set("false", forKey: Defaults.Key.isPending.rawValue)
                } else {
                    self.defaults.set("true", forKey: Defaults.Key.isPending.rawValue)
                }
                
                defaults.synchronize()
                completion(true)
            } else {
                ShowNotificationMessages.sharedInstance.warningView(message: data["message"].stringValue)
                completion(false)
            }
        } else {
            if data["success"].boolValue {
                ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: data["message"].stringValue)
            } else {
                ShowNotificationMessages.sharedInstance.warningView(message: data["message"].stringValue)
            }
            completion(true)
        }
    }
}
