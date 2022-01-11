//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: InvoiceViewModel.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit

class InvoiceViewModel: NSObject {
    
    var invoiceId: String
    
    init(invoiceId: String) {
        self.invoiceId = invoiceId
    }
    
    var model: InvoiceModel!
    
    func callingHttppApi(completion: @escaping (Bool) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        requstParams["storeId"] = Defaults.storeId
        requstParams["width"] = UrlParams.width
        requstParams["quoteId"] = Defaults.quoteId
        requstParams["invoiceId"] = invoiceId
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .get, apiname: .inVoiceDetails, currentView: UIViewController()) { [weak self] success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            if success == 1 {                
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                if jsonResponse["success"].boolValue == true {
                    
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
        model = InvoiceModel(json: data)
        completion(true)
    }
    
}

extension InvoiceViewModel: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return model.itemList.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell: InvoiceProductListTableViewCell = tableView.dequeueReusableCell(with: InvoiceProductListTableViewCell.self, for: indexPath) {
                cell.item = model.itemList[indexPath.row]
                cell.selectionStyle = .none
                return cell
            }
        } else {
            if let cell: CartPriceTableViewCell = tableView.dequeueReusableCell(with: CartPriceTableViewCell.self, for: indexPath) {
                cell.item =  model.totals
                cell.orderTotalPrice.text = model.cartTotal
                cell.selectionStyle = .none
                cell.dropIcon.isHidden = true
                tableView.separatorStyle = .singleLine
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProductSectionHeading.identifier) as? ProductSectionHeading {
                headerView.arrowLabel.isHidden = true
                headerView.titleLabel?.text = String(model.itemList.count) + " " + "Item(s)".localized
                return headerView
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 56
        }
        return 8
    }
    
}
