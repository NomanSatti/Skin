//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: HomeViewModel.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit
import Alamofire

class HomeViewModel: NSObject {
    
    var items = [HomeViewModelItem]()
    var featuredProductCollectionModel = [Products]()
    var letestProductCollectionModel = [Products]()
    var categories = [Categories]()
    var carouselObj = [Carousel]()
    var advertisement = [AdsImage]()
    var languageData = [Languages]()
    var homeViewController: ViewController!
    weak var homeTableviewheight: NSLayoutConstraint?
    weak var homeTableView: UITableView!
    var guestCheckOut: Bool!
    var categoryImage = [CategoryImages]()
    var storeData = [StoreData]()
    var cmsData = [CMSdata]()
    var websiteData = [WebsiteData]()
    var allowedCurrencies: [Currency]!
    weak var moveDelegate: MoveController?
    var themeCode = 2
    var isCustomBannerAdded = false
    
    func setupAdvertisementBanner(completionHandler: @escaping () -> ()){
        advertisement = [AdsImage]()
        let url: String = API_ROOT_DOMAIN + "rest/V1/get-advertisements"
              var request = URLRequest(url:  NSURL(string: url)! as URL)

              // Your request method type Get or post etc according to your requirement
              request.httpMethod = "GET"

              request.setValue("Bearer \(ADMIN_TOKEN)", forHTTPHeaderField: "Authorization")
              request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        
              Alamofire.request(request).responseJSON { (responseObject) -> Void in
                
                let json = JSON(responseObject.result.value)
               
                print(json)
                
                
                if let first = json.arrayValue.first{
                    
                    let response = first["response"]
                   
                    let data = response["data"]
                   
                    if let ads = data["advertisement"].array {
                        for ad in ads {
                            if let new = try? JSONDecoder().decode(AdsImage.self, from: ad.rawData()){
                                 self.advertisement.append(new)
                            }
                           
                        }
                        print(self.advertisement.count)
                        
                        
                        completionHandler()
                        self.homeTableView.reloadData()
                    }
                  
                   // print(banner)
                }
    
            }
            
    }
    
    
    func getDataFromDB(data: JSON, recentViewData: [Productcollection]?, completion:@escaping (_ data: Bool) -> Void) {
        
        guard let data = HomeModal(data: data) else {
            return
        }
        
        items.removeAll()
        self.themeCode = data.themeCode
        print(self.themeCode)
        
        if self.themeCode == 1 {
            if let bannerImage = data.bannerImages, bannerImage.count>0 {
                let bannerDataCollectionItem = HomeViewModelBannerItem(categories: bannerImage)
                self.items.append(bannerDataCollectionItem)
            }
         
            
            if data.featuredCategories.count > 0 {
                let featureCategoryCollectionItem = HomeViewModelFeatureCategoriesItem(categories: data.featuredCategories)
                self.items.append(featureCategoryCollectionItem)
            }
            
            if let carouselItems = data.carousel, carouselItems.count>0 {
                for i in 0 ..< carouselItems.count {
                    let carouselCollectionItem = HomeViewModelCarouselItem(categories: [carouselItems[i]])
                    self.items.append(carouselCollectionItem)
                }
            }
        } else {
            if data.featuredCategories.count > 0 {
                let featureCategoryCollectionItem = HomeViewModelFeatureCategoriesItem(categories: data.featuredCategories)
                self.items.append(featureCategoryCollectionItem)
            }
            
            if let bannerImage = data.bannerImages, bannerImage.count>0 {
                let bannerDataCollectionItem = HomeViewModelBannerItem(categories: bannerImage)
                self.items.append(bannerDataCollectionItem)
            }
         
            
            if let carouselItems = data.carousel, carouselItems.count>0 {
                for i in 0 ..< carouselItems.count {
                    let carouselCollectionItem = HomeViewModelCarouselItem(categories: [carouselItems[i]])
                    self.items.append(carouselCollectionItem)
                }
            }
        }
        if data.storeData.count > 0 {
            self.storeData = data.storeData
        }
        
        if data.websiteData.count > 0 {
            self.websiteData = data.websiteData
        }
        
        self.cmsData = data.cmsData
        
        self.allowedCurrencies = data.allowedCurrencies
        
        if data.categories.count > 0 {
            self.categories = data.categories
        }
        
        if data.categoryImages != nil {
            self.categoryImage = data.categoryImages
        }
        
        
        completion(true)
    }
    
