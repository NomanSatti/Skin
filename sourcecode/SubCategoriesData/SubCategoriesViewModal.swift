//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: SubCategoriesViewModal.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit

class SubCategoriesViewModal: NSObject {
    
    var categoryId: String
    var categoryName: String
    var model: SubCategoryModel!
    var items = [SubCategoryViewModalItem]()
    weak var delegate: SubCategoryDelegate?
    
    init(categoryId: String, categoryName: String) {
        self.categoryId = categoryId
        self.categoryName = categoryName
    }
    
    func callingHttppApi(completion: @escaping (Bool) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        
        requstParams["storeId"] = Defaults.storeId
        requstParams["width"] = UrlParams.width
        requstParams["quoteId"] = Defaults.quoteId
        requstParams["categoryId"] = categoryId
        requstParams["currency"] = Defaults.currency
        requstParams["quoteId"] = Defaults.quoteId
        
        requstParams["eTag"] = DBManager.sharedInstance.geteTagFromDataBase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "subCategoryData"))
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .get, apiname: .subCategoryData, currentView: UIViewController()) { [weak self]
            success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            if success == 1 {                
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                if jsonResponse["success"].boolValue == true {
                    if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]) {
                        DBManager.sharedInstance.storeDataToDataBase(data: data, eTag: jsonResponse["eTag"].stringValue, hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "subCategoryData"))
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
                let jsonResponse =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "subCategoryData"))
                self?.doFurtherProcessingWithResult(data: jsonResponse) { success in
                    completion(success)
                }
                
            }
        }
    }
    
    func doFurtherProcessingWithResult(data: JSON, completion: (Bool) -> Void) {
        model = SubCategoryModel(json: data)
        if model.bannerImage.count > 0 {
            items.append(SubCategoryViewModalBannerItem(banner: model.bannerImage))
        }
        
        if model.productList.count > 0 {
            //items.append(SubCategoryViewModalProductItem(productHeading: categoryName + "'s".localized + "Products".localized, productList: model.productList))
            items.append(SubCategoryViewModalProductItem(productHeading: "Products".localized, productList: model.productList))
        }
        
        if model.hotSeller.count > 0 {
            items.append(SubCategoryViewModalHotSellerItem(productHeading: "Hot Seller".localized, productList: model.hotSeller))
        }
        
        if model.categories.count > 0 {
            items.append(SubCategoryViewModalCategoriewsItem(categoryHeading: "Explore".localized + " " + categoryName, categoryList: model.categories))
        }
        
        completion(true)
    }
    
}

extension SubCategoriesViewModal: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = items[indexPath.section]
        
        switch item.type {
        case .banner:
            if let cell: HomeBannerTableViewCell = tableView.dequeueReusableCell(with: HomeBannerTableViewCell.self, for: indexPath),
                let item = item as? SubCategoryViewModalBannerItem {
                cell.bannerCollection.tag = indexPath.section
                cell.banner = item.banner
                cell.layoutIfNeeded()
                return cell
            }
            
        case .product:
            if let cell: RelatedProductTableViewCell = tableView.dequeueReusableCell(with: RelatedProductTableViewCell.self, for: indexPath),
                let items = item as? SubCategoryViewModalProductItem {
                cell.selectionStyle = .none
                cell.headingLabelClicked.text = items.productHeading.uppercased()
                cell.relatedList = items.productList
                cell.viewAllBtn.isHidden = false
                cell.viewAllBtn.addTapGestureRecognizer {
                    self.delegate?.moveToCategory(id: self.categoryId, name: self.categoryName, hasChildren: false)
                }
                cell.collectionView.reloadData()
                tableView.separatorStyle = .singleLine
                return cell
            }
        case .hotSeller:
            if let cell: RelatedProductTableViewCell = tableView.dequeueReusableCell(with: RelatedProductTableViewCell.self, for: indexPath),
                let items = item as? SubCategoryViewModalHotSellerItem {
                cell.selectionStyle = .none
                cell.viewAllBtn.isHidden = true
                cell.headingLabelClicked.text = items.productHeading.uppercased()
                cell.relatedList = items.productList
                cell.collectionView.reloadData()
                tableView.separatorStyle = .singleLine
                return cell
            }
            
        case .categories:
            if let items = item as? SubCategoryViewModalCategoriewsItem {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
                cell.textLabel?.text = items.categoryList[indexPath.row].name.uppercased()
                cell.accessoryType = .disclosureIndicator
                tableView.separatorStyle = .none
                if Defaults.language == "ar" {
                    cell.textLabel?.textAlignment = .right
                } else {
                    cell.textLabel?.textAlignment = .left
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let item = items[section]
        if item.type == .categories, let items = item as? SubCategoryViewModalCategoriewsItem {
            return items.heading.uppercased()
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let item = items[section]
        if item.type == .categories {
            return 44
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = items[indexPath.section]
        switch item.type {
        case .banner:
            return 2*AppDimensions.screenWidth / 3
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.section]
        if item.type == .categories, let items = item as? SubCategoryViewModalCategoriewsItem {
            delegate?.moveToCategory(id: items.categoryList[indexPath.row].id, name: items.categoryList[indexPath.row].name, hasChildren: items.categoryList[indexPath.row].hasChildren)
        }
    }
    
}

enum SubCategoryType {
    case banner
    case product
    case hotSeller
    case categories
}

protocol SubCategoryViewModalItem {
    var type: SubCategoryType { get }
    var rowCount: Int { get }
}

class SubCategoryViewModalBannerItem: SubCategoryViewModalItem {
    var type: SubCategoryType {
        return .banner
    }
    var rowCount: Int {
        return 1
    }
    var banner: [BannerImage]
    
    init(banner: [BannerImage]) {
        self.banner = banner
    }
}

class SubCategoryViewModalProductItem: SubCategoryViewModalItem {
    
    var type: SubCategoryType {
        return .product
    }
    var heading: String {
        return productHeading
    }
    
    var rowCount: Int {
        return 1
    }
    
    var productHeading: String
    var productList: [RelatedProductList]
    
    init(productHeading: String, productList: [RelatedProductList]) {
        self.productHeading = productHeading
        self.productList = productList
    }
}

class SubCategoryViewModalHotSellerItem: SubCategoryViewModalItem {
    
    var type: SubCategoryType {
        return .hotSeller
    }
    var heading: String {
        return productHeading
    }
    
    var rowCount: Int {
        return 1
    }
    
    var productHeading: String
    var productList: [RelatedProductList]
    
    init(productHeading: String, productList: [RelatedProductList]) {
        self.productHeading = productHeading
        self.productList = productList
    }
}

class SubCategoryViewModalCategoriewsItem: SubCategoryViewModalItem {
    
    var type: SubCategoryType {
        return .categories
    }
    var heading: String {
        return categoryHeading
    }
    
    var rowCount: Int {
        return categoryList.count
    }
    
    var categoryHeading: String
    var categoryList: [Categories]
    
    init(categoryHeading: String, categoryList: [Categories]) {
        self.categoryHeading = categoryHeading
        self.categoryList = categoryList
    }
}

protocol SubCategoryDelegate: NSObjectProtocol {
    func moveToCategory(id: String, name: String, hasChildren: Bool)
}
