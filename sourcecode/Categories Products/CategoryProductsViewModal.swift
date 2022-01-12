//
//  CategoryProductsViewModal.swift
//  Mobikul Single App
//
//  Created by akash on 27/01/19.
//  Copyright © 2019 kunal. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

protocol ProductItemActions: class {
    func addToWishList(index: Int)
}

class CategoryProductsViewModal: NSObject, ProductItemActions {
    
    var productsCollectionView: UICollectionView!
    var sortFilterHeight: NSLayoutConstraint!
    var categoryProductsModal: CategoryProductsModal!
    var apiName: WhichApiCall = .categoryProductList
    var productDegisn: ProductDegisn!
    var categoryId: String!
    var categoryType: String!
    var searchQuery: String!
    var page = 1
    var sortItem: SortingData!
    var productID: String!
    var categories = [String]()
    var topIdArray = [String]()
    var subIdArray = [String]()
    var subNameArray = [String]()
    weak var delegate: SortFilterGridListActions?
    weak var moveDelegate: MoveController?
    var searchText = ""
    var dominantColor: String!
    var pagination = true
    
    func addToWishList(index: Int) {
        let customerId = Defaults.customerToken
        if customerId != nil {
            if let productList = categoryProductsModal.productList {
                let wishListFlag = productList[index].isInWishlist
                if !wishListFlag! {
                    productID = productList[index].entityId
                    self.callingHttppApi(apiName: .addToWishList) { (success, jsonResponse) in
                        if success {
                            self.categoryProductsModal.productList![index].addItemId(wishlistItemId: jsonResponse["itemId"].stringValue)
                            self.categoryProductsModal.productList![index].isInWishlist = true
                            self.productsCollectionView.reloadData()
                        }
                    }
                } else {
                    productID = productList[index].wishlistItemId
                    self.callingHttppApi(apiName: .removeFromWishList) { (success, jsonResponse) in
                        if success {
                            self.categoryProductsModal.productList![index].addItemId(wishlistItemId: "")
                            self.categoryProductsModal.productList![index].isInWishlist = false
                            self.productsCollectionView.reloadData()
                        }
                    }
                }
            }
        } else {
            var dict = [String: Any]()
            if let productList = categoryProductsModal.productList {
                dict = ["productID": productList[index].entityId as Any, "index": index]
            }
            moveDelegate?.moveController(id: "", name: "", dict: dict, jsonData: JSON.null, type: "", controller: AllControllers.signInController)
        }
    }
    
}

extension CategoryProductsViewModal {
    
