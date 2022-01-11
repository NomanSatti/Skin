//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: WishlistViewModel.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit
import Alamofire
import RSSelectionMenu

class WishlistViewModel: NSObject {
    
    var wishlistModel: WishlistModel!
    var wishList = [WishlistProduct]()
    weak var collectionView: UICollectionView!
    weak var delegate: MoveController?
    private var removeItemID: String?
    private var selectedQty: String?
    weak var wishlistController: WishlistDataViewController!
    var whichApiCall: WishlistApi = .getWishlistData
    var selectionMenu = RSSelectionMenu<String>()
    var pageNumber = 1
    var arr = ["1", "2", "3", "4", "5", "More"]
    var selectedProductIndex = 0
    
    enum WishlistApi {
        case getWishlistData
        case wishlistToCart
        case removeFromWishlist
        case updateWishlist
        case addAllToCart
    }
    
    func callingHttppApi(completionHandler: @escaping (_ data: Bool) -> Void = { _ in }) {
        NetworkManager.sharedInstance.showLoader()
        
        var apiName: WhichApiCall = .wishlistData
        var verbs: HTTPMethod = .get
        var requstParams = [String: Any]()
        requstParams["storeId"] = Defaults.storeId
        requstParams["customerToken"] = Defaults.customerToken
        requstParams["quoteId"] = Defaults.quoteId
        requstParams["width"] = UrlParams.width
        
        switch whichApiCall {
        case .getWishlistData:
            apiName = .wishlistData
            requstParams["pageNumber"] = pageNumber
            verbs = .get
        case .wishlistToCart:
            apiName = .wishlistToCart
            requstParams["itemId"] = removeItemID
            requstParams["qty"] = selectedQty
            requstParams["eTag"] = DBManager.sharedInstance.geteTagFromDataBase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "wishlistData"))
            
            verbs = . post
        case .removeFromWishlist:
            apiName = .removeFromWishList
            requstParams["itemId"] = removeItemID
            verbs = . delete
        case .updateWishlist:
            
