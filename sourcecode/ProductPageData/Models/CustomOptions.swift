//
//  CustomOptions.swift
//
//  Created by bhavuk.chawla on 12/02/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct CustomOptions {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let decoratedIsOdd = "decorated_is_odd"
        static let defaultTitle = "default_title"
        static let decoratedIsFirst = "decorated_is_first"
        static let imageSizeY = "image_size_y"
        static let optionValues = "optionValues"
        static let sortOrder = "sort_order"
        static let type = "type"
        static let isRequire = "is_require"
        static let sku = "sku"
        static let unformattedPrice = "unformatted_price"
        static let decoratedIsEven = "decorated_is_even"
        static let fileExtension = "file_extension"
        static let formattedDefaultPrice = "formatted_default_price"
        static let title = "title"
        static let optionId = "option_id"
        static let decoratedIsLast = "decorated_is_last"
        static let defaultPriceType = "default_price_type"
        static let price = "price"
        static let formattedPrice = "formatted_price"
        static let productId = "product_id"
        static let priceType = "price_type"
        static let unformattedDefaultPrice = "unformatted_default_price"
        static let defaultPrice = "default_price"
        static let imageSizeX = "image_size_x"
        static let maxCharacters = "max_characters"
    }
    
    // MARK: Properties
    public var decoratedIsOdd: Bool? = false
    public var defaultTitle: String!
    public var decoratedIsFirst: Bool? = false
    public var imageSizeY: String!
    public var optionValues = [OptionValues]()
    public var sortOrder: String!
    public var type: String!
    public var isRequire: String!
    public var sku: String!
    public var unformattedPrice: String!
    public var decoratedIsEven: Bool? = false
    public var fileExtension: String!
    public var formattedDefaultPrice: String!
    public var title: String!
    public var optionId: String!
    public var decoratedIsLast: Bool? = false
    public var defaultPriceType: String!
    public var price: String!
    public var formattedPrice: String!
    public var productId: String!
    public var priceType: String!
    public var unformattedDefaultPrice: String!
    public var defaultPrice: String!
    public var imageSizeX: String!
    public var maxCharacters: String!
    
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
        decoratedIsOdd = json[SerializationKeys.decoratedIsOdd].boolValue
        
        defaultTitle = json[SerializationKeys.defaultTitle].stringValue
        decoratedIsFirst = json[SerializationKeys.decoratedIsFirst].boolValue
        imageSizeY = json[SerializationKeys.imageSizeY].stringValue
        if let items = json[SerializationKeys.optionValues].array { optionValues = items.map { OptionValues(json: $0) } }
        sortOrder = json[SerializationKeys.sortOrder].stringValue
        type = json[SerializationKeys.type].stringValue
        isRequire = json[SerializationKeys.isRequire].stringValue
        sku = json[SerializationKeys.sku].stringValue
        unformattedPrice = json[SerializationKeys.unformattedPrice].stringValue
        decoratedIsEven = json[SerializationKeys.decoratedIsEven].boolValue
        fileExtension = json[SerializationKeys.fileExtension].stringValue
        formattedDefaultPrice = json[SerializationKeys.formattedDefaultPrice].stringValue
        title = json[SerializationKeys.title].stringValue
        optionId = json[SerializationKeys.optionId].stringValue
        decoratedIsLast = json[SerializationKeys.decoratedIsLast].boolValue
        defaultPriceType = json[SerializationKeys.defaultPriceType].stringValue
        price = json[SerializationKeys.price].stringValue
        formattedPrice = json[SerializationKeys.formattedPrice].stringValue
        productId = json[SerializationKeys.productId].stringValue
        priceType = json[SerializationKeys.priceType].stringValue
        unformattedDefaultPrice = json[SerializationKeys.unformattedDefaultPrice].stringValue
        defaultPrice = json[SerializationKeys.defaultPrice].stringValue
        imageSizeX = json[SerializationKeys.imageSizeX].stringValue
        maxCharacters = json[SerializationKeys.maxCharacters].stringValue
        
        if defaultPriceType == "fixed" {
            if isRequire == "1" {
                defaultTitle = json[SerializationKeys.defaultTitle].stringValue + " + " + formattedPrice + " *"
            } else {
                defaultTitle = json[SerializationKeys.defaultTitle].stringValue  + " + " + formattedPrice
            }
        } else {
            if isRequire == "1" {
                defaultTitle = json[SerializationKeys.defaultTitle].stringValue + " *"
            } else {
                defaultTitle = json[SerializationKeys.defaultTitle].stringValue
            }
        }
    }
}
