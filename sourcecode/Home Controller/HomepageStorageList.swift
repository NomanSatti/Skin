//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: HomepageStorageList.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit

enum HomeViewModelItemType {
    
//    case offerBanner
    case banner
    case featureCategory
    case recentViewData
    case carousel
    case advertisement
}

protocol HomeViewModelItem {
    var type: HomeViewModelItemType { get }
    var sectionTitle: String { get }
    var rowCount: Int { get }
}


class HomeViewModelAdvertisementItem: HomeViewModelItem {
    var type: HomeViewModelItemType {
        return .advertisement
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return adsCollectionModel.count
    }
    
    var adsCollectionModel = [AdsImage]()
    
    init(image: [AdsImage]) {
        self.adsCollectionModel = image
    }
}

//class HomeViewModelOfferBanner: HomeViewModelItem {
//    
//    var type: HomeViewModelItemType {
//        
//        return .offerBanner
//    }
//    
//    var sectionTitle: String {
//        return ""
//    }
//    
//    var rowCount: Int {
//        return 1
//    }
//    
//    var bannerModel = [OfferBanner]()
//    
//    init(banner: [OfferBanner]) {
//        self.bannerModel = banner
//    }
//}

class HomeViewModelBannerItem: HomeViewModelItem {
    var type: HomeViewModelItemType {
        return .banner
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return bannerCollectionModel.count
    }
    
    var bannerCollectionModel = [BannerImages]()
    
    init(categories: [BannerImages]) {
        self.bannerCollectionModel = categories
    }
}

class HomeViewModelCarouselItem: HomeViewModelItem {
    var type: HomeViewModelItemType {
        return .carousel
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return carouselCollectionModel.count
    }
    
    var carouselCollectionModel = [Carousel]()
    
    init(categories: [Carousel]) {
        self.carouselCollectionModel = categories
    }
}

class HomeViewModelFeatureCategoriesItem: HomeViewModelItem {
    var type: HomeViewModelItemType {
        return .featureCategory
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return featureCategories.count
    }
    
    var featureCategories = [FeaturedCategories]()
    
    init(categories: [FeaturedCategories]) {
        self.featureCategories = categories
    }
}

class HomeViewModelRecentViewItem: HomeViewModelItem {
    var type: HomeViewModelItemType {
        return .recentViewData
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return recentViewProductData.count
    }
    
    var recentViewProductData = [Productcollection]()
    
    init(categories: [Productcollection]) {
        self.recentViewProductData = categories
    }
    
}
