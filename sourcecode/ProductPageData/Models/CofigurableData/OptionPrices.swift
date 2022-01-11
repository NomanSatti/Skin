//
//  OptionPrices.swift
//
//  Created by bhavuk.chawla on 27/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct OptionPrices {
    
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
    public var oldPrice: OldPrice?
    public var finalPrice: FinalPrice?
    public var basePrice: BasePrice?
    public var product: String?
    
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
        oldPrice = OldPrice(json: json[SerializationKeys.oldPrice])
        finalPrice = FinalPrice(json: json[SerializationKeys.finalPrice])
        basePrice = BasePrice(json: json[SerializationKeys.basePrice])
        product = json[SerializationKeys.product].stringValue
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    
}
