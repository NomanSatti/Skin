//
//  OrderReviewData.swift
//
//  Created by bhavuk.chawla on 25/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct OrderReviewData {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let items = "items"
        static let cartTotal = "cartTotal"
        static let totals = "totals"
    }
    
    // MARK: Properties
    public var orderReviewProducts =  [OrderReviewProducts]()
    public var cartTotal: String?
    public var totals =  [TotalsData]()
    
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
        if let items = json[SerializationKeys.items].array { orderReviewProducts = items.map { OrderReviewProducts(json: $0) } }
        cartTotal = json[SerializationKeys.cartTotal].string
        if let items = json[SerializationKeys.totals].array { totals = items.map { TotalsData(json: $0) } }
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        //    if let value = items { dictionary[SerializationKeys.items] = value.map { $0.dictionaryRepresentation() } }
        if let value = cartTotal { dictionary[SerializationKeys.cartTotal] = value }
        //    if let value = totals { dictionary[SerializationKeys.totals] = value.map { $0.dictionaryRepresentation() } }
        return dictionary
    }
    
}
