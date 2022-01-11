//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: OrderReviewListProductViewModel.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit
class OrderReviewListProductViewModel: NSObject {
    
    var modelProductReviewData: OrderDetailsModel?
    var orderId: String?
    weak var moveDelegate: moveToControlller?
    func callingHttppApi(completion: @escaping (Bool) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        requstParams["storeId"] = Defaults.storeId
        requstParams["customerToken"] = Defaults.customerToken
        requstParams["websiteId"] = UrlParams.defaultWebsiteId
        requstParams["currency"] = Defaults.currency
        requstParams["incrementId"] = orderId
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .get, apiname: .orderDetails, currentView: UIViewController()) { [weak self] success, responseObject  in
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
        NetworkManager.sharedInstance.dismissLoader()
        modelProductReviewData = OrderDetailsModel(json: data)
        completion(true)
    }
}

extension OrderReviewListProductViewModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelProductReviewData?.orderData.itemList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: ReviewProductTableViewCell = tableView.dequeueReusableCell(with: ReviewProductTableViewCell.self, for: indexPath) {
            cell.item = modelProductReviewData?.orderData.itemList[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 113
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        moveDelegate?.moveController(id: modelProductReviewData?.orderData.itemList[indexPath.row].productId ?? "", name: modelProductReviewData?.orderData.itemList[indexPath.row].name ?? "", dict: ["image": modelProductReviewData?.orderData.itemList[indexPath.row].image ?? ""], jsonData: JSON.null, index: indexPath.row, controller: .none)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let  footerView = (Bundle.main.loadNibNamed("HeaderTitleView", owner: self, options: nil)?[0] as? HeaderTitleView) {
            footerView.headingLbl.text = "CHOOSE A PRODUCT TO REVIEW".localized
            footerView.headingLbl.textColor = UIColor.black
            footerView.headingLbl.font = UIFont.boldSystemFont(ofSize: 17.0)
            
            footerView.bottomView.isHidden = true
            return footerView
        }
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