    func getData(jsonData: JSON, recentViewData: [Productcollection]?, completion: @escaping(_ data: Bool) -> Void) {
        guard let data = HomeModal(data: jsonData) else {
            return
        }
        items.removeAll()
        self.themeCode = data.themeCode
        advertisement = [AdsImage]()
         self.setupAdvertisementBanner {
        if self.themeCode == 1 {
            if let bannerImage = data.bannerImages, bannerImage.count>0 {
                let bannerDataCollectionItem = HomeViewModelBannerItem(categories: bannerImage)
                self.items.append(bannerDataCollectionItem)
            }
            
            if data.featuredCategories.count > 0 {
                let featureCategoryCollectionItem = HomeViewModelFeatureCategoriesItem(categories: data.featuredCategories)
                self.items.append(featureCategoryCollectionItem)
            }
            
            if let carouselItems = data.carousel, carouselItems.count>0 {
                for i in 0 ..< carouselItems.count {
                    let carouselCollectionItem = HomeViewModelCarouselItem(categories: [carouselItems[i]])
                    self.items.append(carouselCollectionItem)
                }
            }
            
            if let recentViewData = recentViewData, recentViewData.count > 0 {
                let recents = HomeViewModelRecentViewItem(categories: recentViewData)
                self.items.append(recents)
            }
            print(self.items)
        } else {
            if data.featuredCategories.count > 0 {
                let featureCategoryCollectionItem = HomeViewModelFeatureCategoriesItem(categories: data.featuredCategories)
                self.items.append(featureCategoryCollectionItem)
            }
            
            if let carouselItems = data.carousel, carouselItems.count>0 {
                for i in 0 ..< carouselItems.count {
                    let carouselCollectionItem = HomeViewModelCarouselItem(categories: [carouselItems[i]])
                    self.items.append(carouselCollectionItem)
                }
            }
            
            if let bannerImage = data.bannerImages, bannerImage.count>0 {
                let bannerDataCollectionItem = HomeViewModelBannerItem(categories: bannerImage)
                self.items.append(bannerDataCollectionItem)
            }
          
                if self.advertisement.count>0 {
                    //  let adsImage = AdsImage(json: )
                    let adsDataCollectionItem = HomeViewModelAdvertisementItem(image: self.advertisement) //HomeViewModelBannerItem(categories: bannerImage)
                    self.items.appendAtBeginning(newItem: adsDataCollectionItem)
                    
                    self.isCustomBannerAdded = true
                }
            
            
            
            if let recentViewData = recentViewData, recentViewData.count > 0 {
                let recents = HomeViewModelRecentViewItem(categories: recentViewData)
                self.items.append(recents)
            }
            print(self.items)
        }
        
        if data.categories != nil {
            self.categories = data.categories
        }
        if data.websiteData.count > 0 {
            self.websiteData = data.websiteData
        }
        
        self.allowedCurrencies = data.allowedCurrencies
        
        if data.storeData.count > 0 {
            self.storeData = data.storeData
        }
        
        if data.categoryImages != nil {
            self.categoryImage = data.categoryImages
        }
        
        self.cmsData = data.cmsData
        
        completion(true)
    }
        
    }
    
    func updateRecentlyViewed(recentViewData: [Productcollection]?, completion:(_ section: Int?) -> Void) {
        var haveRecentObject = false
        if let recentViewData = recentViewData, recentViewData.count > 0 {
            for item in items where item.type == .recentViewData {
                haveRecentObject = true
                if let item = item as? HomeViewModelRecentViewItem {
                    item.recentViewProductData = recentViewData
                }
                if let index = items.firstIndex(where: {$0.type == item.type}) {
                    completion(index)
                }
            }
            if !haveRecentObject {
                let recents = HomeViewModelRecentViewItem(categories: recentViewData)
                items.append(recents)
                completion(nil)
            }
        }
    }
    
    func setWishListFlagToFeaturedProductModel(data: Bool, pos: Int) {
        featuredProductCollectionModel[pos].isInWishList = data
    }
    
    func setWishListItemIdToFeaturedProductModel(data: String, pos: Int) {
        featuredProductCollectionModel[pos].wishlistItemId = data
    }
    
    func setWishListFlagToLatestProductModel(data: Bool, pos: Int) {
        letestProductCollectionModel[pos].isInWishList = data
    }
    
    func setWishListItemIdToLatestProductModel(data: String, pos: Int) {
        letestProductCollectionModel[pos].wishlistItemId = data
    }
}

