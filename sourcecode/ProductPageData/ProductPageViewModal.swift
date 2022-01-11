//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: ProductPageViewModal.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit
import MobileCoreServices
import Alamofire
import Realm
import RealmSwift

class ProductPageViewModal: NSObject {
    
    
    var uploadFileisVisible = false
    
    enum ProductPageApi {
        case getProduct
        case addToCart
        case addToWishlist
        case addToCompare
        case removeWishlist
        case notifyPrice
        case notifyStock
    }
    
    enum ProductPageType: String {
        case simple = "simple"
        case downloadable = "downloadable"
        case grouped = "grouped"
        case bundle = "bundle"
        case custom = "custom"
        case configurable = "configurable"
    }
    var itemId = ""
    var wishlistItemId = ""
    var addedToWishlist = false
    var parentController = ""
    var productId: String
    var whichApiCall: ProductPageApi = .getProduct
    var model: ProductPageModel!
    var quantityValue = 1
    var downloadableDict = [String: Any]()
    var groupedDict = [String: Any]()
    var bundleDict = [String: Any]()
    var bundleQtyDict = [String: Any]()
    var bundleSelectedRow = 0
    var configDict = [String: String]()
    var customDict = [String: Any]()
    var customDataDict = [String: FileInfo]()
    var customSelectedRow = 0
    var unselectedValues = [String]()
    var productItems = [ProductViewModalItem]()
    weak var delegate: ShareClicked?
    weak var moveDelegate: MoveFromProductController?
    var moveToCart = false
    weak var cartBtn: BadgeBarButtonItem!
    var productType: ProductPageType = .simple
    var wishlistProductId = ""
    var reloadSections: ((_ section: Int, _ makeScroll: Bool) -> Void)?
    var reloadSectionsWithoutAnimation: ((_ section: Int) -> Void)?
    var reloadWithoutAnimation: ((_ section: Int) -> Void)?
    var reloadTableView: ((_ reloadType: ReloadType) -> Void)?
    var collapseDescription = false
    var collapseFeatures = false
    var collapseReviews = false
    var customSection: Int? = nil
    var spinner = UIActivityIndicatorView(style: .gray)
    var productImageCount = 0
    var originalImages = [ImageGallery]()
    var optionProductId = ""
    var conditionforradiobtn = false

   
    
    init(productId: String) {
        self.productId =  productId
        self.wishlistProductId = productId
    }
    
    func loadData (completion: (Bool) -> Void) {
        if let database =  DBManager.sharedInstance.database,
            let data = database.object(ofType: ProductDataModel.self, forPrimaryKey: productId),
            let stringData = (data.data) {
            let jsonResponse = JSON(data: Data(stringData.utf8))
            doFurtherProcessingWithResult(data: jsonResponse) { success in
                completion(success)
            }
        }
    }
    
