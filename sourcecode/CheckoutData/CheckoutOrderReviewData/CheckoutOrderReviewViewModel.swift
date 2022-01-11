//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: CheckoutOrderReview.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit
import Alamofire

class CheckoutOrderReviewViewModel: NSObject {
    
    var shippingMethod: String!
    var model: OrderReviewModel!
    var isVirtual: Bool!
    var totalSections = 0
    var paymentMethod: PaymentMethods?
    var billingAvailable = false
    weak var tableView: UITableView!
    var selectedRow = 0
    var addressId = ""
    var address = [Address]()
    var apicall = ""
    private var whichApiCall: WhichApiCall = .checkoutAddress
    private  var cartCoupon: String?
    
    func callingHttppApi(completion: @escaping (Bool) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        var apiName: WhichApiCall = .checkoutAddress
        var verbs: HTTPMethod = .get
        switch whichApiCall {
        case .checkoutAddress:
            if apicall == "isVirtual" {
                apiName = .checkoutAddress
                verbs = .get
            } else {
                requstParams["width"] = UrlParams.width
                requstParams["method"] = "customer"
                requstParams["shippingMethod"] = shippingMethod
                apiName = .checkoutOrderReview
                verbs = .post
            }
        case .couponForCart:
            apiName = .couponForCart
            requstParams["couponCode"] = cartCoupon
            requstParams["fromApp"] = "1"
            verbs = . post
        case .removeCoupon:
            apiName = .couponForCart
            requstParams["couponCode"] = cartCoupon
            requstParams["removeCoupon"] = "1"
            requstParams["fromApp"] = "1"
            verbs = . post
        default:
            break;
        }
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: verbs, apiname: apiName, currentView: UIViewController()) { [weak self] success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            if success == 1 {                
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                if jsonResponse["success"].boolValue == true {
                    if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]), self?.whichApiCall == .checkoutAddress {
                        DBManager.sharedInstance.storeDataToDataBase(data: data, eTag: jsonResponse["eTag"].stringValue, hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "checkoutOrderReview"))
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
                let jsonResponse =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "checkoutOrderReview"))
                self?.doFurtherProcessingWithResult(data: jsonResponse) { success in
                    completion(success)
                }
                
            }
        }
    }
    
    func doFurtherProcessingWithResult(data: JSON, completion: @escaping (Bool) -> Void) {
        switch whichApiCall {
        case .couponForCart,.removeCoupon:
            if data["success"].boolValue {
                ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: data["message"].stringValue)
                self.whichApiCall = .checkoutAddress
                self.callingHttppApi {success in
                    completion(success)
                }
            }else{
                ShowNotificationMessages.sharedInstance.warningView(message: data["message"].stringValue)
            }
        case .checkoutAddress:
            if apicall == "isVirtual" {
                let  addressModel = CheckoutAddressModel(json: data)
                if addressModel.address.count > 0 {
                    addressId = addressModel.address[selectedRow].id
                    address = addressModel.address
                    apicall = ""
                    self.callingHttppApi {success in
                        completion(success)
                    }
                    
                } else {
                    apicall = ""
                    self.callingHttppApi {success in
                        completion(success)
                    }
                }
            } else {
                model = OrderReviewModel(json: data)
                totalSections = 7
                completion(true)
            }
        default:
            break
        }
    }
}

