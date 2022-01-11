//
//  CrossSellList.swift
//
//  Created by bhavuk.chawla on 07/02/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct CrossSellList {
    
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
    public var wishlistItemId: Int?
    public var configurableData: ConfigurableData?
    public var name: String?
    public var isInWishlist: Bool! = false
    public var entityId: String?
    public var isAvailable: Bool? = false
    public var typeId: String?
    public var shortDescription: String?
    public var rating: String?
    public var hasRequiredOptions: Bool? = false
    public var price: String?
    public var thumbNail: String?
    public var formattedFinalPrice: String?
    public var minAddToCartQty: Int?
    public var isNew: Bool? = false
    public var dominantColor: String?
    public var formattedPrice: String?
    public var finalPrice: Int?
    public var isInRange: Bool! = false
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
        wishlistItemId = json[SerializationKeys.wishlistItemId].int
        configurableData = ConfigurableData(json: json[SerializationKeys.configurableData])
        name = json[SerializationKeys.name].string
        isInWishlist = json[SerializationKeys.isInWishlist].boolValue
        entityId = json[SerializationKeys.entityId].string
        isAvailable = json[SerializationKeys.isAvailable].boolValue
        typeId = json[SerializationKeys.typeId].string
        shortDescription = json[SerializationKeys.shortDescription].string
        rating = json[SerializationKeys.rating].string
        hasRequiredOptions = json[SerializationKeys.hasRequiredOptions].boolValue
        price = json[SerializationKeys.price].string
        thumbNail = json[SerializationKeys.thumbNail].string
        formattedFinalPrice = json[SerializationKeys.formattedFinalPrice].string
        minAddToCartQty = json[SerializationKeys.minAddToCartQty].int
        isNew = json[SerializationKeys.isNew].boolValue
        dominantColor = json[SerializationKeys.dominantColor].string
        formattedPrice = json[SerializationKeys.formattedPrice].string
        finalPrice = json[SerializationKeys.finalPrice].int
        isInRange = json[SerializationKeys.isInRange].boolValue
        availability = json[SerializationKeys.availability].stringValue
    }
    
}
