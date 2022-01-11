import Foundation
import UIKit

enum CarouselType: String {
    case product = "product"
    case image = "image"
}

struct Currency {
    var code: String!
    var label: String!
    
    init(data: JSON) {
        self.code = data["code"].stringValue
        self.label = data["label"].stringValue
    }
}

struct HomeModal {
    var recentViewData = [Productcollection]()
    var storeData = [StoreData]()
    var websiteData = [WebsiteData]()
    var categoryImages: [CategoryImages]!
    var defaultCurrency: String!
    var wishlistEnable: Bool! = false
    var showSwatchOnCollection: Bool! = false
    var carousel: [Carousel]!
    var priceFormat: PriceFormat!
    var eTag: String!
    var success: Bool! = false
    var bannerImages: [BannerImages]!
    var featuredCategories: [FeaturedCategories]!
    var categories: [Categories]!
    var message: String!
    var allowedCurrencies: [Currency]!
    var cmsData: [CMSdata]!
    var themeCode = 0
    
    init?(data: JSON) {
        NetworkManager.AddonsChecks(data: data)
        
        if let storeDataObj = data["storeData"].arrayObject {
            storeData = storeDataObj.map({ (value) -> StoreData in
                return StoreData(json: JSON(value))
            })
        }
        
        if let storeDataObj = data["websiteData"].arrayObject {
            websiteData = storeDataObj.map({ (value) -> WebsiteData in
                return WebsiteData(json: JSON(value))
            })
        }
        
        if let categoryImagesObj = data["categoryImages"].arrayObject {
            categoryImages = categoryImagesObj.map({ (value) -> CategoryImages in
                return CategoryImages(json: JSON(value))
            })
        }
        
        defaultCurrency = data["defaultCurrency"].stringValue
        
        wishlistEnable = data["wishlistEnable"].boolValue
        
        showSwatchOnCollection = data["showSwatchOnCollection"].boolValue
        
        if let carouselObj = data["carousel"].arrayObject {
            carousel = carouselObj.map({ (value) -> Carousel in
                return Carousel(json: JSON(value))
            })
        }
        
        priceFormat = PriceFormat(json: data["priceFormat"])
        
        eTag = data["eTag"].stringValue
        
        success = data["success"].boolValue
        
        if let bannerImagesObj = data["bannerImages"].arrayObject, bannerImagesObj.count > 0 {
            bannerImages = bannerImagesObj.map({ (value) -> BannerImages in
                return BannerImages(json: JSON(value))
            })
        }
        
        if let featuredCategoriesObj = data["featuredCategories"].arrayObject {
            featuredCategories = featuredCategoriesObj.map({ (value) -> FeaturedCategories in
                return FeaturedCategories(json: JSON(value))
            })
        }
        
        if let categoriesObj = data["categories"].array {
            categories = categoriesObj.map({ (value) -> Categories in
                return Categories(json: value)
            })
        }
        
        message = data["message"].stringValue
        
        if let cmsObj = data["cmsData"].arrayObject {
            cmsData = cmsObj.map({ (value) -> CMSdata in
                return CMSdata(data: JSON(value))
            })
        }
        
        if let items = data["allowedCurrencies"].array {
            allowedCurrencies = items.map({ (value) -> Currency in
                return Currency(data: value)
            })
        }
        
    }
}

public class BannerData {
    var bannerType: String!
    var imageUrl: String!
    var bannerId: String!
    var bannerName: String!
    var productId: String!
    var productName: String!
    
    init(data: JSON) {
        bannerType = data["bannerType"].stringValue
        imageUrl  = data["url"].stringValue
        bannerId = data["categoryId"].stringValue
        bannerName = data["categoryName"].stringValue
        productId = data["productId"].stringValue
        productName = data["productName"].stringValue
    }
    
}

class FeatureCategories {
    var categoryID: String = ""
    var categoryName: String = ""
    var imageUrl: String = ""
    
    init(data: JSON) {
        self.categoryID = data["categoryId"].stringValue
        self.categoryName = data["categoryName"].stringValue
        self.imageUrl = data["url"].stringValue
    }
}

struct Products {
    var hasOption: Int!
    var name: String!
    var price: String!
    var productID: String!
    var showSpecialPrice: String!
    var image: String!
    var isInRange: Int!
    var isInWishList: Bool!
    var originalPrice: Double!
    var specialPrice: Double!
    var formatedPrice: String!
    var typeID: String!
    var groupedPrice: String!
    var formatedMinPrice: String!
    var formatedMaxPrice: String!
    var wishlistItemId: String!
    
    init(data: JSON) {
        self.hasOption = data["hasOption"].intValue
        self.name = data["name"].stringValue
        self.price = data["formatedFinalPrice"].stringValue
        self.productID = data["entityId"].stringValue
        self.showSpecialPrice = data["formatedFinalPrice"].stringValue
        self.image = data["thumbNail"].stringValue
        self.originalPrice =  data["price"].doubleValue
        self.specialPrice = data["finalPrice"].doubleValue
        self.isInRange = data["isInRange"].intValue
        self.isInWishList = data["isInWishlist"].boolValue
        self.formatedPrice = data["formatedPrice"].stringValue
        self.typeID = data["typeId"].stringValue
        self.groupedPrice = data["groupedPrice"].stringValue
        self.formatedMaxPrice = data["formatedMaxPrice"].stringValue
        self.formatedMinPrice = data["formatedMinPrice"].stringValue
        self.wishlistItemId = data["wishlistItemId"].stringValue
    }
}

struct Languages {
    var code: String!
    var name: String!
    var id: String!
    
    init(data: JSON) {
        self.code = data["code"].stringValue
        self.name = data["name"].stringValue
        self.id = data["id"].stringValue
    }
}

class CMSdata {
    var id: String!
    var title: String!
    
    init(data: JSON) {
        self.id = data["id"].stringValue
        self.title = data["title"].stringValue
    }
}
