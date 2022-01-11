//
//  ProfileViewModal.swift
//  Mobikul Single App
//
//  Created by akash on 19/01/19.
//  Copyright © 2019 kunal. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewModal: NSObject {
    
    var profileData = [[ProfileItem]]()
    weak var delegate: PerformProfileActions?
    
    func getUserProfileData(isLoggedIn: Bool, completion:(_ data: Bool) -> Void) {
        
        if isLoggedIn {
            var customerData = [ProfileItem]()
            //1
            customerData.append(ProfileItem(image: "profile-dashboard", title: "dashboard".localized, action: .dashboardViewController))
            
            //2
             customerData.append(ProfileItem(image: "profile-orders", title: "orders".localized, action: .myOrders))
            
            //3
              customerData.append(ProfileItem(image: "profile-address", title: "addressbook".localized, action: .addressBookListViewController))
            
            //4
               customerData.append(ProfileItem(image: "profile-info", title: "Account Information".localized, action: .accountInformation))
            
            //5
             customerData.append(ProfileItem(image: "profile-review", title: "Product Reviews".localized, action: .productReviewList))
            
            //6
             customerData.append(ProfileItem(image: "profile-download", title: "download".localized, action: .downloadViewController))
            
            profileData = [customerData]
           
        } else {
            var logoutProfileData = [ProfileItem]()
            logoutProfileData.append(ProfileItem(image: "profile-dashboard", title: "Signin".localized, action: AllControllers.signInController))
           
            logoutProfileData.append(ProfileItem(image: "profile-compare", title: "compare".localized, action: .compareListViewController))
            logoutProfileData.append(ProfileItem(image: "order-return", title: "Order and Returns".localized, action: .orderReturn))
            //logoutProfileData.append(ProfileItem(image: "profile-info", title: "Share App".localized, action: .none))
            profileData = [logoutProfileData]
            
        }
        completion(true)
    }
    
    func callingHttppApi(completion: @escaping (Bool) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        requstParams["storeId"] = Defaults.storeId
        requstParams["customerToken"] = Defaults.customerToken
        requstParams["token"] = Defaults.deviceToken
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .post, apiname: .signout, currentView: UIViewController()) { [weak self] success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            if success == 1 {                
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                if jsonResponse["success"].boolValue == true {
                    if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]) {
                        DBManager.sharedInstance.storeDataToDataBase(data: data, eTag: jsonResponse["eTag"].stringValue, hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "notificationData"))
                    }
                    
                    self?.doFurtherProcessingWithResult(data: jsonResponse) { success in
                        completion(success)
                    }
                } else {
                    if jsonResponse["message"].stringValue.removeWhiteSpace.count > 0 {
                        ShowNotificationMessages.sharedInstance.warningView(message: jsonResponse["message"].stringValue)
                    } else {
                        ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
                    }
                }
            } else if success == 2 {   // Retry in case of error
                NetworkManager.sharedInstance.dismissLoader()
                self?.callingHttppApi {success in
                    completion(success)
                    
                }
            }
        }
    }
    
    func doFurtherProcessingWithResult(data: JSON, completion: (Bool) -> Void) {
        for i in UserDefaults.standard.dictionaryRepresentation() {
            print(i.key)
            let customerToken = Defaults.customerToken
            if i.key == Defaults.Key.appleLanguages.rawValue || i.key == Defaults.Key.currency.rawValue || i.key == Defaults.Key.deviceToken.rawValue || i.key == Defaults.Key.language.rawValue || i.key == Defaults.Key.storeId.rawValue {
                print("ffs",i.key)
            } else {
                print(i.key)
                UserDefaults.standard.removeObject(forKey: i.key)
                UserDefaults.standard.synchronize()
            }
        }
        completion(true)
    }
    
    func callingDeleteTokenApi(completion: @escaping (Bool) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        requstParams["userId"] = Defaults.storeId
        requstParams["token"] = Defaults.deviceToken
        requstParams["accountType"] = "customer"
        requstParams["os"] = "ios"
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .post, apiname: .deleteChatToken, currentView: UIViewController()) { [weak self] success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            if success == 1 {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHome"), object: nil)
                completion(true)
            } else if success == 2 {   // Retry in case of error
                NetworkManager.sharedInstance.dismissLoader()
                self?.callingHttppApi {success in
                    completion(success)
                }
            }
        }
    }
}

extension ProfileViewModal: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return profileData.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.font = UIFont.myBoldSystemFont(ofSize: 17)
        cell.backgroundColor = .white
        if section == 0 {
            if Defaults.customerToken != nil {
                cell.textLabel?.text = "Customer Profile".localized.uppercased()
            } else {
                cell.textLabel?.text = ""
            }
        } else {
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && Defaults.customerToken == nil {
            return 0
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: ProfileCell = tableView.dequeueReusableCell(with: ProfileCell.self, for: indexPath) {
            cell.item = profileData[indexPath.section][indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if profileData.count < section {
            return 8
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.performProfileActions(action: profileData[indexPath.section][indexPath.row].action, title: profileData[indexPath.section][indexPath.row].title)
    }
    
}

protocol PerformProfileActions: NSObjectProtocol {
    func performProfileActions(action: AllControllers, title: String)
}
