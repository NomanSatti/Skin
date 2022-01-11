//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: DashboardView.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit
import Alamofire

class DashboardViewModel: NSObject {
    var apiToCall: Calls = .address
    private var apiName: WhichApiCall = .addressBook
    var stepCall = 0
    private var orderId = ""
    var addressDaatArray = [AddressData]()
    var myOrderCollectionModel = [OrderListDataStruct]()
    var reviewModel: CustomerReviewData!
    weak var moveDelegate: DashboardMoveDelegate?
    let getEtag: (String) -> String = {etagName in
        return DBManager.sharedInstance.geteTagFromDataBase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: etagName))
    }
    
    enum Calls {
        case address
        case order
        case review
        case reOrder
    }
    
    let group = DispatchGroup()
    
    func networkCalls(completion: @escaping (Bool) -> Void) {
        
        group.enter()
        self.apiToCall = .address
        self.callingHttppApi { [weak self] jsonData in
            guard let self = self else { return }
            if let data = AddressBookModel(data: jsonData) {
                self.addressDaatArray = data.addressDaatArray
            }
            self.group.leave()
            completion(true)
        }
        
        group.enter()
        self.apiToCall = .order
        self.callingHttppApi { [weak self] jsonData in
            NetworkManager.sharedInstance.dismissLoader()
            guard let self = self else { return }
            if let  model = OrderListModel(data: jsonData) {
                self.myOrderCollectionModel = model.orderListData
            }
            completion(true)
            self.group.leave()
        }
        
        group.enter()
        self.apiToCall = .review
        self.callingHttppApi { [weak self] jsonData in
            print(jsonData)
            guard let self = self else { return }
            self.reviewModel = CustomerReviewData(json: jsonData)
            completion(true)
            self.group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {
            print("completed")
        }
        
    }
    
    func callingHttppApi(completion: @escaping (JSON) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        requstParams["storeId"] = Defaults.storeId
        requstParams["customerToken"] = Defaults.customerToken
        requstParams["quoteId"] = Defaults.quoteId
        var etagName = ""
        var verbs: HTTPMethod = .get
        switch apiToCall {
        case .address:
            etagName = "dashboardAddressBook"
            apiName = .addressBook
            requstParams["eTag"] = getEtag(etagName)
            requstParams["forDashboard"] = true
        case .order:
            etagName = "dashboardOrderData"
            apiName = .orderList
            //            requstParams["shippingData"] = shippingDict.convertDictionaryToString()
            requstParams["eTag"] = getEtag(etagName)
            requstParams["forDashboard"] = true
        case .review:
            etagName = "dashboardCustomerReview"
            apiName = .customerReviewList
            //            requstParams["shippingData"] = shippingDict.convertDictionaryToString()
            requstParams["eTag"] = getEtag(etagName)
            requstParams["forDashboard"] = true
        case .reOrder:
            requstParams["incrementId"] = orderId
            apiName = .reorder
            verbs = .post
        }
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: verbs, apiname: apiName, currentView: UIViewController()) { [weak self] success, responseObject  in
            guard let self = self else { return }
            if success == 1 {                
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                if jsonResponse["success"].boolValue == true {
                    if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]) {
                        DBManager.sharedInstance.storeDataToDataBase(data: data, eTag: jsonResponse["eTag"].stringValue, hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: etagName))
                    }
                    completion(jsonResponse)
                    
                } else {
                    if jsonResponse["message"].stringValue.removeWhiteSpace.count > 0 {
                        ShowNotificationMessages.sharedInstance.warningView(message: jsonResponse["message"].stringValue)
                    } else {
                        ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
                    }
                }
            } else if success == 2 {   // Retry in case of error
                NetworkManager.sharedInstance.dismissLoader()
                self.callingHttppApi { _ in
                }
            } else if success == 3 {   // No Changes
                let jsonResponse =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: etagName))
                completion(jsonResponse)
            }
        }
    }
    
}