    func callingHttppApi(completion: @escaping (Bool) -> Void) {
        var verbs: HTTPMethod = .get
        var apiName: WhichApiCall = .productPage
        var requstParams = [String: Any]()
        requstParams["storeId"] = Defaults.storeId
        requstParams["width"] = UrlParams.width
        requstParams["quoteId"] = Defaults.quoteId
        requstParams["customerToken"] = Defaults.customerToken
        requstParams["productId"] = productId
        switch whichApiCall {
        case .getProduct:
            NetworkManager.sharedInstance.dismissLoader()
            spinner.startAnimating()
            verbs = .get
        case .addToCart:
            NetworkManager.sharedInstance.showLoader()
            requstParams["qty"] = quantityValue
            if downloadableDict.count > 0 {
                requstParams["params"] = ["links": downloadableDict].convertDictionaryToString()
            }
            if groupedDict.count > 0 {
                requstParams["params"] = ["super_group": groupedDict].convertDictionaryToString()
            }
            if bundleDict.count > 0 {
                print(self.getBundleQty())
                print(bundleDict)
                requstParams["params"] = ["bundle_option": bundleDict, "bundle_option_qty": self.getBundleQty()].convertDictionaryToString()
            }
            if configDict.count > 0 {
                requstParams["params"] = ["super_attribute": configDict].convertDictionaryToString()
            }
            if customDict.count > 0 {
                requstParams["params"] = ["options": customDict].convertDictionaryToString()
            }
            if parentController == "cart" {
                apiName = .updateitemoptions
                requstParams["itemId"] = itemId
            } else {
                apiName = .addToCart
            }
            verbs = .post
        case .addToWishlist:
            NetworkManager.sharedInstance.showLoader()
            requstParams["productId"] = wishlistProductId
            if downloadableDict.count > 0 {
                requstParams["params"] = ["links": downloadableDict].convertDictionaryToString()
            }
            if groupedDict.count > 0 {
                requstParams["params"] = ["super_group": groupedDict].convertDictionaryToString()
            }
            if bundleDict.count > 0 {
                print(self.getBundleQty())
                print(bundleDict)
                requstParams["params"] = ["bundle_option": bundleDict, "bundle_option_qty": self.getBundleQty()].convertDictionaryToString()
            }
            if configDict.count > 0 {
                requstParams["params"] = ["super_attribute": configDict].convertDictionaryToString()
            }
            if customDict.count > 0 {
                requstParams["params"] = ["options": customDict].convertDictionaryToString()
            }
            apiName = .addToWishlist
            verbs = .post
        case .addToCompare:
            NetworkManager.sharedInstance.showLoader()
            apiName = .addToCompare
            verbs = .post
        case .removeWishlist:
            NetworkManager.sharedInstance.showLoader()
            apiName = .removeFromWishList
            requstParams["itemId"] = wishlistItemId
            verbs = .delete
        case .notifyPrice:
            NetworkManager.sharedInstance.showLoader()
            apiName = .notifyPrice
            verbs = .post
        case .notifyStock:
            NetworkManager.sharedInstance.showLoader()
            apiName = .notifyStock
            verbs = .post
        }
        requstParams["eTag"] = DBManager.sharedInstance.geteTagFromDataBase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "productPageData"))
        
        if self.customDataDict.count > 0 && apiName == .addToCart {
            var files = [FileInfo]()
            for (_, value) in self.customDataDict {
                files.append(value)
            }
            NetworkManager.sharedInstance.uploadMultipleFilesToServer(dict: requstParams, apiCall: apiName, fileInfo: files) { [weak self] success, responseObject  in
                NetworkManager.sharedInstance.dismissLoader()
                if success {
                    self?.doFurtherProcessingWithResult(data: responseObject) { success in
                        completion(success)
                    }
                }
            }
        } else {
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: verbs, apiname: apiName, currentView: UIViewController()) { [weak self] success, responseObject  in
            if self?.whichApiCall != .getProduct && self?.whichApiCall != nil {
                NetworkManager.sharedInstance.dismissLoader()
            }
            if success == 1 {
                self?.spinner.stopAnimating()                
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                if jsonResponse["success"].boolValue == true {
                    if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]) {
                        DBManager.sharedInstance.storeDataToDataBase(data: data, eTag: jsonResponse["eTag"].stringValue, hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "productPageData"))
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
                if self?.whichApiCall != .getProduct && self?.whichApiCall != nil {
                    NetworkManager.sharedInstance.dismissLoader()
                }
                self?.callingHttppApi {success in
                    completion(success)
                }
            } else if success == 3 {   // No Changes
                let jsonResponse =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "productPageData"))
                self?.doFurtherProcessingWithResult(data: jsonResponse) { success in
                    completion(success)
                }
            }
        }
        }
    }
    
    func doFurtherProcessingWithResult(data: JSON, completion: (Bool) -> Void) {
        switch whichApiCall {
        case .getProduct:
            model = ProductPageModel(json: data)
            self.drawProductPage(model: model)
            do {
                try DBManager.sharedInstance.database?.write {
                    DBManager.sharedInstance.database?.add(ProductDataModel(data: data.description, productId: self.productId),update: .all)
                    //                    if let data = self.getProductDataFromDB(), data.count >= 10 {
                    //                        DBManager.sharedInstance.database?.delete(data[9])
                    //                        DBManager.sharedInstance.database?.add(Productcollection(value: data), update: true)
                    //                        print("Deleted than Added new object")
                    //                    } else {
                    DBManager.sharedInstance.database?.add(Productcollection(value: data), update: .all)
                    print("Added new object")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateRecentlyViewed"), object: nil)
                    //                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        case .addToCart:
            print(data)
            if data["success"].boolValue {
                ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: data["message"].stringValue)
                (Defaults.cartBadge) = data["cartCount"].stringValue
                self.cartBtn.badgeNumber = Int(Defaults.cartBadge) ?? 0
                if data["quoteId"].stringValue.count > 0  {
                    Defaults.quoteId = data["quoteId"].stringValue
                }
                if self.moveToCart {
                    if Defaults.customerToken == nil {
                        self.moveDelegate?.move(id: "", controller: .addToCart)
                    } else {
                        if data["isVirtual"].boolValue {
                            self.moveDelegate?.move(id: "dfd", controller: .checkout)
                        } else {
                            self.moveDelegate?.move(id: "", controller: .checkout)
                        }
                    }
                } else if parentController == "cart" {
                    self.moveDelegate?.move(id: "", controller: .none)
                }
            } else {
                ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
            }
        case .addToWishlist:
            print(data)
            if data["success"].boolValue {
                let message = data["message"].stringValue.count > 0 ?  data["message"].stringValue : "Product added to wishlist".localized
                ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: message )
                wishlistItemId = data["itemId"].stringValue
                addedToWishlist = true
            } else {
                ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
            }
        case .addToCompare:
            print(data)
            if data["success"].boolValue {
                ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: data["message"].stringValue)
            } else {
                ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
            }
        case .removeWishlist:
            print(data)
            if data["success"].boolValue {
                let message = data["message"].stringValue.count > 0 ?  data["message"].stringValue : "Product deleted from wishlist".localized
                ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: message )
                wishlistItemId = ""
                addedToWishlist = false
            } else {
                ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
            }
        case .notifyPrice, .notifyStock:
            if data["success"].boolValue {
                let message = data["message"].stringValue
                ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: message )
            } else {
                ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
            }
        }
        completion(true)
    }
    
    func drawProductPage(model: ProductPageModel) {
        self.productItems.removeAll()
        if let imageGallery = model.imageGallery, imageGallery.count > 0 {
            self.productImageCount = imageGallery.count
            var offer = ""
            if model.showSpecialPrice {
                offer = "OFFER".localized
            }
            self.originalImages = imageGallery
            self.productItems.append(ProductViewModalbannerItem(images: imageGallery, offer: offer))
        }
        self.addedToWishlist = model.isInWishlist
        self.wishlistItemId = model.wishlistItemId
        self.productItems.append(ProductViewModalNamePriceItem(data: model))
        
        if let tierPrice = model.tierPrice, tierPrice.count > 2 {
            self.productItems.append(ProductViewModalTierPriceItem(tierPrice: tierPrice))
        }
        
        if let rating = model.rating {
            let numberOfReviews = model.reviewCount + " " + "Reviews".localized
            self.productItems.append(ProductViewModalRatingDataItem(rating: rating, numberOfReviews: numberOfReviews, guestCanReview: model.guestCanReview ?? false))
        }
        
        if let availability = model.availability{
            let showPriceDown = model.showPriceDropAlert ?? false
            let showOutofStock = (model.isAvailable ?? false) && (model.showBackInStockAlert ?? false)
            self.productItems.append(ProductViewModalStockItem(stock: availability, showPriceDown: showPriceDown, showOutofStock: showOutofStock))
        }
        
        self.productItems.append(ProductViewModalActionsItem())
        if let shortDescription = model.shortDescription, shortDescription.count > 2 {
            self.productItems.append(ProductViewModalShortDescriptionItem(shortDescription: shortDescription))
        }
        
        if let samples = model.samples, samples.linkSampleData.count > 0 {
            self.productItems.append(ProductViewModalSampleDownloadableItem(samples: samples ))
        }
        
        if let links = model.links {
            productType = .downloadable
            self.productItems.append(ProductViewModalLinksDownloadableItem(links: links ))
        }
        
        if model.groupedData.count > 0 {
            productType = .grouped
            let val = ProductViewModalGroupedItem(gropedData: model.groupedData)
            self.productItems.append(val )
            self.groupedDict = val.groupedDict
        }
        
        if model.bundleOptions.count > 0 {
            productType = .bundle
            self.productItems.append(ProductViewModalBundleItem(bundleData: model.bundleOptions) )
        }
        
        if let configurableData = model.configurableData, configurableData.attributes.count > 0 {
            productType = .configurable
            self.productItems.append(ProductViewModalConfigurableItem(configurableData: configurableData))
//            for item in configurableData.attributes {
//                if let parentId = item.id {
//                    if item.options.count > 0 {
//                        configDict[parentId] = item.options[0].id
//                        if let json = configurableData.index.data(using: String.Encoding.utf8) {
//                            let indexData = JSON(data: json)
//                            self.gettingConfigurablData(data: configDict, unselectedValues: [], productId: self.getProductId(indexData: indexData), optionProductId: item.options[0].products.first)
//                        }
//                    }
//                }
//            }
        }
        
        if let customOptions = model.customOptions, customOptions.count > 0 {
            productType = .custom
            self.productItems.append(ProductViewModalCustomOptionItem(customOptions: customOptions))
        }
        
        

        if model.groupedData.count == 0 {
            self.productItems.append(ProductViewModalQuantityItem())
        }
        
        self.productItems.append(ProductViewModalBuyNowItem())
        if let descriptionValue =  model.descriptionValue, descriptionValue.count > 0 {
            self.productItems.append(ProductViewModalDescriptionItem(descriptionheading: "Details".localized, description: descriptionValue))
        }
        
        if let additionalInf = model.additionalInformation, additionalInf.count > 0 {
            self.productItems.append(ProductViewModalFeaturesItem(featuresheading: "More Information".localized, additionalInf: additionalInf))
        }
        
        if let reviewList = model.reviewList, reviewList.count > 0 {
            self.productItems.append(ProductViewModalReviewsItem(reviewsheading: "Reviews".localized, reviewList: reviewList, guestCanReview: model.guestCanReview ?? false))
        }
        
        if let related = model.relatedProductList, related.count > 0 {
            self.productItems.append(ProductViewModalRelatedProductsItem(relatedheading: "Products you might like".localized, relatedList: related))
        }
        
        if let upsell = model.upsellProductList, upsell.count > 0 {
            self.productItems.append(ProductViewModalUpSellProductsItem(upSellheading: "We found other Products you might like".localized, upSellList: upsell))
        }
    }
    
    func getProductId(indexData: JSON) -> String? {
        var selectedArray = [JSON]()
        for (key, value) in configDict {
            selectedArray += (self.gettingCommonIndex(key: key, value: value, indexData: indexData))
        }
        var val: String? = nil
        while let c = selectedArray.popLast()  {
            selectedArray.forEach() {
                if $0 == c {
                    Swift.print("Duplication: \(c)")
                    val = c["product"].stringValue
                }
            }
        }
        return val
    }
    
    func gettingCommonIndex(key: String, value: String, indexData: JSON) -> [JSON] {
        let arr = indexData.arrayValue
        return arr.filter { $0[key].stringValue ==  value }
    }
    
    func getProductDataFromDB() -> [Productcollection]? {
        if  let results: Results<Productcollection> = DBManager.sharedInstance.database?.objects(Productcollection.self) {
            return ((Array(results)).sorted(by: { $0.dateTime.compare($1.dateTime) == .orderedDescending }))
        } else {
            return nil
        }
    }
    
    func deleteAllRecentViewProductData() {
        let results: Results<Productcollection> = DBManager.sharedInstance.database!.objects(Productcollection.self)
        for obj in results {
            do {
                try DBManager.sharedInstance.database?.write {
                    DBManager.sharedInstance.database?.delete(obj)
                }
            } catch {
                print("Error occurred \(error)")
            }
        }
    }
}