extension HomeViewModel: UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item = items[section]
        switch item.type {
        case .carousel:
            return 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let item = items[indexPath.section]
        
     
        switch item.type {
            
//        case .offerBanner:
//            if let cell = tableView.dequeueReusableCell(withIdentifier: "OfferBannerCellTableViewCell") as? OfferBannerCellTableViewCell {
//                cell.selectionStyle = .none
//                cell.homeViewController = self.homeViewController
//
//            }
            
        case .advertisement:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AdvertisementTableViewCell") as? AdvertisementTableViewCell {
                cell.selectionStyle = .none
                cell.homeViewController = self.homeViewController
                //let model = ((item as? HomeViewModelBannerItem)?.bannerCollectionModel)!
                
                cell.adsCollectionModel = ((item as? HomeViewModelAdvertisementItem)?.adsCollectionModel)!
                cell.textTitleLabel.text = "Advertisements".localized.uppercased()
                cell.frame = tableView.bounds
                cell.layoutIfNeeded()
                cell.adsCollectionView.reloadData()
                //cell.bannerCollectionViewHeight.constant = cell.bannerCollectionView.collectionViewLayout.collectionViewContentSize.height
                
                return cell
            }
                    
        case .banner:
            if self.themeCode == 1 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: SliderTableViewCell.identifier) as? SliderTableViewCell {
                    cell.selectionStyle = .none
                    cell.bannerCollectionModel = ((item as? HomeViewModelBannerItem)?.bannerCollectionModel)!
                    cell.sliderCollectionView.reloadData()
                    return cell
                }
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: BannerTableViewCell.identifier) as? BannerTableViewCell {
                    cell.selectionStyle = .none
                    cell.bannerCollectionModel = ((item as? HomeViewModelBannerItem)?.bannerCollectionModel)!
                    cell.textTitleLabel.text = "Offers for you".localized.uppercased()
                    cell.frame = tableView.bounds
                    cell.layoutIfNeeded()
                    cell.bannerCollectionView.reloadData()
                    cell.bannerCollectionViewHeight.constant = cell.bannerCollectionView.collectionViewLayout.collectionViewContentSize.height
                    return cell
                }
            }
        case .featureCategory:
            if let cell = tableView.dequeueReusableCell(withIdentifier: TopCategoryTableViewCell.identifier) as? TopCategoryTableViewCell {
                cell.featureCategoryCollectionModel = ((item as? HomeViewModelFeatureCategoriesItem)?.featureCategories)!
                cell.themeCode = self.themeCode
                cell.selectionStyle = .none
                cell.delegate = homeViewController
                cell.categoryCollectionView.reloadData()
                return cell
            }
        case .recentViewData:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentHorizontalTableViewCell.identifier) as? RecentHorizontalTableViewCell,
                let carouselItem = (item as? HomeViewModelRecentViewItem) else { return UITableViewCell() }
            cell.obj = self
            cell.selectionStyle = .none
            cell.products =  carouselItem.recentViewProductData
            cell.delegate = homeViewController
            cell.productCollectionView.reloadData()
            return cell
        case .carousel:
            let carouselItem = ((item as? HomeViewModelCarouselItem)?.carouselCollectionModel)![indexPath.row]
            print("layoutType: ", carouselItem.layoutType as Any)
            if carouselItem.type == CarouselType.product.rawValue {
                if carouselItem.layoutType == 1 {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier) as? ProductTableViewCell else { return UITableViewCell() }
                    cell.obj = self
                    cell.selectionStyle = .none
                    cell.carouselCollectionModel = carouselItem
                    cell.delegate = homeViewController
                    cell.titleLabel.text = carouselItem.label!.uppercased()
                    self.homeTableviewheight?.constant = tableView.contentSize.height
                    cell.frame = tableView.bounds
                    cell.layoutIfNeeded()
                    cell.productCollectionView.reloadData()
                    cell.collectionViewheight.constant = cell.productCollectionView.collectionViewLayout.collectionViewContentSize.height
                    cell.viewAllButton.setTitle("viewall".localized.uppercased() + " " + carouselItem.label!.uppercased(), for: .normal)
                    return cell
                } else if carouselItem.layoutType == 2 {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCellLayout2.identifier) as? ProductTableViewCellLayout2 else { return UITableViewCell() }
                    cell.obj = self
                    cell.selectionStyle = .none
                    cell.titleNameLabel.text = carouselItem.label!.uppercased()
                    cell.carouselCollectionModel = carouselItem
                    cell.delegate = homeViewController
                    cell.frame = tableView.bounds
                    cell.layoutIfNeeded()
                    cell.productCollectionView.reloadData()
                    cell.productCollectionVwHeight.constant = cell.productCollectionView.collectionViewLayout.collectionViewContentSize.height
                    return cell
                } else if carouselItem.layoutType == 3 {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCellLayout3.identifier) as? ProductTableViewCellLayout3 else { return UITableViewCell() }
                    cell.obj = self
                    cell.selectionStyle = .none
                    cell.titleNameLabel.text = carouselItem.label!.uppercased()
                    cell.carouselCollectionModel = carouselItem
                    cell.delegate = homeViewController
                    cell.productCollectionView.reloadData()
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCellLayout4.identifier) as? ProductTableViewCellLayout4 else { return UITableViewCell() }
                    cell.obj = self
                    cell.selectionStyle = .none
                    cell.titleNameLabel.text = carouselItem.label!.uppercased()
                    cell.carouselCollectionModel = carouselItem
                    cell.delegate = homeViewController
                    cell.productCollectionView.reloadData()
                    return cell
                }
            } else if carouselItem.type == CarouselType.image.rawValue {
                if let cell = tableView.dequeueReusableCell(withIdentifier: ImageCarouselTableViewCell.identifier) as? ImageCarouselTableViewCell {
                    cell.imageCarouselCollectionModel = carouselItem.banners
                    cell.titleTextlabel.text = carouselItem.label!.uppercased()
                    cell.selectionStyle = .none
                    cell.imageCarouselCollectionView.reloadData()
                    self.homeTableviewheight?.constant = tableView.contentSize.height
                    return cell
                }
            }
        }
        return UITableViewCell()
    
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = items[indexPath.section]
        switch item.type {
            
//        case .offerBanner:
//            return 75
            
        case .advertisement:
              return 75
            
            
        case .banner:
            return UITableView.automaticDimension
        case .featureCategory:
            //return 200
//            if let item = item as? HomeViewModelFeatureCategoriesItem, self.themeCode == 1 {
//                if CGFloat(item.featureCategories.count * 90) > 1.5 * AppDimensions.screenWidth {
//                    return 280
//                } else {
//                    return 150
//                }
//            }
            return 400
        case .recentViewData:
            return UITableView.automaticDimension
        case .carousel:
            let carouselItem = ((item as? HomeViewModelCarouselItem)?.carouselCollectionModel)![indexPath.row]
            if carouselItem.type == CarouselType.product.rawValue {
                return UITableView.automaticDimension
            } else if carouselItem.type == CarouselType.image.rawValue {
                //return AppDimensions.screenWidth / 2 + 60
                return 2*AppDimensions.screenWidth/3 + 41
            }
        }
        return 0
    }
}

