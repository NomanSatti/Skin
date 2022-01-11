//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: CheckoutAddressAndShippingViewModel.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit

class CheckoutAddressAndShippingViewModel: NSObject {
    
    var addressModel: CheckoutAddressModel!
    var shippingModel: CheckoutShippingModel!
    let getEtag: (String) -> String = {etagName in
        return DBManager.sharedInstance.geteTagFromDataBase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: etagName))
    }
    var shippingId = ""
    var addressId = ""
    var shippingDict = [String: Any]()
    var selectedRow = 0
    var obj: CheckoutAddressAndShippingViewController?
    var apiToCall: CheckoutAddressApi = .showAdress
    private var apiName: WhichApiCall = .checkoutAddress
    func callingHttppApi(completion: @escaping (Bool) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        requstParams["storeId"] = Defaults.storeId
        requstParams["customerToken"] = Defaults.customerToken
        requstParams["quoteId"] = Defaults.quoteId
        var etagName = ""
        switch apiToCall {
        case .showAdress:
            etagName = "checkoutAddressData"
            apiName = .checkoutAddress
            requstParams["eTag"] = getEtag(etagName)
        case .showShippingMethod:
            etagName = "checkoutShippingData"
            apiName = .checkoutShippping
            requstParams["shippingData"] = shippingDict.convertDictionaryToString()
            requstParams["eTag"] = getEtag(etagName)
        }
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .get, apiname: apiName, currentView: UIViewController()) { [weak self] success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            guard let self = self else { return }
            if success == 1 {                
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                if jsonResponse["success"].boolValue == true {
                    if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]) {
                        DBManager.sharedInstance.storeDataToDataBase(data: data, eTag: jsonResponse["eTag"].stringValue, hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: etagName))
                    }
                    
                    self.doFurtherProcessingWithResult(data: jsonResponse) { success in
                        completion(success)
                        
                    }
                } else {
                    if self.apiToCall == .showShippingMethod {
                        if self.shippingModel != nil {
                            self.shippingModel.shippingMethods.removeAll()
                        }
                        
                        
                        ShowNotificationMessages.sharedInstance.warningView(message: "No shipping method for this address".localized)
                    } else {
                        if jsonResponse["message"].stringValue.removeWhiteSpace.count > 0 {
                            ShowNotificationMessages.sharedInstance.warningView(message: jsonResponse["message"].stringValue)
                        } else {
                            ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
                        }
                    }
                    completion(true)
                    
                }
            } else if success == 2 {   // Retry in case of error
                NetworkManager.sharedInstance.dismissLoader()
                self.callingHttppApi {success in
                    completion(success)
                }
            } else if success == 3 {   // No Changes
                let jsonResponse =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "checkoutAddressData"))
                self.doFurtherProcessingWithResult(data: jsonResponse) { success in
                    completion(success)
                }
            }
        }
    }
    
    func doFurtherProcessingWithResult(data: JSON, completion: @escaping (Bool) -> Void) {
        switch apiToCall {
        case .showAdress:
            addressModel = CheckoutAddressModel(json: data)
            
            if addressModel.address.count > 0 {
                addressId = addressModel.address[selectedRow].id
                shippingDict["addressId"] = addressId
                shippingDict["newAddress"] = addressModel.address[selectedRow].newAddress
                shippingDict["sameAsShipping"] = "1"
                self.apiToCall = .showShippingMethod
                self.callingHttppApi {success in
                    completion(success)
                }
                completion(true)
            } else {
                completion(false)
            }
        case .showShippingMethod:
            NetworkManager.sharedInstance.dismissLoader()
            shippingModel = CheckoutShippingModel(json: data)
            if shippingModel.shippingMethods.count == 0 {
                ShowNotificationMessages.sharedInstance.warningView(message: "No shipping method for this address".localized)
            }
            if let shippingModel =  shippingModel {
                self.obj?.bottomView.isHidden = false
                self.obj?.priceLabel.text = shippingModel.cartTotal
            }
            completion(true)
        }
    }
}

extension CheckoutAddressAndShippingViewModel: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let addressModel = addressModel, addressModel.address.count > 0 {
            if let shippingModel = shippingModel, shippingModel.shippingMethods.count > 0 {
                return 2
            } else {
                return 1
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let addressModel = addressModel, addressModel.address.count > 0 {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cellType = ShippingAddressTableViewCell.self
            if let cell: ShippingAddressTableViewCell = tableView.dequeueReusableCell(with: cellType, for: indexPath) {
                cell.addressLabel.text = addressModel.address[selectedRow].value
                cell.addressId = addressModel.address[selectedRow].id
                if Defaults.customerToken == nil {
                    cell.arrowLabel.isHidden = true
                } else {
                    cell.arrowLabel.isHidden = false
                }
                cell.address = addressModel.address
                if addressModel.address[selectedRow].id == "0" {
                    cell.newAddressBtn.setTitle( " " + "Edit Address".localized, for: .normal)
                }
                cell.selectionStyle = .none
                return cell
            }
            //        case 2:
            //            let cellType = SelectionAddressTableViewCell.self
            //            if let cell: SelectionAddressTableViewCell = tableView.dequeueReusableCell(with: cellType, for: indexPath) {
            //                cell.selectionStyle = .none
            //                return cell
        //            }
        case 1:
            let cellType = ShippingMethodTableTableViewCell.self
            if let cell: ShippingMethodTableTableViewCell = tableView.dequeueReusableCell(with: cellType, for: indexPath) {
                cell.shippingMethod = shippingModel.shippingMethods
                cell.delegate = self
                cell.selectionStyle = .none
                return cell
            }
        default:
            return UITableViewCell()
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }
    
}

enum CheckoutAddressApi {
    case showAdress
    case showShippingMethod
}
//ShippingMethodTableTableViewCell

extension CheckoutAddressAndShippingViewModel: SendShippingId {
    func sendShippingId(shippingId: String) {
        self.shippingId = shippingId
    }
}
