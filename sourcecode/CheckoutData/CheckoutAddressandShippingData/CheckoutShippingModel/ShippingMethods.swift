//
//  ShippingMethods.swift
//
//  Created by bhavuk.chawla on 18/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct ShippingMethods {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let title = "title"
        static let method = "method"
    }
    
    // MARK: Properties
    public var title: String?
    public var method = [Method]()
    
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
        title = json[SerializationKeys.title].string
        if let items = json[SerializationKeys.method].array { method = items.map { Method(json: $0) } }
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = title { dictionary[SerializationKeys.title] = value }
        //    if let value = method { dictionary[SerializationKeys.method] = value.map { $0.dictionaryRepresentation() } }
        return dictionary
    }
    
}

public struct Method {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let label = "label"
        static let price = "price"
        static let code = "code"
    }
    
    // MARK: Properties
    public var label: String!
    public var price: String!
    public var code: String!
    
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
        label = json[SerializationKeys.label].stringValue
        price = json[SerializationKeys.price].stringValue
        code = json[SerializationKeys.code].stringValue
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = label { dictionary[SerializationKeys.label] = value }
        if let value = price { dictionary[SerializationKeys.price] = value }
        if let value = code { dictionary[SerializationKeys.code] = value }
        return dictionary
    }
    
}
