//
//  Qty.swift
//
//  Created by bhavuk.chawla on 03/02/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct Qty {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let refunded = "Refunded"
        static let ordered = "Ordered"
        static let canceled = "Canceled"
        static let shipped = "Shipped"
    }
    
    // MARK: Properties
    public var refunded: String!
    public var ordered: String!
    public var canceled: String!
    public var shipped: String!
    
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
        refunded = json[SerializationKeys.refunded].stringValue
        ordered = json[SerializationKeys.ordered].stringValue
        canceled = json[SerializationKeys.canceled].stringValue
        shipped = json[SerializationKeys.shipped].stringValue
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = refunded { dictionary[SerializationKeys.refunded] = value }
        if let value = ordered { dictionary[SerializationKeys.ordered] = value }
        if let value = canceled { dictionary[SerializationKeys.canceled] = value }
        if let value = shipped { dictionary[SerializationKeys.shipped] = value }
        return dictionary
    }
    
}
