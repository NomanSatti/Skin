//
//  Prices.swift
//
//  Created by Webkul on 19/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct ComparePrices {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let finalPrice = "finalPrice"
        static let oldPrice = "oldPrice"
        static let basePrice = "basePrice"
    }
    
    // MARK: Properties
    public var finalPrice: CompareFinalPrice?
    public var oldPrice: CompareOldPrice?
    public var basePrice: CompareBasePrice?
    
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
        finalPrice = CompareFinalPrice(json: json[SerializationKeys.finalPrice])
        oldPrice = CompareOldPrice(json: json[SerializationKeys.oldPrice])
        basePrice = CompareBasePrice(json: json[SerializationKeys.basePrice])
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = finalPrice { dictionary[SerializationKeys.finalPrice] = value.dictionaryRepresentation() }
        if let value = oldPrice { dictionary[SerializationKeys.oldPrice] = value.dictionaryRepresentation() }
        if let value = basePrice { dictionary[SerializationKeys.basePrice] = value.dictionaryRepresentation() }
        return dictionary
    }
    
}