extension CheckoutOrderReviewViewModel: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return totalSections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if isVirtual {
                return 0
            } else {
                return 1
            }
        case 1:
            if isVirtual {
                return 1
            } else {
                return billingAvailable ? 1 : 0
            }
        case 2:
            if isVirtual {
                return 0
            } else {
                return 1
            }
            
        default:
            return 1
        }
        
    }
    
    func applyCoupon() {
        if let cartCoupon = cartCoupon, cartCoupon.count > 0 {
            self.whichApiCall = .couponForCart
            self.callingHttppApi {success in
                self.model.couponCode = self.cartCoupon
                self.tableView.reloadData()
            }
        } else {
            ShowNotificationMessages.sharedInstance.warningView(message: "Enter CouponCode".localized)
        }
    }
    
    func deleteCoupon() {
        self.whichApiCall = .removeCoupon
        self.callingHttppApi {success in
            self.model.couponCode = nil
            self.tableView.reloadData()
        }
    }
    
    @objc func switchValueDidChange(_ sender: UISwitch) {
        if sender.isOn {
            billingAvailable = false
        } else {
            billingAvailable = true
        }
        tableView?.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell: SelectionAddressTableViewCell = tableView.dequeueReusableCell(with: SelectionAddressTableViewCell.self, for: indexPath) {
                cell.selectionStyle = .none
                cell.billingSwitch.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
                return cell
            }
        case 1:
            if (address.count > 0) {
                let cellType = ShippingAddressTableViewCell.self
                if let cell: ShippingAddressTableViewCell = tableView.dequeueReusableCell(with: cellType, for: indexPath) {
                    cell.addressLabel.text = address[selectedRow].value
                    cell.addressId = address[selectedRow].id
                    addressId = address[selectedRow].id
                    cell.shippingAddressLabel.text = "Billing Adddress".localized
                    cell.arrowLabel.isHidden = true
                    cell.address = address
                    if address[selectedRow].id == "0" {
                        cell.newAddressBtn.setTitle( " " + "Edit Address".localized, for: .normal)
                    }
                    cell.selectionStyle = .none
                    return cell
                }
            } else {
                let cellType = CheckoutNewAddressTableViewCell.self
                if let cell: CheckoutNewAddressTableViewCell = tableView.dequeueReusableCell(with: cellType, for: indexPath) {
                    cell.shippingAddressLabel.text = "Billing Adddress".localized
                    cell.selectionStyle = .none
                    return cell
                }
            }
        case 2:
            if let cell: OrderReviewShippingTableViewCell = tableView.dequeueReusableCell(with: OrderReviewShippingTableViewCell.self, for: indexPath) {
                cell.shippingMethodValue.text = model.shippingMethod
                cell.shippingAddressValue.text = model.shippingAddress?.html2String
                cell.selectionStyle = .none
                return cell
            }
        case 3:
            if let cell: OrderReviewProductsTableViewCell = tableView.dequeueReusableCell(with: OrderReviewProductsTableViewCell.self, for: indexPath) {
                cell.selectionStyle = .none
                cell.item = model.orderReviewData?.orderReviewProducts
                return cell
            }
        case 4:
            if let cell: CartVoucherTableViewCell = tableView.dequeueReusableCell(with: CartVoucherTableViewCell.self, for: indexPath) {
                cell.selectionStyle = .none
                cell.arrowBtn.image = nil
                 cell.bottomView.isHidden = false
                    cell.bottomViewHeight.constant = 88
                if let couponCode = model.couponCode, couponCode != "" {
                    cell.textField.text = couponCode
                    cell.textField.isUserInteractionEnabled = false
                    cell.applyBtn.setTitle("Remove".localized, for: .normal)
                    cell.applyBtn.addTapGestureRecognizer {
                        self.cartCoupon = cell.textField.text
                        self.deleteCoupon()
                    }
                } else {
                    cell.textField.text = ""
                    cell.applyBtn.setTitle("Apply".localized, for: .normal)
                    cell.textField.isUserInteractionEnabled = true
                    cell.applyBtn.addTapGestureRecognizer {
                        self.cartCoupon = cell.textField.text
                        self.applyCoupon()
                    }
                }
                return cell
            }
        case 5:
            if let cell: PaymentMethodTableViewCell = tableView.dequeueReusableCell(with: PaymentMethodTableViewCell.self, for: indexPath) {
                cell.selectionStyle = .none
                cell.delegate = self
                cell.paymentMethod = model.paymentMethods
                return cell
            }
        case 6:
            if let cell: CartPriceTableViewCell = tableView.dequeueReusableCell(with: CartPriceTableViewCell.self, for: indexPath) {
                cell.selectionStyle = .none
                cell.dropIcon.isHidden = true
                cell.item = model.orderReviewData?.totals
                cell.orderTotalPrice.text = model.cartTotal
                cell.tableViewHeight.constant = CGFloat(cell.totalsData.count * 44)
                return cell
            }
        default:
            break
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
}

extension CheckoutOrderReviewViewModel: SendPaymentId {
    func sendPaymentId(paymentData: PaymentMethods) {
        self.paymentMethod = paymentData
    }
}