// MARK: Actions performing
extension ProductPageViewModal {
    func wishlistClicked(completion: @escaping (Bool) -> Void) {
        if Defaults.customerToken != nil {
            if addedToWishlist {
                self.whichApiCall = .removeWishlist
            } else {
                self.whichApiCall = .addToWishlist
                
            }
            self.callingHttppApi { (success) in
                print(success)
                completion(success)
            }
        } else {
            self.moveDelegate?.move(id: "", controller: .signInController)
        }
    }
    
    func compareClicked() {
        self.whichApiCall = .addToCompare
        self.callingHttppApi { (success) in
            print(success)
        }
    }
    
    func shareClicked() {
        delegate?.shareClicked(productLink: model.productUrl)
    }
    
}

// MARK: Collecting Data
extension ProductPageViewModal: GettingProductQuantity {
    func gettingProductQuantity(qty: Int) {
        self.quantityValue = qty
    }
}

extension ProductPageViewModal: AddToCartProduct {
    func addToCartProduct(cart: Bool) {
        if self.checkingCartOptionsValidity() {
            moveToCart = cart
            self.whichApiCall = .addToCart
            self.callingHttppApi { (success) in
                print(success)
            }
        }
    }
    
    func checkingCartOptionsValidity() -> Bool {
        switch productType {
        case .configurable:
            return self.configurableValidity()
        case .downloadable:
            return self.downloadableValidity()
        default:
            return true
        }
    }
    
