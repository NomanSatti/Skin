//
//  OptionValues.swift
//
//  Created by bhavuk.chawla on 06/02/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct OptionValues {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let defaultQty = "defaultQty"
        static let isSingle = "isSingle"
        static let isDefault = "isDefault"
        static let optionValueId = "optionValueId"
        static let foramtedPrice = "foramtedPrice"
        static let isQtyUserDefined = "isQtyUserDefined"
        static let title = "title"
        static let price = "price"
    }
    
    // MARK: Properties
    public var defaultQty: String!
    public var isSingle: Bool? = false
    public var isDefault: String!
    public var optionValueId: String!
    public var foramtedPrice: String!
    public var isQtyUserDefined: String!
    public var title: String!
    public var price: Int?
    var formattedPrice: String!
    var defaultPriceType: String!
    
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
        defaultQty = String (json[SerializationKeys.defaultQty].intValue)
        isSingle = json[SerializationKeys.isSingle].boolValue
        isDefault = json[SerializationKeys.isDefault].stringValue
        optionValueId = json[SerializationKeys.optionValueId].string ?? json["option_type_id"].stringValue
        foramtedPrice = json[SerializationKeys.foramtedPrice].stringValue
        isQtyUserDefined = json[SerializationKeys.isQtyUserDefined].stringValue
        title = json[SerializationKeys.title].stringValue
        price = json[SerializationKeys.price].int
        defaultPriceType = json["default_price_type"].stringValue
        formattedPrice = json["formatted_price"].stringValue
        
        if defaultPriceType == "fixed" {
            title = json[SerializationKeys.title].stringValue + " + " + formattedPrice
        }
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    
    
}
