//
//  ProductList.swift
//
//  Created by Webkul on 19/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation

struct CompareProductList {
    
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
    var wishlistItemId: String!
    var configurableData: CompareConfigurableData?
    var name: String!
    var isInWishlist: Bool! = false
    var entityId: String!
    var isAvailable: Bool! = false
    var typeId: String!
    var shortDescription: String!
    var rating: String!
    var hasRequiredOptions: Bool! = false
    var price: Int!
    var thumbNail: String!
    var formattedFinalPrice: String!
    var minAddToCartQty: Int?
    var isNew: Bool! = false
    var dominantColor: String!
    var formattedPrice: String!
    var finalPrice: Int!
    var isInRange: Bool! = false
    var reviewCount: String!
    
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
    
    
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    init(json: JSON) {
        reviewCount = json["reviewCount"].stringValue
        wishlistItemId = json[SerializationKeys.wishlistItemId].stringValue
        configurableData = CompareConfigurableData(json: json[SerializationKeys.configurableData])
        name = json[SerializationKeys.name].string
        isInWishlist = json[SerializationKeys.isInWishlist].boolValue
        entityId = json[SerializationKeys.entityId].string
        isAvailable = json[SerializationKeys.isAvailable].boolValue
        typeId = json[SerializationKeys.typeId].stringValue
        shortDescription = json[SerializationKeys.shortDescription].stringValue
        rating =  String(format: "%.1f", json[SerializationKeys.rating].floatValue)
        hasRequiredOptions = json[SerializationKeys.hasRequiredOptions].boolValue
        price = json[SerializationKeys.price].int
        thumbNail = json[SerializationKeys.thumbNail].stringValue
        formattedFinalPrice = json[SerializationKeys.formattedFinalPrice].string
        minAddToCartQty = json[SerializationKeys.minAddToCartQty].int
        isNew = json[SerializationKeys.isNew].boolValue
        dominantColor = json[SerializationKeys.dominantColor].stringValue
        formattedPrice = json[SerializationKeys.formattedPrice].stringValue
        availability = json[SerializationKeys.availability].stringValue
        finalPrice = json[SerializationKeys.finalPrice].int
        isInRange = json[SerializationKeys.isInRange].boolValue
        
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
