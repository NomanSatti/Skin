//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: DownloadOrderViewModel.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit
import MobileCoreServices

class DownloadOrderViewModel: NSObject {
    
    var model: DowlodableDataList!
    var hashVal: String!
    var download = false
    var pageNumber = 1
    var callBackPagination: (()->Void)?
    func callingHttppApi(completion: @escaping (Bool) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        requstParams["storeId"] = Defaults.storeId
        requstParams["width"] = UrlParams.width
        requstParams["quoteId"] = Defaults.quoteId
        requstParams["customerToken"] = Defaults.customerToken
        
        var apiName: WhichApiCall = .downloadProductList
        if download {
            requstParams["hash"] = hashVal
            apiName = .downloadProduct
        } else {
            requstParams["pageNumber"] = pageNumber
            requstParams["eTag"] = DBManager.sharedInstance.geteTagFromDataBase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "downloadProductData"))
            apiName = .downloadProductList
        }
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .get, apiname: apiName, currentView: UIViewController()) { [weak self] success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            if success == 1 {                
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                if jsonResponse["success"].boolValue == true {
                    if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]) {
                        DBManager.sharedInstance.storeDataToDataBase(data: data, eTag: jsonResponse["eTag"].stringValue, hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "downloadProductData"))
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
                let jsonResponse =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "downloadProductData"))
                print(jsonResponse)
                self?.doFurtherProcessingWithResult(data: jsonResponse) { success in
                    completion(success)
                }
                
            }
        }
    }
    
    func doFurtherProcessingWithResult(data: JSON, completion: (Bool) -> Void) {
        if download {
            if data["url"] != JSON.null {
                let mimeType: CFString = data["mimeType"].stringValue as CFString
                guard
                    let mimeUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType, nil)?.takeUnretainedValue()
                    else { return }
                
                guard
                    let extUTI = UTTypeCopyPreferredTagWithClass(mimeUTI, kUTTagClassFilenameExtension)
                    else { return }
                print(mimeUTI)
                print(extUTI.takeRetainedValue() as String)
                let ext = "." + (extUTI.takeRetainedValue() as String)
                var savedFileName = ""
                if data["fileName"].stringValue.contains(ext) {
                    savedFileName = data["fileName"].stringValue
                } else {
                    savedFileName = data["fileName"].stringValue + "." + (extUTI.takeRetainedValue() as String)
                }
                print(savedFileName)
                NetworkManager.sharedInstance.download(downloadUrl: data["url"].stringValue, saveUrl: savedFileName, completion: { (_, results) in
                    print("Success post title:", results)
                })
            }
        } else {
             
             if pageNumber == 1 {
                model = DowlodableDataList(json: data)
                completion(true)
            } else {
                let modelData = DowlodableDataList(json: data)
                model.message = modelData.message
                model.totalCount = modelData.totalCount
                model.eTag = modelData.eTag
                model.success = modelData.success
                model.downloadsList += (modelData.downloadsList)
                completion(true)
            }
        }
        
    }
}
extension DownloadOrderViewModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.downloadsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: DownloadProductListTableViewCell = tableView.dequeueReusableCell(with: DownloadProductListTableViewCell.self, for: indexPath) {
            cell.item = model.downloadsList[indexPath.row]
            cell.selectionStyle = .none
            cell.downloadBtn.addTapGestureRecognizer {
                self.download = true
                self.hashVal = self.model.downloadsList[indexPath.row].hash
                self.callingHttppApi { _ in
                    
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? DownloadProductListTableViewCell {
            let viewController = OrderDetailsDataViewController.instantiate(fromAppStoryboard: .customer)
            viewController.orderId = self.model.downloadsList[indexPath.row].incrementId
            let nav = UINavigationController(rootViewController: viewController)
            //nav.navigationBar.tintColor = AppStaticColors.accentColor
            nav.modalPresentationStyle = .fullScreen
            cell.viewContainingController?.present(nav, animated: true, completion: nil)
        }
    }
   func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if (indexPath.row == (model.downloadsList.count ) - 1) && ((model.downloadsList.count ) < model.totalCount ?? 0) {
            pageNumber += 1
            callBackPagination?()
        }
    }
}
