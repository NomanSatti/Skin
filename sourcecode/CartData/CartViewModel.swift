import Foundation
import UIKit
import Alamofire
import RSSelectionMenu

class CartViewModel: NSObject {
    
    enum CartApi {
        case getCartData
        case removeProductFromCart
        case wishlistFromCart
        case applyCoupon
        case removeCoupon
        case updateCart
        case emptyCart
    }
    
    var whichApiCall: CartApi = .getCartData
    var cartModel: CartDataModel!
    weak var tableView: UITableView!
    private  var removeItemID: String?
    private  var wishlistProduct: String?
    private  var cartCoupon: String?
    private  var totalSections = 0
    var openPriceView = true
    var openVoucherView = true
    weak var cartController: CartDataViewController?
    var dummyData = ["Update Cart", "Continue Shopping", "EmptyCart"]
    var selectionMenu = RSSelectionMenu<String>()
    var priceLabel: UILabel?
    var updateQtyTxtfld: UITextField?
    var applyCouponTxtfld: UITextField?
    
    func callingHttppApi(completion: @escaping (Bool, JSON) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        var apiName: WhichApiCall = .cartData
        var verbs: HTTPMethod = .get
        requstParams["storeId"] = Defaults.storeId
        requstParams["customerToken"] = Defaults.customerToken
        requstParams["quoteId"] = Defaults.quoteId
        switch whichApiCall {
        case .getCartData:
            apiName = .cartData
            verbs = .get
        case .removeProductFromCart:
            apiName = .removeProductFromData
            requstParams["itemId"] = removeItemID
            verbs = . post
        case .wishlistFromCart:
            apiName = .wishlistFromCart
            requstParams["itemId"] = removeItemID
            requstParams["productId"] = wishlistProduct
            verbs = . post
        case .applyCoupon:
            apiName = .couponForCart
            requstParams["couponCode"] = cartCoupon
            verbs = . post
        case .removeCoupon:
            apiName = .couponForCart
            requstParams["removeCoupon"] = cartCoupon
            verbs = . post
        case .updateCart:
            apiName = .updateCart
            requstParams["itemIds"] = cartModel.cartProducts.map { $0.id! }.description
            requstParams["itemQtys"] = cartModel.cartProducts.map { $0.qty! }.description
            verbs = .post
        case .emptyCart:
            apiName = .emptyCart
            verbs = .post
        }
        
        requstParams["eTag"] = DBManager.sharedInstance.geteTagFromDataBase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "cartData"))
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: verbs, apiname: apiName, currentView: UIViewController()) { [weak self] success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            if success == 1 {                
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                if jsonResponse["success"].boolValue == true {
                    if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]) {
                        DBManager.sharedInstance.storeDataToDataBase(data: data, eTag: jsonResponse["eTag"].stringValue, hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "cartData"))
                    }
                    
                    self?.doFurtherProcessingWithResult(data: jsonResponse) { success in
                        completion(success, jsonResponse)
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
                self?.callingHttppApi {(success,_)  in
                    completion(success, JSON.null)
                    
                }
            } else if success == 3 {   // No Changes
                let jsonResponse =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "cartData"))
                self?.doFurtherProcessingWithResult(data: jsonResponse) { success in
                    completion(success, jsonResponse)
                }
                
            }
        }
    }
    
    func doFurtherProcessingWithResult(data: JSON, completion: (Bool) -> Void) {
        switch whichApiCall {
        case .getCartData:
            (Defaults.cartBadge) = data["cartCount"].stringValue
            cartModel = CartDataModel(json: data)
            self.tableView.delegate = self
            self.tableView.dataSource = self
            tableView.separatorStyle = .none
            print(cartModel.cartProducts)
            if cartModel.cartProducts.count > 0 {
                totalSections = 5
                cartController?.bottomClicked.isHidden = false
                cartController?.emptyView.isHidden = true
                cartController?.tableView.isHidden = false
            } else {
                cartController?.bottomClicked.isHidden = true
                cartController?.emptyView.isHidden = false
                cartController?.tableView.isHidden = true
                LottieHandler.sharedInstance.playLoattieAnimation()
                totalSections = 0
            }
            self.priceLabel?.text = self.cartModel.cartTotal
            self.tableView.reloadData()
            completion(true)
        case .removeProductFromCart:
            print()
            if data["success"].boolValue {
                self.removeItemID = nil
                self.whichApiCall = .getCartData
                self.callingHttppApi { (_,_) in
                }
            } else {
                ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
            }
            
        case .wishlistFromCart:
            if data["success"].boolValue {
                self.removeItemID = nil
                self.wishlistProduct = nil
                self.whichApiCall = .getCartData
                self.callingHttppApi { (_,_) in
                }
            } else {
                ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
            }
        case .applyCoupon, .removeCoupon:
            if data["success"].boolValue {
                ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: data["message"].stringValue)
                self.removeItemID = nil
                self.wishlistProduct = nil
                self.whichApiCall = .getCartData
                self.callingHttppApi { (_,_) in
                }
            } else {
                ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
            }
        case .updateCart:
            if data["success"].boolValue {
                self.removeItemID = nil
                self.whichApiCall = .getCartData
                self.callingHttppApi { (_,_) in
                }
            } else {
                ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
            }
        case .emptyCart:
            if data["success"].boolValue {
                self.removeItemID = nil
                self.whichApiCall = .getCartData
                self.callingHttppApi { (_,_) in
                }
            } else {
                ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
            }
        }
    }
    
    func removeProductFromCart() {
        self.whichApiCall = .removeProductFromCart
        self.callingHttppApi { (_,_) in
        }
    }
    
    func movewishlistFromCart() {
        self.whichApiCall = .wishlistFromCart
        self.callingHttppApi { (_,_) in
        }
    }
    
    func applyCoupon() {
        if let cartCoupon = cartCoupon, cartCoupon.count > 0 {
            self.whichApiCall = .applyCoupon
            self.callingHttppApi { (success,jsonData) in
                if success {
                    ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: jsonData["message"].stringValue)
                } else {
                    ShowNotificationMessages.sharedInstance.warningView(message: jsonData["message"].stringValue)
                }
                
            }
        } else {
            ShowNotificationMessages.sharedInstance.warningView(message: "Enter Coupon Code".localized)
        }
    }
    
    func deleteCoupon() {
        self.whichApiCall = .removeCoupon
        self.callingHttppApi { (success,jsonData) in
            if success {
                ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: jsonData["message"].stringValue)
            } else {
                ShowNotificationMessages.sharedInstance.warningView(message: jsonData["message"].stringValue)
            }
            
        }
    }
    var arr = ["1", "2", "3", "4", "5", "More"]
    func launchPopover(view: UILabel, completion: @escaping (String) -> Void) {
        selectionMenu = RSSelectionMenu(dataSource: arr.map {$0 }) { (cell, object, _) in
            cell.textLabel?.text = object
            //            cell.textLabel?.textAlignment = .center
        }
        selectionMenu.show(style: .popover(sourceView: view, size: CGSize(width: 80, height: 220)), from: cartController!)
        selectionMenu.setSelectedItems(items: [""], maxSelected: 100) { (_, index1, _, _)   in
            if index1 == 5 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    let AC = UIAlertController(title: "Quantity".localized, message: nil, preferredStyle: .alert)
                    AC.addTextField { (textField) in
                        textField.placeholder = "Enter Quantity".localized
                        textField.delegate = self
                        textField.keyboardType = .numberPad
                        self.updateQtyTxtfld = textField
                    }
                    let okBtn = UIAlertAction(title: "Ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                        let textField = AC.textFields![0] as UITextField
                        if let _ = Int(textField.text!) {
                            completion(textField.text!)
                        }
                    })
                    AC.addAction(okBtn)
                    self.cartController?.present(AC, animated: true, completion: nil)
                })
            } else {
                print(index1)
                completion(String(index1 + 1    ))
            }
            return
            
        }
        
        //        selectionMenu.show(from: .popover(sourceView: view, size: CGSize(width: 200, height: 300), from: cartController!)
        
    }
}

