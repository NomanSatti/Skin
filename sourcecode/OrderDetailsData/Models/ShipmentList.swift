//
//  ShipmentList.swift
//
//  Created by bhavuk.chawla on 03/02/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct ShipmentList {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let items = "items"
        static let incrementId = "incrementId"
    }
    
    // MARK: Properties
    public var items: Items?
    public var incrementId: String!
    
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
        items = Items(json: json[SerializationKeys.items])
        incrementId = json[SerializationKeys.incrementId].stringValue
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = items { dictionary[SerializationKeys.items] = value.dictionaryRepresentation() }
        if let value = incrementId { dictionary[SerializationKeys.incrementId] = value }
        return dictionary
    }
    
}