    func callingHttppApi(apiName: WhichApiCall, completion: @escaping (Bool, JSON) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        var requestType: HTTPMethod = .get
        var requstParams = [String: Any]()
        requstParams["storeId"] = Defaults.storeId
        requstParams["quoteId"] = Defaults.quoteId
        requstParams["customerToken"] = Defaults.customerToken
        //requstParams["eTag"] = DBManager.sharedInstance.geteTagFromDataBase(hashKey: self.getProductCategoryHashKey())
        requstParams["currency"] = Defaults.currency
        requstParams["pageNumber"] = "\(page)"
        //requstParams["q"] = self.searchQuery
        //        requstParams["searchQuery"] = self.searchQuery
        if categoryType == "sellercollection" {
            requstParams["sellerId"] = categoryId
        } else if categoryType == "custom" {
            requstParams["type"] = "customCollection"
        } else {
            requstParams["type"] = categoryType
        }
        // category Id to be set here...
        requstParams["id"] = categoryId ?? "33"
        let width = String(format: "%f", AppDimensions.screenWidth * UIScreen.main.scale)
        requstParams["width"] = width
        if page == 1 {
            NetworkManager.sharedInstance.showLoader()
        }
        if topIdArray.count > 0 {
            requstParams["filterData"]  = [subIdArray, topIdArray].convertArrayToString()
        }
        
        if let item = sortItem {
            let sortData: NSArray = [item.code ?? "", item.direction ?? ""]
            //let filterData: NSArray = [filterIdValue, filterCodeValue]
            do {
                let jsonSortData =  try JSONSerialization.data(withJSONObject: sortData, options: .prettyPrinted)
                let jsonSortString: String = NSString(data: jsonSortData, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["sortData"] = jsonSortString
                //let jsonFilterData =  try JSONSerialization.data(withJSONObject: filterData, options: .prettyPrinted)
                //let jsonFilterString: String = NSString(data: jsonFilterData, encoding: String.Encoding.utf8.rawValue)! as String
                //requstParams["filterData"] = jsonFilterString
            } catch {
                print(error.localizedDescription)
            }
        }
        
        switch apiName {
        case .addToWishList:
            requestType = .post
            requstParams["productId"] = productID ?? ""
        case .removeFromWishList:
            requestType = .delete
            requstParams["itemId"] = productID ?? ""
        default:
            break
        }
        
        self.callingHttpRequest(params: requstParams, method: requestType, apiName: apiName) { (data, json) in
            completion(data, json)
        }
    }
    
    private func callingHttpRequest(params: [String: Any], method: HTTPMethod, apiName: WhichApiCall, completion: @escaping (Bool, JSON) -> Void) {
        NetworkManager.sharedInstance.callingHttpRequest(params: params, method: method, apiname: apiName, currentView: UIApplication.shared.topViewController ?? UIViewController()) { [weak self] success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            guard let self = self else { return }
            if success == 1 {
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                if jsonResponse["success"].boolValue == true {
                    if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]) {
                        DBManager.sharedInstance.storeDataToDataBase(data: data, eTag: jsonResponse["eTag"].stringValue, hashKey: self.getProductCategoryHashKey())
                    }
                    self.doFurtherProcessingWithResult(apiName: apiName, data: jsonResponse) { success in
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
                self.callingHttppApi(apiName: apiName) {success,jsonResponse  in
                    completion(success, jsonResponse)
                }
            } else if success == 3 {   // No Changes
                let jsonResponse =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "checkoutAddressData"))
                self.doFurtherProcessingWithResult(apiName: apiName, data: jsonResponse) { success in
                    completion(success, jsonResponse)
                }
            }
        }
    }
    
    func doFurtherProcessingWithResult(apiName: WhichApiCall, data: JSON, completion: @escaping (Bool) -> Void) {
        switch apiName {
        case .categoryProductList:
            self.categories.removeAll()
            if page > 1 {
                self.categoryProductsModal.productList! += (CategoryProductsModal(json: data)).productList ?? []
            } else {
                self.categoryProductsModal = CategoryProductsModal(json: data)
            }
            if let banner = categoryProductsModal.bannerImage, banner.count > 0 {
                self.categories.append(banner)
                self.dominantColor = categoryProductsModal.dominantColor
            } else {
                sortFilterHeight.constant = 56
            }
            completion(true)
       
        case .addToWishList:
            if data["success"].boolValue == true {
                ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: "Product added to wishlist".localized)
                completion(true)
            } else {
                ShowNotificationMessages.sharedInstance.warningView(message: "errorwishlist".localized)
                completion(false)
            }
        case .removeFromWishList:
            if data["success"].boolValue == true {
                ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: data["message"].stringValue)
                completion(true)
            } else {
                ShowNotificationMessages.sharedInstance.warningView(message: "errorwishlist".localized)
                completion(false)
            }
        default:
            completion(false)
        }
    }
    
    func getProductCategoryHashKey() -> String {
        var valuesForHashkeys = [String]()
        valuesForHashkeys.append(Defaults.storeId)
        valuesForHashkeys.append(Defaults.quoteId)
        valuesForHashkeys.append(Defaults.customerToken ?? "")
        valuesForHashkeys.append(Defaults.currency ?? "")
        valuesForHashkeys.append(categoryType ?? "")
        valuesForHashkeys.append(categoryId ?? "33")
        return NetworkManager.sharedInstance.getHashKey(forView: "productCategory", keys: valuesForHashkeys)
    }
}

