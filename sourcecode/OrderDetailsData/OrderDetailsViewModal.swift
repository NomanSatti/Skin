//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: OrderDetailsViewModal.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit
import MapKit
import Alamofire
import SwiftyJSON


class OrderDetailsViewModal: NSObject {
    
    var orderId: String
    var collapse = true
    var reloadSections: ((_ section: Int) -> Void)?
    var navigateAdminChatDelivery: ((_ completion: Bool) -> Void)?
    var navigateToMap: ((_ lat: String, _ long: String) -> Void)?
    var model: OrderDetailsModel!
    var shipmentModel: ShipmentModel!
    var selectedOrderType: OrderViewPart = .itemsOrdered
    var apiCall = ""
    var currentLocation: CLLocation!
    var locManager = CLLocationManager()
    var invoiceButton = UIBarButtonItem()
    var controller: OrderDetailsDataViewController?
    
    init(orderId: String) {
        self.orderId = orderId
        locManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locManager.location
            
            if currentLocation != nil {
                print(currentLocation.coordinate.latitude)
                print(currentLocation.coordinate.longitude)
            }
        }
    }
    
    var sectionCount = 1
    
    enum OrderViewPart: String, CaseIterable {
        case itemsOrdered = "Items Ordered"
        case invoices = "Invoices"
        case shipments = "Order Shipments"
        
        static func getStringFor(string: OrderViewPart) -> String {
            return string.localizedString()
        }
        
        func localizedString() -> String {
            return self.rawValue.localized
        }
        
    }
    
    func callingHttppApi(completion: @escaping (Bool) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        var method = HTTPMethod.get
        var requstParams = [String: Any]()
        requstParams["storeId"] = Defaults.storeId
        requstParams["width"] = UrlParams.width
        requstParams["incrementId"] = orderId
        requstParams["quoteId"] = Defaults.quoteId
        requstParams["customerToken"] = Defaults.customerToken
        var apiName: WhichApiCall = .orderDetails
        if apiCall == "shipment" {
            method = .get
            apiName = .shipmentDetails
        }else  if apiCall == "track" {
            requstParams["deliveryboyId"] = model.deliveryboyId
            method = .get
            apiName = .GetDeliveryboyLocation           
        } else if apiCall == "updateTokenToDataBase" {
            requstParams = [String: Any]()
            requstParams["userId"] = Defaults.customerToken
            requstParams["name"] = Defaults.customerName
            requstParams["avatar"] = Defaults.profilePicture
            requstParams["token"] = Defaults.deviceToken
            requstParams["accountType"] = "customer"
            requstParams["os"] = "ios"
            print(requstParams)
            method = .post
            apiName = .chatWithAdmin
        } else if apiCall == "reOrder" {
            requstParams["incrementId"] = orderId
            method = .post
            if let customerToken = Defaults.customerToken, customerToken != "" {
                apiName = .reorder
            } else {
                apiName = .guestReoder
            }
        }
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: method, apiname: apiName, currentView: UIViewController()) { [weak self] success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            if success == 1 {
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                if jsonResponse["success"].boolValue == true {
                    if jsonResponse["quoteId"].stringValue.count > 0  {
                        Defaults.quoteId = jsonResponse["quoteId"].stringValue
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
        if apiCall == "shipment" {
            shipmentModel = ShipmentModel(json: data)
            completion(true)
        }else  if apiCall == "track" {
            //
            let lat = data["latitude"].stringValue
            let lon = data["longitude"].stringValue
            if currentLocation != nil {
                
                if model.picked {
                    //open map and draw polyline
                    navigateToMap?(lat, lon)
                } else {
                    let url = "http://maps.apple.com/maps?saddr=\(self.currentLocation.coordinate.latitude),\(self.currentLocation.coordinate.longitude)&daddr=\(lat),\(lon)"
                    UIApplication.shared.openURL(URL(string:url)!)
                }
            }
        } else if apiCall == "updateTokenToDataBase" {
            navigateAdminChatDelivery?(true)
        } else if apiCall == "reOrder" {
            if data["success"].boolValue {
                if data["cartCount"] != JSON.null {
                    Defaults.cartBadge = data["cartCount"].stringValue
                }
                let AC = UIAlertController(title: "Reorder".localized, message: "Product(s) has been added to cart".localized, preferredStyle: .alert)
                let okBtn = UIAlertAction(title: "Go to Cart".localized.uppercased(), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                    let viewController = CartDataViewController.instantiate(fromAppStoryboard: .product)
                    let nav = UINavigationController(rootViewController: viewController)
                    //nav.navigationBar.tintColor = AppStaticColors.accentColor
                    nav.modalPresentationStyle = .fullScreen
                    self.controller?.present(nav, animated: true, completion: nil)
                })
                let cancelBtn = UIAlertAction(title: "Dismiss".localized.uppercased(), style: .default, handler: nil)
                AC.addAction(okBtn)
                AC.addAction(cancelBtn)
                self.controller?.present(AC, animated: true, completion: {})
            } else {
                if data["message"].stringValue.removeWhiteSpace.count > 0 {
                    ShowNotificationMessages.sharedInstance.warningView(message: data["message"].stringValue)
                } else {
                    ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
                }
            }
        } else {
            
            print(data)
            
            
            model = OrderDetailsModel(json: data)
            if model.invoiceList.count > 0 &&  model.shipmentList.count > 0 {
                sectionCount = 3
            } else if  model.invoiceList.count > 0 ||  model.shipmentList.count > 0 {
                sectionCount = 2
            } else {
                sectionCount = 1
            }
            let reOrderBtn = UIButton(frame: CGRect(x: 0, y: 0, width: self.controller?.tableView.frame.width ?? AppDimensions.screenWidth, height: 44))
            reOrderBtn.titleLabel?.font = UIFont.myBoldSystemFont(ofSize: 17)
            reOrderBtn.setImage(UIImage(named: "sharp-repeat"), for: .normal)
            reOrderBtn.setTitle("Reorder".localized.uppercased(), for: .normal)
            reOrderBtn.setTitleColor(.black, for: .normal)
            reOrderBtn.addTarget(self, action: #selector(reorderProduct), for: .touchUpInside)
            self.controller?.tableView.tableFooterView = reOrderBtn
            completion(true)
        }
    }
    
    @objc func reorderProduct() {
        apiCall = "reOrder"
        self.callingHttppApi { (_) in
        }
    }
}

extension OrderDetailsViewModal: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch selectedOrderType {
        case .itemsOrdered:
            tableView.viewContainingController?.navigationItem.title = selectedOrderType.localizedString()
            return 6
        case .invoices, .shipments:
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if model.invoiceList.count > 0 ||  model.shipmentList.count > 0 {
                return collapse ? 0 : sectionCount
            }
            return 0
        }
        switch selectedOrderType {
        case .itemsOrdered:
            if section == 2 {
                return model.orderData.itemList.count
            }
            if section == 4 {
                if model.state == "complete" {
                    if model.isEligibleForDeliveryBoy {
                        return 1
                    }
                    return 0
                } else {
                    return model.isEligibleForDeliveryBoy ? 1 : 0
                }
            }
            return 1
        case .invoices:
            if section == 2 {
                return model.invoiceList.count
            }
            return 1
        case .shipments:
            if section == 2 {
                return model.shipmentList.count
            }
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            if sectionCount == 2 && indexPath.row == 1 && model.shipmentList.count > 0{
                cell.textLabel?.text = OrderViewPart.allCases[2].localizedString()
            } else {
                cell.textLabel?.text = OrderViewPart.allCases[indexPath.row].localizedString()
            }
            cell.backgroundColor = AppStaticColors.accentColor
            cell.textLabel?.textColor = UIColor.white
            cell.contentView.backgroundColor = AppStaticColors.accentColor
            tableView.separatorStyle = .none
            return cell
        case 1:
            if let cell: OrderHeadingTableViewCell = tableView.dequeueReusableCell(with: OrderHeadingTableViewCell.self, for: indexPath) {
                cell.date.text = model.orderDate
                cell.statusColor = model.statusColorCode
                cell.statusLabel.text = model.statusLabel.uppercased()
                cell.statusWidth.constant = (cell.statusLabel.text?.widthOfString(usingFont: UIFont.boldSystemFont(ofSize: 14)))! + 20
                cell.selectionStyle = .none
                return cell
            }
        default:
            switch selectedOrderType {
            case .itemsOrdered:
                return self.selectedOrderTableData(tableView: tableView, indexPath: indexPath)
            case .invoices:
                return self.selectedInvoiceTableData(tableView: tableView, indexPath: indexPath)
            case .shipments:
                return self.selectedShippingTableData(tableView: tableView, indexPath: indexPath)
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if sectionCount == 2 && indexPath.row == 1 && model.shipmentList.count > 0{
                selectedOrderType = OrderViewPart.allCases[2]
            } else {
                selectedOrderType = OrderViewPart.allCases[indexPath.row]
            }
            collapse = true
            tableView.reloadData()
        } else  if indexPath.section == 2 {
            if let cell = tableView.cellForRow(at: indexPath) as? OrderDetailProductTableViewCell {
                let viewController = ProductPageDataViewController.instantiate(fromAppStoryboard: .product)
                viewController.productId = model.orderData.itemList[indexPath.row].productId
                let nav = UINavigationController(rootViewController: viewController)
                //nav.navigationBar.tintColor = AppStaticColors.accentColor
                nav.modalPresentationStyle = .fullScreen
                cell.viewContainingController?.present(nav, animated: true, completion: nil)
            }
        }
    }
    
    func selectedShippingTableData(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell: OrderDetailInvoiceTableViewCell = tableView.dequeueReusableCell(with: OrderDetailInvoiceTableViewCell.self, for: indexPath) {
            cell.invoiceLabel.text = "Shipment".localized
            cell.viewInvouceBtn.setTitle("View Shipment".localized, for: .normal)
            cell.saveInvoiceBtn.isHidden = false
            cell.viewInvouceBtn.setImage(UIImage(named: "sharp-arrow-line"), for: .normal)
            cell.saveInvoiceBtn.setTitle("Track Shipment".localized, for: .normal)
            cell.saveInvoiceBtn.addTapGestureRecognizer {
                if let shipmentModel = self.shipmentModel, shipmentModel.trackingData.count > 0 {
                    let viewController = TrackingDataViewController.instantiate(fromAppStoryboard: .customer)
                    viewController.trackingData =  shipmentModel.trackingData
                    cell.viewContainingController?.navigationController?.pushViewController(viewController, animated: true)
                } else {
                    ShowNotificationMessages.sharedInstance.warningView(message: "No data found".localized)
                }
            }
            cell.saveInvoiceBtn.setImage(UIImage(named: "sharp-location"), for: .normal)
            cell.orderIdLabel.text = "#" + model.shipmentList[indexPath.row].incrementId
            cell.shipmentId = model.shipmentList[indexPath.row].incrementId
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func selectedInvoiceTableData(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell: OrderDetailInvoiceTableViewCell = tableView.dequeueReusableCell(with: OrderDetailInvoiceTableViewCell.self, for: indexPath) {
            cell.invoiceLabel.text = "Invoice".localized
            cell.viewInvouceBtn.setTitle("View Invoice".localized, for: .normal)
            cell.saveInvoiceBtn.setTitle("Save Invoice".localized, for: .normal)
            cell.viewInvouceBtn.setImage(UIImage(named: "sharp-invoice"), for: .normal)
            cell.saveInvoiceBtn.setImage(UIImage(named: "sharp-save"), for: .normal)
            cell.orderIdLabel.text = "#" + model.invoiceList[indexPath.row].incrementId
            cell.incrementId = model.invoiceList[indexPath.row].incrementId
            cell.selectionStyle = .none
            cell.saveInvoiceBtn.isHidden = true
            return cell
        }
        return UITableViewCell()
    }
    
    func selectedOrderTableData(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 2:
            if let cell: OrderDetailProductTableViewCell = tableView.dequeueReusableCell(with: OrderDetailProductTableViewCell.self, for: indexPath) {
                cell.item =  model.orderData.itemList[indexPath.row]
                cell.selectionStyle = .none
                return cell
            }
        case 3:
            if let cell: CartPriceTableViewCell = tableView.dequeueReusableCell(with: CartPriceTableViewCell.self, for: indexPath) {
                cell.item =  model.orderData.totals
                cell.orderTotalPrice.text = model.orderTotal
                cell.selectionStyle = .none
                cell.dropIcon.isHidden = true
                cell.tableViewHeight.constant = CGFloat(cell.totalsData.count * 44)
                tableView.separatorStyle = .singleLine
                return cell
            }
        case 4:
            if model.state == "complete" {
                if let cell = tableView.dequeueReusableCell(with: DeliveryboyRatingTableViewCell.self, for: indexPath), model.name.count > 0 {
                    cell.writeReview = {
                        let viewController = RateDeliveryBoyViewController.instantiate(fromAppStoryboard: .more)
                        viewController.deliveryboyId = self.model.deliveryboyId
                        viewController.customerId = self.model.customerId
                        cell.viewContainingController?.navigationController?.pushViewController(viewController, animated: true)
                    }
                    return cell
                }
            } else {
                if let cell: OrderTrackTableViewCell = tableView.dequeueReusableCell(with: OrderTrackTableViewCell.self, for: indexPath), model.name.count > 0 {
                    cell.name.text = model.name
                    cell.otp.text = "Otp: " + model.otp
                    cell.phNumber.text = model.mobile
                    cell.ratingBtn.setTitle(model.rating, for: .normal)
                    cell.selectionStyle = .none
                    cell.vechileNumber.text = model.vehicleNumber
                    cell.deliveryImage.setImage(fromURL: model.avatar)
                    cell.trackBtn.addTapGestureRecognizer {
                        self.apiCall = "track"
                        self.callingHttppApi { _ in
                        }
                    }
                    cell.chatBtn.addTapGestureRecognizer {
                        self.apiCall = "updateTokenToDataBase"
                        self.callingHttppApi { _ in
                        }
                    }
                    return cell
                } else {
                    let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
                    cell.textLabel?.text = "A delivery boy will be assigned shortly.".localized;
                    cell.selectionStyle = .none
                    return cell
                }
            }
        case 5:
            if let cell: OrderDetailsExtraTableViewCell = tableView.dequeueReusableCell(with: OrderDetailsExtraTableViewCell.self, for: indexPath) {
                cell.shippingData.text = model.shippingAddress
                cell.billingData.text = model.billingAddress
                cell.shippingMthdData.text = model.shippingMethod
                cell.paymentData.text = model.paymentMethod
                
                
                if model.paymentMethod.containsString("Bank Transfer"){
                    
                    if let extra = UserDefaults.standard.value(forKey: "bankExtraInfo") as? String {
                        cell.paymentData.adjustsFontSizeToFitWidth = true
                        cell.paymentData.numberOfLines = 0
                        cell.paymentData.textAlignment = .center
                        
                                 cell.paymentData.text = model.paymentMethod + extra
                        
                        
                    }
                    
                    
                }
                
                
                cell.selectionStyle = .none
                
                
                
                return cell
            }
        default:
            break
        }
        return UITableViewCell()
    }
    
    
        func getJSON(_ key: String)-> JSON? {
        var p = ""
        if let result = UserDefaults.standard.string(forKey: key) {
            p = result
        }
        if p != "" {
            if let json = p.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                do {
                    return try JSON(data: json)
                } catch {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    
    func getPaymentMethodDetails(){
        
        
        guard let cartID = UserDefaults.standard.string(forKey: "cartID") else {
         
            return
            
        }
        
        
        
        
        let url: String = API_ROOT_DOMAIN + "rest/V1/carts/\(cartID)/payment-methods"
              var request = URLRequest(url:  NSURL(string: url)! as URL)

              // Your request method type Get or post etc according to your requirement
              request.httpMethod = "GET"

              request.setValue("Bearer \(ADMIN_TOKEN)", forHTTPHeaderField: "Authorization")
              request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        
              Alamofire.request(request).responseJSON { (responseObject) -> Void in

                if let data =  responseObject.result.value {
                  let json = JSON(data)
                    print(json)
                    
                    
                }
                
            }
            
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProductSectionHeading.identifier) as? ProductSectionHeading {
            headerView.arrowLabel.isHidden = true
            switch section {
            case 0:
                if sectionCount != 1 {
                    //tableView.viewContainingController?.navigationController?.navigationBar.tintColor = UIColor.black
                    self.invoiceButton = UIBarButtonItem(image: UIImage(named: "sharp-arrow-bottom-light")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(collapseChange))
                    self.invoiceButton.image = self.invoiceButton.image?.rotate(radians: collapse ? 0.0 : .pi)
                    tableView.viewContainingController?.navigationItem.rightBarButtonItem = self.invoiceButton
                    tableView.viewContainingController?.navigationItem.rightBarButtonItem?.tintColor = AppStaticColors.itemTintColor
                }
                return nil
            case 1:
                headerView.titleLabel?.text = "Order".localized + " #" + model.incrementId
            case 2:
                headerView.titleLabel?.text = String(model.orderData.itemList.count) + " " + "Item(s) Ordered".localized.uppercased()
            case 5:
                headerView.titleLabel?.text = "Shipping and Payment Info".localized.uppercased()
                
            case 4:
                if model.isEligibleForDeliveryBoy {
                    if model.state == "complete" {
                        headerView.titleLabel?.text = "Delivery Boy Rating".localized.uppercased()
                    } else {
                        headerView.titleLabel?.text = "Delivery Boy Details".localized.uppercased()
                    }
                } else {
                    return nil
                }
            default:
                return nil
            }
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch selectedOrderType {
        case .itemsOrdered:
            if section == 5 {
                return 0
            }
            if (section == 4 && model.state == "complete" && model.isEligibleForDeliveryBoy)  {
                return 56
            }
            if (section == 4 && !model.isEligibleForDeliveryBoy){
                return 0
            }
            if (section == 4 && model.state == "complete")  {
                return 0
            }
            if section == 0 || section == 3 {
                return 10//56
            }
            return 56
        case .invoices:
            if section == 2 {
                return 0
            }
            return 56
        case .shipments:
            if section == 2 {
                return 0
            }
            return 56
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    @objc func collapseChange(view: OrderDetailsHeaderView) {
        if model.invoiceList.count > 0 ||  model.shipmentList.count > 0 {
            if collapse {
                collapse = false
            } else {
                collapse = true
            }
            //view.arrowBtn?.rotate(collapse ? 0.0 : .pi)
            reloadSections?(0)
        }
    }
}
