//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: CompareListViewModel.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit
import Alamofire

class CompareListViewModel: NSObject {
    
    enum CompareListApi {
        case compareListData
        case addToCart
        case removeItem
        case addToWishlist
        case removeFromWishlist
    }
    
    var obj: CompareListViewController?
    var compareListDataModel: CompareListDataModel!
    var apiToCall: CompareListApi = .compareListData
    private var apiName: WhichApiCall = .compareList
    
    weak var delegate: MoveController?
    var productId: String = ""
    var wishlistItemId: String = ""
    
    //return maximum height of an attribute
    func getMaxHeightCell(values: [String]) -> CGFloat {
        var height: CGFloat = 50.0
        
        for i in 0 ..< values.count {
            let valueStr = values[i].html2String
            let actualHeight = valueStr.height(withConstrainedWidth: UIScreen.main.bounds.size.width/2 - 32, font: UIFont.systemFont(ofSize: 12.0))
            if actualHeight > height {
                height = actualHeight
            }
        }
        
        return (height + 40 )
    }
}

// MARK: - API Call
extension CompareListViewModel {
    
    func callingHttppApi(completion: @escaping (Bool, JSON) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        requstParams["storeId"] = Defaults.storeId
        requstParams["customerToken"] = Defaults.customerToken
        
        var requestType = HTTPMethod.get
        var etagName = ""
        switch apiToCall {
        case .compareListData:
            requstParams["quoteId"] = Defaults.quoteId
            etagName = "compareListData"
            requestType = .get
            apiName = .compareList
        //            requstParams["eTag"] = DBManager.sharedInstance.geteTagFromDataBase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: etagName))
        case .addToCart:
            requstParams["quoteId"] = Defaults.quoteId
            requstParams["currency"] = Defaults.currency
            requstParams["qty"] = "1"
            requstParams["productId"] = productId
            requestType = .post
            apiName = .addToCart
        case .removeItem:
            requstParams["productId"] = self.productId
            requstParams["currency"] = Defaults.currency
            requestType = .delete
            apiName = .removeFromCompare
        case .addToWishlist:
            requstParams["productId"] = productId
            requestType = .post
            apiName = .addToWishList
        case .removeFromWishlist:
            requstParams["itemId"] = wishlistItemId
            requestType = .delete
            apiName = .removeFromWishList
        }
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: requestType, apiname: apiName, currentView: UIViewController()) { [weak self] success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            guard let self = self else { return }
            if success == 1 {               
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                if jsonResponse["success"].boolValue == true {
                    if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]) {
                        DBManager.sharedInstance.storeDataToDataBase(data: data, eTag: jsonResponse["eTag"].stringValue, hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: etagName))
                    }
                    self.doFurtherProcessingWithResult(data: jsonResponse) { success in
                        completion(success, jsonResponse)
                    }
                } else {
                    if jsonResponse["message"].stringValue.removeWhiteSpace.count > 0 {
                        ShowNotificationMessages.sharedInstance.warningView(message: jsonResponse["message"].stringValue)
                        if self.apiToCall  == .addToCart {
                            self.delegate?.moveController(id: self.productId, name: "", dict: [:], jsonData: "", type: "", controller: .productPage)
                        }
                    } else {
                        ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
                    }
                }
            } else if success == 2 {   // Retry in case of error
                NetworkManager.sharedInstance.dismissLoader()
                self.callingHttppApi {success,jsonResponse  in
                    completion(success,jsonResponse)
                }
            } else if success == 3 {   // No Changes
                let jsonResponse =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "checkoutAddressData"))
                self.doFurtherProcessingWithResult(data: jsonResponse) { success in
                    completion(success,jsonResponse)
                }
            }
        }
    }
    
    func doFurtherProcessingWithResult(data: JSON, completion: @escaping (Bool) -> Void) {
        switch apiToCall {
        case .compareListData:
            compareListDataModel = nil
            compareListDataModel = CompareListDataModel(json: data)
            
            completion(true)
        case .addToCart:
            Defaults.cartBadge = data["cartCount"].stringValue
            Defaults.quoteId = data["quoteId"].stringValue
            completion(true)
        case .removeItem:
            apiToCall = .compareListData
            obj?.hitRequest()
        case .addToWishlist:
            
            //            obj?.compareTblView.reloadSections(IndexSet(integer: 0), with: .none)
            //             obj?.compareTblView.reloadData()
            completion(true)
        case .removeFromWishlist:
            //            obj?.compareTblView.reloadSections(IndexSet(integer: 0), with: .none)
            //            obj?.compareTblView.reloadData()
            completion(true)
        }
    }
}

