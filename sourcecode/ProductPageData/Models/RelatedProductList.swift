//
//  RelatedProductList.swift
//
//  Created by bhavuk.chawla on 27/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct RelatedProductList {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let wishlistItemId = "wishlistItemId"
        static let configurableData = "configurableData"
        static let name = "name"
        static let isInWishlist = "isInWishlist"
        static let entityId = "entityId"
        static let isAvailable = "isAvailable"
        static let typeId = "typeId"
        static let shortDescription = "shortDescription"
        static let rating = "rating"
        static let hasRequiredOptions = "hasRequiredOptions"
        static let price = "price"
        static let thumbNail = "thumbNail"
        static let formattedFinalPrice = "formattedFinalPrice"
        static let minAddToCartQty = "minAddToCartQty"
        static let isNew = "isNew"
        static let dominantColor = "dominantColor"
        static let formattedPrice = "formattedPrice"
        static let finalPrice = "finalPrice"
        static let isInRange = "isInRange"
        static let availability = "availability"
    }
    
    // MARK: Properties
    public var wishlistItemId: String!
    public var configurableData: ConfigurableData?
    public var name: String!
    public var isInWishlist: Bool! = false
    public var entityId: String!
    public var isAvailable: Bool? = false
    public var typeId: String!
    public var shortDescription: String!
    public var rating: String!
    public var hasRequiredOptions: Bool? = false
    public var price: Int!
    public var thumbNail: String!
    public var formattedFinalPrice: String!
    public var minAddToCartQty: Int?
    public var isNew: Bool? = false
    public var dominantColor: String!
    public var formattedPrice: String!
    public var finalPrice: Int!
    public var isInRange: Bool! = false
    var showSpecialPrice: Bool!
    var strikePrice: NSMutableAttributedString!
    var percentage: String!
    var groupedPrice: String!
    var availability: String!
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
        wishlistItemId = json[SerializationKeys.wishlistItemId].stringValue
        configurableData = ConfigurableData(json: json[SerializationKeys.configurableData])
        name = json[SerializationKeys.name].stringValue
        isInWishlist = json[SerializationKeys.isInWishlist].boolValue
        entityId = json[SerializationKeys.entityId].stringValue
        isAvailable = json[SerializationKeys.isAvailable].boolValue
        typeId = json[SerializationKeys.typeId].stringValue
        shortDescription = json[SerializationKeys.shortDescription].stringValue
        rating = json[SerializationKeys.rating].stringValue
        hasRequiredOptions = json[SerializationKeys.hasRequiredOptions].boolValue
        price = json[SerializationKeys.price].intValue
        thumbNail = json[SerializationKeys.thumbNail].stringValue
        formattedFinalPrice = json[SerializationKeys.formattedFinalPrice].stringValue
        minAddToCartQty = json[SerializationKeys.minAddToCartQty].intValue
        isNew = json[SerializationKeys.isNew].boolValue
        dominantColor = json[SerializationKeys.dominantColor].stringValue
        formattedPrice = json[SerializationKeys.formattedPrice].stringValue
        finalPrice = json[SerializationKeys.finalPrice].intValue
        isInRange = json[SerializationKeys.isInRange].boolValue
        groupedPrice = json["groupedPrice"].stringValue
        availability = json[SerializationKeys.availability].stringValue
        
        showSpecialPrice = finalPrice != 0 && finalPrice < price && isInRange
        if showSpecialPrice {
            let val  = ((Float(json["price"].intValue  - json["finalPrice"].intValue) / json["price"].floatValue) * 100)
            percentage = String.init(format: "%.0f", val) + "% " + "OFF".localized
            strikePrice = NSMutableAttributedString(string: formattedPrice)
            strikePrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: strikePrice.length))
        } else {
            percentage = ""
            formattedFinalPrice = formattedPrice
            strikePrice = NSMutableAttributedString(string: "")
        }
        
        if typeId == "grouped" {
            formattedFinalPrice = groupedPrice
        } else if typeId == "bundle" {
            if json["minPrice"].floatValue == json["maxPrice"].floatValue {
                formattedFinalPrice = json["formattedMinPrice"].stringValue
            } else {
                formattedFinalPrice = json["formattedMinPrice"].stringValue + " - " + json["formattedMaxPrice"].stringValue
            }
        } else if typeId == "configurable" {
            if json["price"].floatValue >= json["finalPrice"].floatValue {
                formattedFinalPrice = "\("As low as".localized) \(json["formattedFinalPrice"].stringValue)"
            }
        }
    }
    mutating func addItemId(wishlistItemId: String) {
        self.wishlistItemId = wishlistItemId
    }
    
    mutating func wishlistStatus(isInWishlist: Bool) {
        self.isInWishlist = isInWishlist
    }
    
}