extension CartViewModel: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.updateQtyTxtfld {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.applyCouponTxtfld {
            self.cartCoupon = textField.text
        }
    }
}

extension CartViewModel: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return totalSections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return cartModel.cartProducts.count
        case 2:
            return cartModel.crossSellList.count>0 ? 1:0//cartModel.crossSellList.count
        default:
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell: CartProductTableViewCell = tableView.dequeueReusableCell(with: CartProductTableViewCell.self, for: indexPath) {
                cell.item = cartModel.cartProducts[indexPath.row]
                cell.removeBtn.addTapGestureRecognizer {
                    self.removeItemID = self.cartModel.cartProducts[indexPath.row].id
                    self.removeProductFromCart()
                }
                cell.wishlistBtn.addTapGestureRecognizer {
                    self.removeItemID = self.cartModel.cartProducts[indexPath.row].id
                    self.wishlistProduct = self.cartModel.cartProducts[indexPath.row].productId
                    if Defaults.customerToken == nil {
                        let customerLoginVC = SignInViewController.instantiate(fromAppStoryboard: .customer)
                        let nav = UINavigationController(rootViewController: customerLoginVC)
                        //nav.navigationBar.tintColor = AppStaticColors.accentColor
                        cell.viewContainingController?.present(nav, animated: true, completion: nil)
                    } else {
                        self.movewishlistFromCart()
                    }
                    
                }
                cell.qtyLabel.addTapGestureRecognizer {
                    self.launchPopover(view: cell.qtyLabel) { qty in
                        self.cartModel.cartProducts[indexPath.row].updateQty(qty: qty)
                        cell.qtyLabel.text = "Qty".localized + ": " + qty
                    }
                }
                cell.selectionStyle = .none
                return cell
            }
        case 1:
            if let cell: CartVoucherTableViewCell = tableView.dequeueReusableCell(with: CartVoucherTableViewCell.self, for: indexPath) {
                cell.selectionStyle = .none
                if !openVoucherView {
                    cell.arrowBtn.image = UIImage(named: "sharp-arrow-bottom")
                } else {
                    cell.arrowBtn.image = UIImage(named: "sharp-arrow-top")
                }
                if !openVoucherView {
                    cell.bottomView.isHidden = true
                    cell.bottomViewHeight.constant = 0
                } else {
                    cell.bottomView.isHidden = false
                    cell.bottomViewHeight.constant = 88
                }
                cell.textField.delegate = self
                self.applyCouponTxtfld = cell.textField
                if let couponCode =  cartModel.couponCode {
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
                cell.delegate = self
                return cell
            }
        case 4:
            if let cell: CartActionTableViewCell = tableView.dequeueReusableCell(with: CartActionTableViewCell.self, for: indexPath) {
                cell.selectionStyle = .none
                cell.updateCartBtn.addTapGestureRecognizer {
                    self.whichApiCall = .updateCart
                    self.callingHttppApi { (_,_) in
                    }
                }
                cell.emptyCartBtn.addTapGestureRecognizer {
                    
                    let AC = UIAlertController(title: "Empty Cart".localized, message: "Do you want remove all items from cart".localized, preferredStyle: .alert)
                    let yesBtn = UIAlertAction(title: "Yes".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                        self.whichApiCall = .emptyCart
                        self.callingHttppApi { (_,_) in
                        }
                    })
                    let noBtn = UIAlertAction(title: "No".localized, style: .cancel, handler: nil)
                    
                    AC.addAction(yesBtn)
                    AC.addAction(noBtn)
                    cell.viewContainingController?.present(AC, animated: true, completion: {})
                }
                cell.continueShoppingBtn.addTapGestureRecognizer {
                    self.cartController?.backPress()
                }
                
                return cell
            }
        case 3:
            if let cell: CartPriceTableViewCell = tableView.dequeueReusableCell(with: CartPriceTableViewCell.self, for: indexPath) {
                cell.selectionStyle = .none
                if !openPriceView {
                    cell.dropIcon.image = UIImage(named: "sharp-arrow-bottom")
                } else {
                    cell.dropIcon.image = UIImage(named: "sharp-arrow-top")
                }
                cell.item = cartModel.totalsData
                if !openPriceView {
                    cell.tableView.isHidden = true
                    cell.tableViewHeight.constant = 0
                } else {
                    cell.tableView.isHidden = false
                    cell.tableViewHeight.constant = CGFloat(cell.totalsData.count * 44)
                }
                cell.tableView.reloadData()
                //                cell.orderTotalLabel.text = cartModel.grandtotal?.title
                cell.orderTotalPrice.text = cartModel.cartTotal
                cell.delegate = self
                return cell
            }
        case 2:
            if let cell: RelatedProductTableViewCell = tableView.dequeueReusableCell(with: RelatedProductTableViewCell.self, for: indexPath) {
                cell.selectionStyle = .none
                cell.headingLabelClicked.text = "Cross List".localized
                cell.relatedList = cartModel.crossSellList
                cell.viewAllBtn.isHidden = true
                cell.collectionView.reloadData()
                return cell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        if indexPath.section == 2 && indexPath.row == 0 {
        //            self.whichApiCall = .updateCart
        //            self.callingHttppApi { _ in
        //            }
        //        }
        //        if indexPath.section == 2 && indexPath.row == 1 {
        //           cartController?.backPress()
        //        }
        //
        //        if indexPath.section == 2 && indexPath.row == 2 {
        //            self.whichApiCall = .emptyCart
        //            self.callingHttppApi { _ in
        //            }
        //        }
        
    }
}

extension CartViewModel: HeaderViewDelegate {
    func toggleSection(view: UITableViewCell, section: Int) {
        if let view = view as? CartVoucherTableViewCell {
            
            if  openVoucherView {
                openVoucherView  = false
                view.bottomView.isHidden = true
                view.bottomViewHeight.constant = 0
            } else {
                openVoucherView = true
                view.bottomView.isHidden = false
                view.bottomViewHeight.constant = 88
            }
        }
        
        if let view = view as? CartPriceTableViewCell {
            if  openPriceView {
                openPriceView  = false
                view.tableView.isHidden = true
                view.tableViewHeight.constant = 0
            } else {
                openPriceView = true
                view.tableView.isHidden = false
                view.tableViewHeight.constant = CGFloat(view.totalsData.count * 44)
            }
        }
        
        self.tableView?.reloadSections([section], with: .none)
    }
}