extension CategoryProductsViewModal: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoryProductsModal.productList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch self.productDegisn {
        case .grid?:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridProductCollectionViewCell.identifier, for: indexPath) as? GridProductCollectionViewCell,
                let item = self.categoryProductsModal.productList?[indexPath.row] {
                cell.tag = indexPath.row
                cell.delegate = self
                cell.item = item
                cell.layoutSubviews()
                return cell
            }
        case .list?:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListProductCollectionViewCell.identifier, for: indexPath) as? ListProductCollectionViewCell,
                let item = self.categoryProductsModal.productList?[indexPath.row] {
                cell.tag = indexPath.row
                cell.delegate = self
                cell.item = item
                cell.layoutSubviews()
                return cell
            }
        case .none:
            break
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch self.productDegisn {
        case .grid?:
            return CGSize(width: self.productsCollectionView.frame.width/2, height: self.productsCollectionView.frame.width/2 + 90)
        case .list?:
            return CGSize(width: self.productsCollectionView.frame.width, height: 160)
        case .none:
            break
        }
        return CGSize(width: self.productsCollectionView.frame.width/2 + 1, height: self.productsCollectionView.frame.width/2 + 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let height = categories.count > 0 ? ((AppDimensions.screenWidth*2) / 3) + 64:0
        return CGSize(width: self.productsCollectionView.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CategoryHeaderCollectionReusableView", for: indexPath) as? CategoryHeaderCollectionReusableView {
                headerView.sortFilterGridListView.shadowBorder()
                switch self.productDegisn {
                case .grid?:
                    headerView.sortFilterGridListView.gridListBtn.setTitle("grid".localized, for: .normal)
                    headerView.sortFilterGridListView.gridListBtn.setImage(UIImage(named: "grid"), for: .normal)
                case .list?:
                    headerView.sortFilterGridListView.gridListBtn.setTitle("list".localized, for: .normal)
                    headerView.sortFilterGridListView.gridListBtn.setImage(UIImage(named: "ic_list"), for: .normal)
                case .none:
                    break
                }
                if sortItem != nil {
                    headerView.sortFilterGridListView.sortApplyView.isHidden = false
                } else {
                    headerView.sortFilterGridListView.sortApplyView.isHidden = true
                }
                
                if  topIdArray.count > 0 {
                    headerView.sortFilterGridListView.filterApplyView.isHidden = false
                } else {
                    headerView.sortFilterGridListView.filterApplyView.isHidden = true
                }
                headerView.categories = self.categories
                headerView.dominantColor = self.dominantColor
                
                headerView.sortFilterGridListView.delegate = self.delegate
                headerView.categoryCollectionView.reloadData()
                return headerView
            }
            assert(false, "Unexpected element kind")
        default:
            assert(false, "Unexpected element kind")
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let productList = self.categoryProductsModal.productList {
            let products = productList[indexPath.row]
            moveDelegate?.moveController(id: products.entityId, name: products.name, dict: [:], jsonData: JSON.null, type: "", controller: AllControllers.productPage)
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.productsCollectionView &&   scrollView.contentOffset.y > scrollView.contentSize.height - productsCollectionView.frame.size.height - 50 { 
            if let currentProducts = self.categoryProductsModal.productList?.count, let totalProducts = self.categoryProductsModal.totalCount, currentProducts < totalProducts && pagination {
                pagination = false
                self.page += 1
                self.callingHttppApi(apiName: self.apiName) { [weak self] (success, _) in
                    guard let self = self else { return }
                    if success {
                        self.pagination = true
                        self.productsCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.productsCollectionView {
            if isVisible() {
                self.sortFilterHeight.constant = 0
            } else {
                self.sortFilterHeight.constant = 0
            }
        }
    }
    
    func isVisible() -> Bool {
        let index = IndexPath(row: 0, section: 0)
        if let headerView = productsCollectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: index) as? CategoryHeaderCollectionReusableView {
            func isVisible(view: UIView, inView: UIView?) -> Bool {
                guard let inView = inView else { return true }
                let viewFrame = inView.convert(view.bounds, from: view)
                if viewFrame.intersects(inView.bounds) {
                    return isVisible(view: view, inView: inView.superview)
                }
                return false
            }
            return isVisible(view: headerView, inView: headerView.superview)
        }
        return false
    }
}