extension HomeViewModel {
    
    func callingHttppApi(productId: String, apiType: String, completion: @escaping (Bool, JSON) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        requstParams["storeId"] = Defaults.storeId
        requstParams["width"] = UrlParams.width
        requstParams["quoteId"] = Defaults.quoteId
        //        requstParams["productId"] = productId
        requstParams["customerToken"] = Defaults.customerToken
        var apiName: WhichApiCall = .addToWishList
        var verbs: HTTPMethod = .post
        if apiType == "delete" {
            verbs = .delete
            apiName = .removeFromWishList
            requstParams["itemId"] = productId
        } else {
            verbs = .post
            requstParams["productId"] = productId
        }
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: verbs, apiname: apiName, currentView: UIViewController()) { [weak self] success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            if success == 1 {                
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                if jsonResponse["success"].boolValue == true {
                    self?.doFurtherProcessingWithResult(data: jsonResponse) { success in
                        completion(success, jsonResponse)
                    }
                } else {
                    if jsonResponse["message"].stringValue.removeWhiteSpace.count > 0 {
                        ShowNotificationMessages.sharedInstance.warningView(message: jsonResponse["message"].stringValue)
                    } else {
                        ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
                    }
                    completion(false, JSON.null)
                }
            } else if success == 2 {   // Retry in case of error
                NetworkManager.sharedInstance.dismissLoader()
                self?.callingHttppApi(productId: productId, apiType: apiType) {success,jsonResponse  in
                    completion(success, jsonResponse)
                }
            }
        }
    }
    
    func doFurtherProcessingWithResult(data: JSON, completion: (Bool) -> Void) {
        if data["success"].boolValue {
            let message = data["message"].stringValue.count > 0 ?  data["message"].stringValue : "Product added to wishlist".localized
            ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: message )
        } else {
            ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
        }
        completion(true)
    }
}

extension Array{
    mutating func appendAtBeginning(newItem : Element){
        let copy = self
        self = []
        self.append(newItem)
        self.append(contentsOf: copy)
    }
}