extension DashboardViewModel: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch stepCall {
        case 0:
            //            if self.myOrderCollectionModel.count == 0 {
            //                tableView.setEmptyMessage("No orders Found".localized)
            //            } else {
            //                tableView.restore()
            //            }
            
            return self.myOrderCollectionModel.count
        case 1:
            return addressDaatArray.count > 0 ? 2 : 0
        case 2:
            if  let reviewModel = self.reviewModel {
                //                if reviewModel.reviewList.count == 0 {
                //                    tableView.setEmptyMessage("No Reviews Found".localized)
                //                } else {
                //                    tableView.restore()
                //                }
                
                return reviewModel.reviewList.count
            }
            return 0
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch stepCall {
        case 0:
            return self.loadNameOrder(tableView: tableView, indexPath: indexPath)
        case 1:
            return self.loadAddress(tableView: tableView, indexPath: indexPath)
        case 2:
            return self.loadReview(tableView: tableView, indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: DasboardAction.identifier) as? DasboardAction {
            
            
            headerView.ordersBtn.addTapGestureRecognizer {
                self.stepCall = 0
                UIView.animate(withDuration: 0.5) {
                    if Defaults.language == "ar" {
                        headerView.lineviewX.constant = headerView.reviewBtn.frame.origin.x
                    } else {
                        headerView.lineviewX.constant = headerView.ordersBtn.frame.origin.x
                        
                    }
                    
                    headerView.layoutIfNeeded()
                }
                
                tableView.reloadData()
            }
            headerView.addressBtn.addTapGestureRecognizer {
                self.stepCall = 1
                UIView.animate(withDuration: 0.5) {
                    headerView.lineviewX.constant = headerView.addressBtn.frame.origin.x
                    headerView.layoutIfNeeded()
                }
                tableView.reloadData()
            }
            var data =  "Reviews".localized
            if let reviewModel =  reviewModel {
                data = "Reviews".localized + " " + "(" + String(reviewModel.totalCount) + ")"
            }
            
            headerView.reviewBtn.setTitle(data, for: .normal)
            headerView.reviewBtn.addTapGestureRecognizer {
                self.stepCall = 2
                UIView.animate(withDuration: 0.5) {
                    if Defaults.language == "ar" {
                        headerView.lineviewX.constant = headerView.ordersBtn.frame.origin.x
                    } else {
                        headerView.lineviewX.constant = headerView.reviewBtn.frame.origin.x
                    }
                    
                    headerView.layoutIfNeeded()
                }
                tableView.reloadData()
            }
            
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch stepCall {
        case 0:
            if  myOrderCollectionModel.count > 0 {
                return nil
            }
            return "No orders Found".localized
        case 2:
            if  reviewModel.reviewList.count > 0 {
                return nil
            }
            return ("No Reviews Found".localized)
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch stepCall {
        case 0:
            if let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ActionButtonFooterView.identifier) as? ActionButtonFooterView , myOrderCollectionModel.count > 0 {
                footerView.setBackgroundViewColor(color: UIColor.white)
                footerView.btn.setTitle("View All Orders".localized, for: .normal)
                footerView.btn.setTitleColor(UIColor.white, for: .normal)
                footerView.btn.backgroundColor = UIColor.black
                footerView.btn.addTapGestureRecognizer {
                    self.moveDelegate?.moveToAnother(id: "", controller: .myOrders)
                }
                return footerView
            }
            return nil
        case 1:
            if let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ActionButtonFooterView.identifier) as? ActionButtonFooterView {
                footerView.setBackgroundViewColor(color: UIColor.white)
                footerView.btn.setTitle("Manage Other Addresses".localized, for: .normal)
                footerView.btn.setTitleColor(UIColor.white, for: .normal)
                footerView.btn.addTapGestureRecognizer {
                    self.moveDelegate?.moveToAnother(id: "", controller: .addressBookListViewController)
                }
                
                footerView.btn.backgroundColor = UIColor.black
                return footerView
            }
            return nil
        case 2:
            if let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ActionButtonFooterView.identifier) as? ActionButtonFooterView , let reviewModel = reviewModel, reviewModel.reviewList.count > 0 {
                footerView.setBackgroundViewColor(color: UIColor.white)
                footerView.btn.setTitle("View All Product Reviews".localized, for: .normal)
                footerView.btn.setTitleColor(UIColor.white, for: .normal)
                footerView.btn.addTapGestureRecognizer {
                    self.moveDelegate?.moveToAnother(id: "", controller: .productReviewList)
                }
                footerView.btn.backgroundColor = UIColor.black
                return footerView
            }
            return nil
        default:
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 56
    }
    
