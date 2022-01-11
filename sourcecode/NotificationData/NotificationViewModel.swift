//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: NotificationViewModel.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit

class NotificationViewModel: NSObject {
    
    var model: NotificationData!
    
    func callingHttppApi(completion: @escaping (Bool) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        requstParams["storeId"] = Defaults.storeId
        requstParams["width"] = UrlParams.width
        requstParams["quoteId"] = Defaults.quoteId
        
        requstParams["eTag"] = DBManager.sharedInstance.geteTagFromDataBase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "notificationData"))
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .get, apiname: .notificationList, currentView: UIViewController()) { [weak self] success, responseObject  in
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
            } else if success == 3 {   // No Changes
                let jsonResponse =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "notificationData"))
                self?.doFurtherProcessingWithResult(data: jsonResponse) { success in
                    completion(success)
                }
                
            }
        }
    }
    
    func doFurtherProcessingWithResult(data: JSON, completion: (Bool) -> Void) {
        model = NotificationData(json: data)
        completion(true)
    }
    
}

extension NotificationViewModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.notificationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: NotificationDataTableViewCell = tableView.dequeueReusableCell(with: NotificationDataTableViewCell.self, for: indexPath) {
            cell.item = model.notificationList[indexPath.row]
            cell.notificationImage.addTapGestureRecognizer {
                if self.model.notificationList[indexPath.row].notificationType == "product" {
                    let nextController = ProductPageDataViewController.instantiate(fromAppStoryboard: .product)
                    nextController.productId = self.model.notificationList[indexPath.row].productId
                    nextController.productName =  self.model.notificationList[indexPath.row].productName
                    cell.viewContainingController?.navigationController?.pushViewController(nextController, animated: true)
                } else if self.model.notificationList[indexPath.row].notificationType == "category" {
                    let nextController = CategoryProductsViewController.instantiate(fromAppStoryboard: .product)
                    nextController.categoryId = self.model.notificationList[indexPath.row].categoryId
                    nextController.titleName = self.model.notificationList[indexPath.row].categoryName
                    nextController.categoryType = ""
                    //            nextController.categories = self.homeViewModel.categories
                    cell.viewContainingController?.navigationController?.pushViewController(nextController, animated: true)
                } else if self.model.notificationList[indexPath.row].notificationType == "custom" {
                    let nextController = CategoryProductsViewController.instantiate(fromAppStoryboard: .product)
                    nextController.categoryId = self.model.notificationList[indexPath.row].id
                    nextController.titleName = self.model.notificationList[indexPath.row].title
                    nextController.categoryType = "custom"
                    //            nextController.categories = self.homeViewModel.categories
                    cell.viewContainingController?.navigationController?.pushViewController(nextController, animated: true)
                }
                
            }
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AppDimensions.screenHeight/2 - 60
    }
}
