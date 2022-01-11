//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: ProductReviewListViewModel.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit

class ProductReviewListViewModel: NSObject {
    
    var model: CustomerReviewData!
    weak var obj: ProductReviewListViewController?
    var pageNumber = 1
    var callBackPagination: (()-> Void)?
    func callingHttppApi(completion: @escaping (Bool) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        requstParams["storeId"] = Defaults.storeId
        requstParams["width"] = UrlParams.width
        requstParams["quoteId"] = Defaults.quoteId
        requstParams["customerToken"] = Defaults.customerToken
        requstParams["pageNumber"] = pageNumber
        requstParams["eTag"] = DBManager.sharedInstance.geteTagFromDataBase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "ProductReviewList"))
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .get, apiname: .customerReviewList, currentView: UIViewController()) { [weak self] success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            if success == 1 {                
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                if jsonResponse["success"].boolValue == true {
                    if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]) {
                        DBManager.sharedInstance.storeDataToDataBase(data: data, eTag: jsonResponse["eTag"].stringValue, hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "ProductReviewList"))
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
                let jsonResponse =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "ProductReviewList"))
                self?.doFurtherProcessingWithResult(data: jsonResponse) { success in
                    completion(success)
                }
                
            }
        }
    }
    
    func doFurtherProcessingWithResult(data: JSON, completion: (Bool) -> Void) {
        if pageNumber == 1 {
            model = CustomerReviewData(json: data)
            completion(true)
        } else {
            let modelData = CustomerReviewData(json: data)
            model.message = modelData.message
            model.totalCount = modelData.totalCount
            model.eTag = modelData.eTag
            model.success = modelData.success
            model.reviewList += (modelData.reviewList)
            completion(true)
        }
        
    }
    
}

extension ProductReviewListViewModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.reviewList.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if let cell: DashboardReviewTableViewCell = tableView.dequeueReusableCell(with: DashboardReviewTableViewCell.self, for: indexPath) {
                cell.item = model.reviewList[indexPath.row]
                cell.selectionStyle = .none
                return cell
            }
            return UITableViewCell()
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let viewController = ProductReviewDetailDataViewController.instantiate(fromAppStoryboard: .customer)
            viewController.data = model.reviewList[indexPath.row]
            obj?.navigationController?.pushViewController(viewController, animated: true)
        }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == (model.reviewList.count ) - 1) && ((model.reviewList.count ) < model.totalCount ?? 0) {
            pageNumber += 1
            callBackPagination?()
        }
    }
}