    func loadNameOrder(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell: OrderListTableViewCell = tableView.dequeueReusableCell(with: OrderListTableViewCell.self, for: indexPath) else { return UITableViewCell() }
        cell.orderId.text = self.myOrderCollectionModel[indexPath.row].orderId
        cell.item = myOrderCollectionModel[indexPath.row]
        //            cell.delegate = self
        cell.detailBtn.tag = indexPath.row
        cell.reOrderBtn.tag = indexPath.row
        cell.reOrderBtn.addTapGestureRecognizer {
            self.apiToCall = .reOrder
            self.orderId = self.myOrderCollectionModel[indexPath.row].orderId ?? ""
            self.callingHttppApi { [weak self] jsonData in
                NetworkManager.sharedInstance.dismissLoader()
                self?.moveDelegate?.moveToAnother(id: "", controller: .none)
            }
        }
        cell.detailBtn.addTapGestureRecognizer {
            self.moveDelegate?.moveToAnother(id: self.myOrderCollectionModel[indexPath.row].orderId!, controller: .orderDetailsDataViewController)
        }
        cell.reviewBtn.addTapGestureRecognizer {
            self.moveDelegate?.moveToAnother(id: self.myOrderCollectionModel[indexPath.row].orderId!, controller: .orderReview)
        }
        cell.reviewBtn.tag = indexPath.row
        cell.selectionStyle = .none
        //            self.seprator(cell: cell)
        return cell
    }
    
    func loadReview(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell: DashboardReviewTableViewCell = tableView.dequeueReusableCell(with: DashboardReviewTableViewCell.self, for: indexPath) else { return UITableViewCell() }
        cell.item = reviewModel.reviewList[indexPath.row]
        //        self.seprator(cell: cell)
        return cell
    }
    
    func loadAddress(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell: DashboardAddressTableViewCell = tableView.dequeueReusableCell(with: DashboardAddressTableViewCell.self, for: indexPath) else { return UITableViewCell() }
        if indexPath.row == 0 {
            cell.heading.text = "Default Billing Address".localized
            cell.addressLabel.text = addressDaatArray[0].billingAddress
            cell.addTapGestureRecognizer {
                self.moveDelegate?.moveToAnother(id:  self.addressDaatArray[0].billingId ?? "", controller: .newAddress)
            }
            
        } else {
            cell.addTapGestureRecognizer {
                self.moveDelegate?.moveToAnother(id:  self.addressDaatArray[0].shippingId ?? "", controller: .newAddress)
            }
            cell.addressLabel.text = addressDaatArray[0].shippingAddress
            cell.heading.text = "Default Shipping Address".localized
        }
        cell.selectionStyle = .none
        //        self.seprator(cell: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if stepCall == 2 {
            moveDelegate?.moveToAnother(id: reviewModel.reviewList[indexPath.row].id, controller: .reviewDetails)
        }
    }
    
    func seprator(cell: UITableViewCell) {
        let screenSize = UIScreen.main.bounds
        let separatorHeight = CGFloat(28)
        let additionalSeparator = UIView.init(frame: CGRect(x: 0, y: cell.contentView.frame.size.height, width: screenSize.width, height: separatorHeight))
        additionalSeparator.backgroundColor = UIColor(named: "BackColor")
        cell.contentView.addSubview(additionalSeparator)
    }
}

protocol DashboardMoveDelegate: NSObjectProtocol {
    func moveToAnother(id: String, controller: AllControllers)
}

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 100, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