// MARK: - UITableView
extension CompareListViewModel: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if compareListDataModel != nil {
            if let count = compareListDataModel.attributeValueList?.count {
                return count + 1
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 32
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = Bundle.main.loadNibNamed("CompareTblHeaderView", owner: self, options: nil)?[0] as? UIView {
            if let title = headerView.viewWithTag(11) as? UILabel {
                if section == 0 {
                    title.text = ""
                } else {
                    title.text = compareListDataModel.attributeValueList?[section - 1].attributeName
                }
            }
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 320
        } else {
            return getMaxHeightCell(values: compareListDataModel.attributeValueList?[indexPath.section - 1].value ?? [""])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: CompareCollectionTableViewCell.identifier, for: indexPath) as? CompareCollectionTableViewCell {
                cell.obj = self
                cell.isProduct = true
                cell.compareListDataModel = compareListDataModel
                cell.compareCollView.tag = (indexPath.section + 1) * 100
                cell.productData = compareListDataModel.productList
                cell.delegate = self
                //                compareVC.compareTblViewHeight.constant = tableView.contentSize.height
                cell.compareCollView.reloadData()
                cell.layoutIfNeeded()
                cell.layoutSubviews()
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: CompareCollectionTableViewCell.identifier, for: indexPath) as? CompareCollectionTableViewCell {
                cell.isProduct = false
                cell.obj = self
                cell.compareListDataModel = compareListDataModel
                cell.sectionIndex = indexPath.section - 1
                cell.compareCollView.tag = (indexPath.section + 1) * 100
                if let data = compareListDataModel.attributeValueList {
                    cell.attributeData = data
                }
                cell.delegate = self
                //                compareVC.compareTblViewHeight.constant = tableView.contentSize.height
                cell.compareCollView.reloadData()
                return cell
            }
        }
        
        return UITableViewCell()
    }
}

extension CompareListViewModel: MoveController {
    func moveController(id: String, name: String, dict: [String: Any], jsonData: JSON, type: String, controller: AllControllers) {
        
        switch controller {
        case .removeCompare:
            productId = id
            apiToCall = .removeItem
            callingHttppApi { success,jsonResponse  in
                if success {
                    self.apiToCall = .compareListData
                    self.obj?.hitRequest()
                    //                    self.callingHttppApi { success in
                    //                        if success {
                    //                            self.delegate?.moveController(id: "", name: "", dict: [:], jsonData: JSON.null, type: "", controller: .reloadTableView)
                    ////                            ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: "Added to Cart".localized)
                    //                        } else {
                    //                            ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
                    //                        }
                    //                    }
                    //                    self.compareListDataModel.productList.remove(at: dict["index"] as? Int ?? 0)
                    //                    self.compareListDataModel.removeItemAttributesValue(index: dict["index"] as? Int ?? 0)
                } else {
                    ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
                }
            }
        case .addToCart:
            if let isAvailable = dict["isAvailable"] as? Bool, isAvailable {
                if let hasOptions = dict["hasRequiredOptions"] as? Bool {
                    if hasOptions {
                        //move to product page
                        //product page is not designed
                        self.delegate?.moveController(id: "", name: "", dict: dict, jsonData: JSON.null, type: "", controller: .productPage)
                    } else {
                        productId = dict["entityId"] as? String ?? ""
                        apiToCall = .addToCart
                        callingHttppApi { success,jsonResponse  in
                            if success {
                                ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: "Added to Cart".localized)
                            } else {
                                ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
                            }
                        }
                    }
                }
            } else {
                ShowNotificationMessages.sharedInstance.warningView(message: "Product is out of stock".localized)
                //show errror not available
            }
        default:
            print("no match found")
        }
    }
}
