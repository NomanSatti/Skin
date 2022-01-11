//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: OrderListViewModel.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit
import Alamofire

class OrderListViewModel: NSObject {
    var model: OrderListModel?
    var pageNumber = 1
    var orderListData = [OrderListDataStruct]()
    weak var delegate: Pagination?
    weak var moveDelegate: moveToControlller?
    weak var reOrderDelegate: ReOrder?
    weak var orderListReviewProductDelegate: OrderListReviewProduct?
    var modelProductReviewData: OrderDetailsModel?
    @IBOutlet weak var orderListTable: UITableView!
    @IBOutlet weak var reviewProductListTable: UITableView!
    var orderId = ""
    func callingHttppApi(apiType: ApiTypeForOrderList, completion: @escaping (Bool) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        requstParams["storeId"] = Defaults.storeId
        requstParams["customerToken"] = Defaults.customerToken
        requstParams["websiteId"] = UrlParams.defaultWebsiteId
        requstParams["pageNumber"] = pageNumber
        requstParams["currency"] = Defaults.currency
        switch apiType {
        case .details:
            requstParams["pageNumber"] = pageNumber
            requstParams["eTag"] = DBManager.sharedInstance.geteTagFromDataBase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "orderListData"))
            NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .get, apiname: .orderList, currentView: UIViewController()) { [weak self] success, responseObject  in
                if success == 1 {
                    let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                    if jsonResponse["success"].boolValue == true {
                        if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]) {
                            DBManager.sharedInstance.storeDataToDataBase(data: data, eTag: jsonResponse["eTag"].stringValue, hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "orderListData"))
                        }
                        
                        self?.doFurtherProcessingWithResult(apiType: apiType, data: jsonResponse) { success in
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
                    self?.callingHttppApi(apiType: apiType) {success in
                        completion(success)
                        
                    }
                } else if success == 3 {   // No Changes
                    let jsonResponse =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "orderListData"))
                    self?.doFurtherProcessingWithResult(apiType: apiType, data: jsonResponse) { success in
                        completion(success)
                    }
                    
                }
            }
        case .reOrder:
            requstParams["incrementId"] = orderId
            NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .post, apiname: .reorder, currentView: UIViewController()) { [weak self] success, responseObject  in
                if success == 1 {
                    NetworkManager.sharedInstance.dismissLoader()
                    let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                    if jsonResponse["success"].boolValue == true {
                        if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]) {
                            print(data)
                        }
                        self?.doFurtherProcessingWithResult(apiType: apiType, data: jsonResponse) { success in
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
                    self?.callingHttppApi(apiType: apiType) {success in
                        completion(success)
                        
                    }
                } else if success == 3 {   // No Changes
                    let jsonResponse =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "orderListReOrderData"))
                    self?.doFurtherProcessingWithResult(apiType: apiType, data: jsonResponse) { success in
                        completion(success)
                    }
                }
            }
        default :
            print("")
        }
    }
    
    func doFurtherProcessingWithResult(apiType: ApiTypeForOrderList, data: JSON, completion: (Bool) -> Void) {
        NetworkManager.sharedInstance.dismissLoader()
        switch apiType {
        case .details:
            model = OrderListModel(data: data)
            if orderListData.count != model?.totalItem ?? 0 {
                for i in 0..<model!.orderListData.count {
                    orderListData.append((model?.orderListData[i])!)
                }
            }
            completion(true)
        case .reOrder:
            if data["cartCount"] != JSON.null {
                Defaults.cartBadge = data["cartCount"].stringValue
            }
            moveDelegate?.moveController(id: orderId, name: data["message"].stringValue, dict: [:], jsonData: JSON.null, index: 0, controller: .none)
        default:
            print("")
        }
    }
}

extension OrderListViewModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderListData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: OrderListTableViewCell = tableView.dequeueReusableCell(with: OrderListTableViewCell.self, for: indexPath) {
            cell.item = orderListData[indexPath.row]
            cell.delegate = self
            cell.detailBtn.tag = indexPath.row
            cell.reOrderBtn.tag = indexPath.row
            cell.reviewBtn.tag = indexPath.row
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 232
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        moveDelegate?.moveController(id: orderListData[indexPath.row].orderId ?? "", name: "", dict: [:], jsonData: JSON.null, index: indexPath.row, controller: .orderDetailsDataViewController)
    }
    @objc func scrollToFirstRow() {
        let indexPath = NSIndexPath(row: 0, section: 0)
        self.orderListTable.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - orderListTable.frame.size.height - 50 {
            if orderListData.count < model?.totalItem ?? 0 {
                orderListTable.tableFooterView?.isHidden = true
                pageNumber += 1
                delegate?.pagination()
            } else {
                if orderListData.count == model?.totalItem ?? 0  && orderListData.count > 0 {
                    if let footerView = (Bundle.main.loadNibNamed("OrderListFotterView", owner: self, options: nil)?[0] as? OrderListFotterView) , orderListData.count > 8 {
                        footerView.backToTop.addTarget(self, action: #selector(scrollToFirstRow), for: .touchUpInside)
                        orderListTable.tableFooterView = footerView
                        orderListTable.tableFooterView?.frame.size.height = 100
                        orderListTable.tableFooterView?.isHidden = false
                    }
                }
            }
        }
    }
}
extension OrderListViewModel: moveToControlller {
    func moveController(id: String, name: String, dict: [String: Any], jsonData: JSON, index: Int, controller: AllControllers) {
        if controller == .orderDetailsDataViewController {
            moveDelegate?.moveController(id: orderListData[index].orderId ?? "", name: "", dict: [:], jsonData: JSON.null, index: index, controller: .orderDetailsDataViewController)
        } else if controller == .reOrder {
            orderId = orderListData[index].orderId ?? ""
            reOrderDelegate?.reOrderAct()
        } else {
            moveDelegate?.moveController(id: orderListData[index].orderId ?? "", name: "", dict: [:], jsonData: JSON.null, index: index, controller: .orderReview)
        }
    }
}

enum ApiTypeForOrderList {
    case details
    case reOrder
    case review
}