    func configurableValidity() -> Bool {
        if let configurableData = model.configurableData {
            let keyArray  = Array(configDict.keys)
            var val: String? = nil
            for i in 0..<configurableData.attributes.count {
                if !keyArray.contains(configurableData.attributes[i].id)   {
                    val = configurableData.attributes[i].label
                    break
                }
            }
            if let val = val {
                let string = val + " " + "is a required field".localized
                ShowNotificationMessages.sharedInstance.warningView(message: string)
                return false
            }
        }
        return true
    }
    
    func downloadableValidity() -> Bool {
        if let links = model.links, let keyArray  = Array(downloadableDict.values) as? [String] {
            var val: String? = nil
            if links.linksPurchasedSeparately == "1" {
                for i in 0..<links.linkData.count {
                    if !keyArray.contains(links.linkData[i].id)   {
                        val = links.title
                    } else {
                        val = nil
                        break
                    }
                }
            }
            if let val = val {
                let string = val + " " + "is a required field".localized
                ShowNotificationMessages.sharedInstance.warningView(message: string)
                return false
            }
        }
        return true
    }
    
    func getBundleQty() -> [String: Any] {
        var newBundleQtyDict = [String: Any]()
        let arr = Array(bundleDict.values)
        for i in 0..<arr.count {
            if let keyType = arr[i] as? String, let val = bundleQtyDict[keyType] {
                for (key, value) in bundleDict {
                    if let value = value as? String, value == keyType {
                        newBundleQtyDict[key] = val
                    }
                }
            }
        }
        
        for (key, _) in bundleDict {
            if newBundleQtyDict[key] == nil {
                let bundleOptions = model.bundleOptions
                if let index = bundleOptions.firstIndex(where: { $0.optionId == key }),
                    let index1 = bundleOptions[index].optionValues.firstIndex(where: { $0.isDefault == "1" }) {
                    newBundleQtyDict[key] = bundleOptions[index].optionValues[index1].defaultQty
                }
            }
            
        }
        return newBundleQtyDict
    }
}

