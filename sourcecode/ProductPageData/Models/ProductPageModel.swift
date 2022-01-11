//
//  BaseClass.swift
//
//  Created by bhavuk.chawla on 26/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import RealmSwift

public struct ProductPageModel {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let productUrl = "productUrl"
        static let isAvailable = "isAvailable"
        static let configurableData = "configurableData"
        static let showBackInStockAlert = "showBackInStockAlert"
        static let shortDescription = "shortDescription"
        static let relatedProductList = "relatedProductList"
        static let formattedMsrp = "formattedMsrp"
        static let priceFormat = "priceFormat"
        static let minAddToCartQty = "minAddToCartQty"
        static let id = "id"
        static let dominantColor = "dominantColor"
        static let formattedMinPrice = "formattedMinPrice"
        static let specialPrice = "specialPrice"
        static let message = "message"
        static let finalPrice = "finalPrice"
        static let isAllowedGuestCheckout = "isAllowedGuestCheckout"
        static let reviewList = "reviewList"
        static let showPriceDropAlert = "showPriceDropAlert"
        static let guestCanReview = "guestCanReview"
        static let name = "name"
        static let isInRange = "isInRange"
        static let isNew = "is_new"
        static let arType = "arType"
        static let typeId = "typeId"
        static let descriptionValue = "description"
        static let thumbNail = "thumbNail"
        static let rating = "rating"
        static let price = "price"
        static let formattedFinalPrice = "formattedFinalPrice"
        static let success = "success"
        static let additionalInformation = "additionalInformation"
        static let ratingData = "ratingData"
        static let formattedMaxPrice = "formattedMaxPrice"
        static let arUrl = "arUrl"
        static let formattedPrice = "formattedPrice"
        static let arTextureImages = "arTextureImages"
        static let availability = "availability"
        static let upsellProductList = "upsellProductList"
        static let imageGallery = "imageGallery"
        static let ratingFormData = "ratingFormData"
        static let groupedData = "groupedData"
        static let bundleOptions = "bundleOptions"
        static let samples = "samples"
        static let links = "links"
        static let customOptions = "customOptions"
        static let ratingArray = "ratingArray"
        static let wishlistItemId = "wishlistItemId"
       
    }
    
    // MARK: Properties
    var groupedPrice: String!
    public var productUrl: String!
    public var isAvailable: Bool? = false
    public var showBackInStockAlert: Bool? = false
    public var customOptions: [CustomOptions]?
    public var shortDescription: String!
    public var configurableData: ConfigurableData?
    public var relatedProductList: [RelatedProductList]?
    public var formattedMsrp: String!
    public var priceFormat: PriceFormat?
    public var minAddToCartQty: Int?
    public var id: String!
    public var dominantColor: String!
    public var formattedMinPrice: String!
    public var specialPrice: String!
    public var message: String!
    public var finalPrice: Int!
    public var isAllowedGuestCheckout: Bool? = false
    public var reviewList: [ReviewList]?
    public var showPriceDropAlert: Bool? = false
    public var ratingArray: RatingArray?
    public var guestCanReview: Bool! = false
    public var name: String!
    public var isInRange: Bool! = false
    public var isNew: Bool? = false
    public var arType: String!
    public var typeId: String!
    public var descriptionValue: String!
    public var thumbNail: String!
    public var rating: String!
    public var price: Int!
    public var formattedFinalPrice: String!
    public var success: Bool? = false
    public var additionalInformation: [AdditionalInformation]?
    public var ratingData: [CustomerRatingData]?
    public var formattedMaxPrice: String!
    public var arUrl: String!
    public var formattedPrice: String!
    public var arTextureImages: [Any]?
    public var availability: String!
    public var upsellProductList: [RelatedProductList]?
    public var imageGallery: [ImageGallery]?
    public var ratingFormData: [RatingFormData]?
    public var wishlistItemId: String!
   
    
    var tierPrice: String!
    var reviewCount: String!
    var groupedData = [CartProducts]()
    public var bundleOptions = [BundleOptions]()
    public var links: Links?
    public var samples: Samples?
    var showSpecialPrice: Bool!
    var strikePrice: NSMutableAttributedString!
    var percentage: String!
    var isInWishlist: Bool!
    // MARK: SwiftyJSON Initializers
    /// Initiates the instance based on the object.
    ///
    /// - parameter object: The object of either Dictionary or Array kind that was passed.
    /// - returns: An initialized instance of the class.
    public init(object: Any) {
        self.init(json: JSON(object))
    }
    
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    public init(json: JSON) {
        groupedPrice = json["groupedPrice"].stringValue
        productUrl = json[SerializationKeys.productUrl].stringValue
        isAvailable = json[SerializationKeys.isAvailable].boolValue
        configurableData = ConfigurableData(json: json[SerializationKeys.configurableData])
        showBackInStockAlert = json[SerializationKeys.showBackInStockAlert].boolValue
        if let items = json[SerializationKeys.customOptions].array { customOptions = items.map { CustomOptions(json: $0) } }
        shortDescription = json[SerializationKeys.shortDescription].stringValue
        if let items = json[SerializationKeys.relatedProductList].array { relatedProductList = items.map { RelatedProductList(json: $0) }  }
        if let items = json[SerializationKeys.groupedData].array { groupedData = items.map { CartProducts(json: $0) }  }
        formattedMsrp = json[SerializationKeys.formattedMsrp].stringValue
        priceFormat = PriceFormat(json: json[SerializationKeys.priceFormat])
        minAddToCartQty = json[SerializationKeys.minAddToCartQty].int
        id = json[SerializationKeys.id].stringValue
        dominantColor = json[SerializationKeys.dominantColor].stringValue
        formattedMinPrice = json[SerializationKeys.formattedMinPrice].stringValue
        specialPrice = json[SerializationKeys.specialPrice].stringValue
        message = json[SerializationKeys.message].stringValue
        finalPrice = json[SerializationKeys.finalPrice].intValue
        isAllowedGuestCheckout = json[SerializationKeys.isAllowedGuestCheckout].boolValue
        if let items = json[SerializationKeys.reviewList].array { reviewList = items.map { ReviewList(json: $0) } }
        showPriceDropAlert = json[SerializationKeys.showPriceDropAlert].boolValue
        guestCanReview = json[SerializationKeys.guestCanReview].boolValue
        name = json[SerializationKeys.name].stringValue
        isInRange = json[SerializationKeys.isInRange].boolValue
        isNew = json[SerializationKeys.isNew].boolValue
        arType = json[SerializationKeys.arType].stringValue
        typeId = json[SerializationKeys.typeId].stringValue
        descriptionValue = json[SerializationKeys.descriptionValue].stringValue
        thumbNail = json[SerializationKeys.thumbNail].stringValue
        rating = json[SerializationKeys.rating].stringValue
        price = json[SerializationKeys.price].intValue
        formattedFinalPrice = json[SerializationKeys.formattedFinalPrice].stringValue
        success = json[SerializationKeys.success].boolValue
        if let items = json[SerializationKeys.additionalInformation].array { additionalInformation = items.map { AdditionalInformation(json: $0) } }
        if let items = json[SerializationKeys.ratingData].array { ratingData = items.map { CustomerRatingData(json: $0) } }
        formattedMaxPrice = json[SerializationKeys.formattedMaxPrice].stringValue
        arUrl = json[SerializationKeys.arUrl].stringValue
        formattedPrice = json[SerializationKeys.formattedPrice].stringValue
        if let items = json[SerializationKeys.arTextureImages].array { arTextureImages = items.map { $0.object} }
        availability = json[SerializationKeys.availability].stringValue
        if let items = json[SerializationKeys.upsellProductList].array { upsellProductList = items.map { RelatedProductList(json: $0) } }
        if let items = json[SerializationKeys.imageGallery].array { imageGallery = items.map { ImageGallery(json: $0) } }
        if let items = json[SerializationKeys.ratingFormData].array { ratingFormData = items.map { RatingFormData(json: $0) } }
        if let items = json[SerializationKeys.bundleOptions].array { bundleOptions = items.map { BundleOptions(json: $0) } }
        
        samples = Samples(json: json[SerializationKeys.samples])
        links = Links(json: json[SerializationKeys.links])
        wishlistItemId = json[SerializationKeys.wishlistItemId].stringValue
        
        showSpecialPrice = finalPrice != 0 && finalPrice < price && isInRange
        if json[SerializationKeys.ratingArray] != JSON.null {
            ratingArray = RatingArray(json: json[SerializationKeys.ratingArray])
        }
        
        if let tierPrices = json["tierPrices"].array, tierPrices.count > 0 {
            let arr = tierPrices.map{ $0.stringValue.html2String }
            tierPrice = arr.joined(separator: ", ")
        }
        //    tierPriceArray
        
        reviewCount = json["reviewCount"].stringValue
        if showSpecialPrice {
            let val  = ((Float(json["price"].intValue  - json["finalPrice"].intValue) / json["price"].floatValue) * 100)
            percentage = String.init(format: "%.0f", val) + "%" + " " + "OFF".localized
            strikePrice = NSMutableAttributedString(string: formattedPrice)
            strikePrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: strikePrice.length))
        } else {
            percentage = ""
            formattedFinalPrice = formattedPrice
            strikePrice = NSMutableAttributedString(string: "")
        }
        isInWishlist = json["isInWishlist"].boolValue
    }
    
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    
}


class ProductDataModel: Object {
    @objc dynamic var data: String?
    @objc dynamic var productId: String?
    convenience init(data: String, productId:String ) {
        self.init()
        self.data = data
        self.productId = productId
    }
    
    override class func primaryKey() -> String? {
        return "productId"
    }
}
