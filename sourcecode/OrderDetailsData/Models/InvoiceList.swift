//
//  InvoiceList.swift
//
//  Created by bhavuk.chawla on 03/02/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct InvoiceList {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let sku = "sku"
        static let qty = "qty"
        static let totals = "totals"
        static let incrementId = "incrementId"
        static let items = "items"
        static let subTotal = "subTotal"
        static let price = "price"
    }
    
    // MARK: Properties
    public var sku: String!
    public var qty: Int?
    public var totals = [TotalsData]()
    public var incrementId: String!
    public var items: Items?
    public var subTotal: String!
    public var price: String!
    
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
        sku = json[SerializationKeys.sku].stringValue
        qty = json[SerializationKeys.qty].int
        if let items = json[SerializationKeys.totals].array {
            let array = items.map { TotalsData(json: $0) }
            totals = array.filter{ $0.unformattedValue != 0 }
        }
        incrementId = json[SerializationKeys.incrementId].stringValue
        items = Items(json: json[SerializationKeys.items])
        subTotal = json[SerializationKeys.subTotal].stringValue
        price = json[SerializationKeys.price].stringValue
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = sku { dictionary[SerializationKeys.sku] = value }
        if let value = qty { dictionary[SerializationKeys.qty] = value }
        //    if let value = totals { dictionary[SerializationKeys.totals] = value.map { $0.dictionaryRepresentation() } }
        if let value = incrementId { dictionary[SerializationKeys.incrementId] = value }
        if let value = items { dictionary[SerializationKeys.items] = value.dictionaryRepresentation() }
        if let value = subTotal { dictionary[SerializationKeys.subTotal] = value }
        if let value = price { dictionary[SerializationKeys.price] = value }
        return dictionary
    }
    
}
