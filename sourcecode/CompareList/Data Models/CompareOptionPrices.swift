//
//  OptionPrices.swift
//
//  Created by Webkul on 19/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct CompareOptionPrices {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let tierPrices = "tierPrices"
        static let oldPrice = "oldPrice"
        static let finalPrice = "finalPrice"
        static let basePrice = "basePrice"
        static let product = "product"
    }
    
    // MARK: Properties
    public var tierPrices: [Any]?
    public var oldPrice: CompareOldPrice?
    public var finalPrice: CompareFinalPrice?
    public var basePrice: CompareBasePrice?
    public var product: Int?
    
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
        if let items = json[SerializationKeys.tierPrices].array { tierPrices = items.map { $0.object} }
        oldPrice = CompareOldPrice(json: json[SerializationKeys.oldPrice])
        finalPrice = CompareFinalPrice(json: json[SerializationKeys.finalPrice])
        basePrice = CompareBasePrice(json: json[SerializationKeys.basePrice])
        product = json[SerializationKeys.product].int
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = tierPrices { dictionary[SerializationKeys.tierPrices] = value }
        if let value = oldPrice { dictionary[SerializationKeys.oldPrice] = value.dictionaryRepresentation() }
        if let value = finalPrice { dictionary[SerializationKeys.finalPrice] = value.dictionaryRepresentation() }
        if let value = basePrice { dictionary[SerializationKeys.basePrice] = value.dictionaryRepresentation() }
        if let value = product { dictionary[SerializationKeys.product] = value }
        return dictionary
    }
    
}