            var dictArray = [[String: String]]()
            for i in 0..<self.wishList.count {
                var dict = [String: String]()
                dict["id"] = self.wishList[i].id
                dict["qty"] = self.wishList[i].qty
                dict["description"] =  self.wishList[i].comment
                dictArray.append(dict)
            }
            apiName = .updateWishlist
            requstParams["itemData"] = dictArray.convertArrayToString()
            verbs = .post
        case .addAllToCart:
            var dict = [String: String]()
            for i in 0..<self.wishList.count {
                dict[self.wishList[i].id ?? ""] = self.wishList[i].qty
            }
            apiName = .addAllToCart
            requstParams["itemData"] = dict.convertDictionaryToString()
            verbs = . post
        }
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: verbs, apiname: apiName, currentView: UIViewController()) { [weak self] success, responseObject  in
            self?.wishlistController?.view.isUserInteractionEnabled = true
            NetworkManager.sharedInstance.dismissLoader()
            if success == 1 {                
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                if jsonResponse["success"].boolValue == true {
                    if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]) {
                        DBManager.sharedInstance.storeDataToDataBase(data: data, eTag: jsonResponse["eTag"].stringValue, hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "wishlistData"))
                    }
                    completionHandler(true)
                    self?.doFurtherProcessingWithResult(data: jsonResponse)
                } else {
                    if jsonResponse["message"].stringValue.removeWhiteSpace.count > 0 {
                        ShowNotificationMessages.sharedInstance.warningView(message: jsonResponse["message"].stringValue)
                        if let wishList = self?.wishList, let selectedProductIndex = self?.selectedProductIndex, wishList.count > selectedProductIndex {
                            self?.delegate?.moveController(id: wishList[selectedProductIndex].productId ?? "", name: wishList[selectedProductIndex].name ?? "", dict: [:], jsonData: JSON.null, type: "", controller: .productPage)
//                            let viewController = ProductPageDataViewController.instantiate(fromAppStoryboard: .product)
//                            viewController.productId = wishList[selectedProductIndex].productId ?? ""
//                            viewController.productName = wishList[selectedProductIndex].name ?? ""
//                            viewController.itemId = wishList[selectedProductIndex].wishlistItemId ?? ""
//                            self?.wishlistController?.navigationController?.pushViewController(viewController, animated: true)
                        }
                    } else {
                        ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
                    }
                }
            } else if success == 2 {   // Retry in case of error
                NetworkManager.sharedInstance.dismissLoader()
                self?.callingHttppApi()
            } else if success == 3 {   // No Changes
                let jsonResponse =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "wishlistData"))
                self?.doFurtherProcessingWithResult(data: jsonResponse)
            }
        }
    }
    
    func doFurtherProcessingWithResult(data: JSON) {
        print(data)
        self.wishlistController?.setupEmptyView()
        switch whichApiCall {
        case .getWishlistData:
            wishlistModel = WishlistModel(json: data)
            self.wishList += wishlistModel.wishList
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.reloadData()
            if self.wishList.count > 0 {
                let shareBtn = UIBarButtonItem(image: UIImage(named: "_Filled")?.withRenderingMode(.alwaysTemplate), style: .done, target: self, action: #selector(self.tapShareWishlistBtn))
                wishlistController?.navigationItem.setRightBarButton(shareBtn, animated: false)
                wishlistController?.navigationItem.rightBarButtonItem?.tintColor = AppStaticColors.itemTintColor
                wishlistController?.emptyView.isHidden = true
                wishlistController?.collectionView.isHidden = false
            } else {
                wishlistController?.navigationItem.setRightBarButton(nil, animated: false)
                wishlistController?.emptyView.isHidden = false
                wishlistController?.collectionView.isHidden = true
                LottieHandler.sharedInstance.playLoattieAnimation()
            }
        //            completion(true)
        case .wishlistToCart:
            print()
            if data["success"].boolValue {
                (Defaults.cartBadge) = data["cartCount"].stringValue
                ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: data["message"].stringValue)
                self.removeItemID = nil
                self.pageNumber = 1
                self.wishList.removeAll()
                self.whichApiCall = .getWishlistData
                self.callingHttppApi()
            } else {
                ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
            }
            
        case .removeFromWishlist:
            if data["success"].boolValue {
                self.removeItemID = nil
                self.pageNumber = 1
                self.wishList.removeAll()
                self.whichApiCall = .getWishlistData
                self.callingHttppApi()
            } else {
                ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
            }
        case .updateWishlist:
            if data["success"].boolValue {
                self.removeItemID = nil
                self.pageNumber = 1
                self.wishList.removeAll()
                self.whichApiCall = .getWishlistData
                self.callingHttppApi()
            } else {
                ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
            }
        case .addAllToCart:
            if data["success"].boolValue {
                if data["message"].stringValue != "" {
                    if data["warning"].boolValue {
                        ShowNotificationMessages.sharedInstance.warningView(message: data["message"].stringValue)
                    } else {
                        ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: data["message"].stringValue)
                    }
                }
                self.removeItemID = nil
                self.pageNumber = 1
                self.wishList.removeAll()
                self.whichApiCall = .getWishlistData
                self.callingHttppApi()
            } else {
                if let msg = data["message"].string {
                    ShowNotificationMessages.sharedInstance.warningView(message: msg)
                } else {
                    ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
                }
            }
        }
    }
    
    func launchPopover(view: UILabel, completion: @escaping (String) -> Void) {
        selectionMenu = RSSelectionMenu(dataSource: arr.map {$0 }) { (cell, object, _) in
            cell.textLabel?.text = object
            //            cell.textLabel?.textAlignment = .center
        }
        selectionMenu.show(style: .popover(sourceView: view, size: CGSize(width: 80, height: 220)), from: wishlistController!)
        selectionMenu.setSelectedItems(items: [""], maxSelected: 100) { (_, index1, _, _)   in
            if index1 == 5 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    let AC = UIAlertController(title: "Quantity".localized, message: nil, preferredStyle: .alert)
                    AC.addTextField { (textField) in
                        textField.placeholder = "Enter Quantity".localized
                        textField.delegate = self
                        textField.keyboardType = .numberPad
                    }
                    let okBtn = UIAlertAction(title: "Ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                        let textField = AC.textFields![0] as UITextField
                        if let _ = Int(textField.text!) {
                            completion(textField.text!)
                        }
                        
                    })
                    AC.addAction(okBtn)
                    self.wishlistController?.present(AC, animated: true, completion: nil)
                })
            } else {
                print(index1)
                completion(String(index1 + 1    ))
            }
            return
        }
        //        selectionMenu.show(from: .popover(sourceView: view, size: CGSize(width: 200, height: 300), from: cartController!)
    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y > scrollView.contentSize.height - wishlistController.collectionView.frame.size.height - 100 {
//            if self.wishList.count < wishlistModel.totalCount {
//                pageNumber += 1
//                self.whichApiCall = .getWishlistData
//                self.callingHttppApi()
//            }
//        }
//    }
    
    @objc func tapShareWishlistBtn() {
        let viewController = ShareWishlistViewController.instantiate(fromAppStoryboard: .main)
        self.wishlistController?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func loginBtnClicked() {
        let customerLoginVC = SignInViewController.instantiate(fromAppStoryboard: .customer)
        let nav = UINavigationController(rootViewController: customerLoginVC)
        nav.modalPresentationStyle = .fullScreen
        //nav.navigationBar.tintColor = AppStaticColors.accentColor
        self.wishlistController?.present(nav, animated: true, completion: nil)
    }
    
}

extension WishlistViewModel: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

extension WishlistViewModel: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.wishList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: WishlistProductCollectionViewCell = collectionView.dequeueReusableCell(with: WishlistProductCollectionViewCell.self, for: indexPath) {
            cell.item = self.wishList[indexPath.row]
            if self.wishList[indexPath.row].options.count > 0 {
                cell.optionSBtn.isHidden = false
            } else {
                cell.optionSBtn.isHidden = true
            }
            
            cell.moveToCartBtn.addTapGestureRecognizer {
                if self.wishList[indexPath.row].hasRequiredOptions && (self.wishList[indexPath.row].options.count != self.wishList[indexPath.row].configurableData?.attributes.count) {
                    self.delegate?.moveController(id: self.self.wishList[indexPath.row].productId ?? "", name: self.self.wishList[indexPath.row].name ?? "", dict: [:], jsonData: JSON.null, type: "", controller: .productPage)
                } else {
                    self.selectedProductIndex = indexPath.row
                    self.removeItemID = self.self.wishList[indexPath.row].id
                    self.selectedQty = self.self.wishList[indexPath.row].qty
                    self.moveWishlistToCart()
                }
                
            }
            cell.crossBtn.addTapGestureRecognizer {
                self.removeItemID = self.self.wishList[indexPath.row].id
                self.removeFromWishlist()
            }
            cell.qtyLabel.addTapGestureRecognizer {
                self.launchPopover(view: cell.qtyLabel) { qty in
                    self.self.wishList[indexPath.row].updateQty(qty: qty)
                    cell.qtyLabel.text = "Qty".localized + ": " + qty
                }
            }
            cell.optionSBtn.addTapGestureRecognizer {
                let vc = WishlistOptionsViewController.instantiate(fromAppStoryboard: .product)
                vc.modalPresentationStyle = .overCurrentContext
                vc.optionsData = self.wishList[indexPath.row].options
                NetworkManager.sharedInstance.topMostController().present(vc, animated: true, completion: nil)
            }
            cell.delegate = self
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.wishList.count - 1 {
            if self.wishList.count < wishlistModel.totalCount {
                pageNumber += 1
                self.whichApiCall = .getWishlistData
                self.callingHttppApi()
            }
        }
    }
    
    func moveWishlistToCart() {
        self.whichApiCall = .wishlistToCart
        self.callingHttppApi()
    }
    
    func removeFromWishlist() {
        self.whichApiCall = .removeFromWishlist
        self.callingHttppApi()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: AppDimensions.screenWidth/2 - 4, height: AppDimensions.screenWidth/2 + 156)
    }
    
    func update() {
        self.whichApiCall = .updateWishlist
        self.callingHttppApi()
    }
    
    func addAllToCart() {
        self.whichApiCall = .addAllToCart
        self.callingHttppApi()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.moveController(id: self.wishList[indexPath.row].productId ?? "", name: self.wishList[indexPath.row].name ?? "", dict: [:], jsonData: JSON.null, type: "", controller: .productPage)
    }
}

extension WishlistViewModel: MoveController {
    func moveController(id: String, name: String, dict: [String: Any], jsonData: JSON, type: String, controller: AllControllers) {
        delegate?.moveController(id: id, name: name, dict: dict, jsonData: jsonData, type: type, controller: controller)
    }
}