extension ProductPageViewModal: GettingDownloadableData {
    func gettingDownloadableData(data: [String: Any]) {
        downloadableDict = data
    }
}

extension ProductPageViewModal: GettingGroupedData {
    func gettingGroupedData(data: [String: Any], section: Int) {
        self.groupedDict = data
        self.reloadSectionsWithoutAnimation?(section)
    }
}

extension ProductPageViewModal: GettingBundleData, GettingImageOptions {
    
    func gettingBundleData(visible: Bool) {
        
        if visible{
             self.uploadFileisVisible = true
        }else{
              self.uploadFileisVisible = false
        }
      
    }
    
    func gettingBundleData(data: [String : Any], qtyDict: [String : Any], selectedItem: Int) {
        
        
        
        self.bundleDict = data
        self.bundleQtyDict = qtyDict
        self.bundleSelectedRow = selectedItem
        
    }    
}

extension ProductPageViewModal: GettingConfigurableData {
    func gettingConfigurablData(data: [String : String], unselectedValues: [String], productId: String?, optionProductId: String?) {
        self.configDict = data
        self.unselectedValues = unselectedValues
        print(productId, optionProductId)
        if let optionProductId = optionProductId {
            self.optionProductId = optionProductId
            self.reloadTableView?(.price)
        }
        if let productId = productId, let configurableData = model.configurableData , let json = configurableData.images.data(using: String.Encoding.utf8) {
            print( JSON(data: json))
            let jsonData = JSON(data: json)
            if let array = jsonData[productId].array, array.count > 0 {
                if let item =  self.productItems[0] as? ProductViewModalbannerItem {
                    let arr = array.map {(ImageGallery(json: $0))}
                    item.updateImages(data: arr + self.originalImages)
                    self.reloadTableView?(.updateImage)
                }
            }
        } else {
            if let item =  self.productItems[0] as? ProductViewModalbannerItem {
                item.updateImages(data: self.originalImages)
                self.reloadTableView?(.updateImage)
            }
        }
    }
}

extension ProductPageViewModal: GettingCustomData,GetradioData {
    
    func getradiovalue(value: Bool, valueNumber: String) {
        
        self.conditionforradiobtn = value
        
        if valueNumber == "42"{
            
            self.uploadFileisVisible = true
            
        }else if valueNumber == "43"{
            
            self.uploadFileisVisible = false
            
        }
        
    }
    
    
    func gettingCustomData(data: [String: Any]) {
        self.customDict = data
        print(self.customDict)
        if let section = self.customSection {
            reloadSectionsWithoutAnimation?(section)
        }
    }
    
    func gettingCustomFileData(data: [String: FileInfo]) {
        self.customDataDict = data
        print(self.customDataDict)
    }
}

extension Dictionary where Value: Equatable {
    func allKeys(forValue val: Value) -> Key? {
        let arr = (self.filter { $1 == val }.map { $0.0 })
        if arr.count > 0 {
            return arr[0]
        } else {
            return nil
        }
    }
}

enum ReloadType {
    case updateImage
    case price
    case none
}
