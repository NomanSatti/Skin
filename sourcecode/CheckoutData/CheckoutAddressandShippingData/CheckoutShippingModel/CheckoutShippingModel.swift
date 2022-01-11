//
//  BaseClass.swift
//
//  Created by bhavuk.chawla on 18/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct CheckoutShippingModel {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let shippingMethods = "shippingMethods"
        static let message = "message"
        static let cartCount = "cartCount"
        static let success = "success"
    }
    
    // MARK: Properties
    public var shippingMethods = [ShippingMethods]()
    public var message: String?
    public var cartCount: Int?
    public var success: Bool? = false
    var cartTotal: String!
    
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
        if let items = json[SerializationKeys.shippingMethods].array { shippingMethods = items.map { ShippingMethods(json: $0) } }
        message = json[SerializationKeys.message].string
        cartCount = json[SerializationKeys.cartCount].int
        success = json[SerializationKeys.success].boolValue
        cartTotal = json["cartTotal"].stringValue
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        //    if let value = shippingMethods { dictionary[SerializationKeys.shippingMethods] = value.map { $0.dictionaryRepresentation() } }
        if let value = message { dictionary[SerializationKeys.message] = value }
        if let value = cartCount { dictionary[SerializationKeys.cartCount] = value }
        dictionary[SerializationKeys.success] = success
        return dictionary
    }
    
}
