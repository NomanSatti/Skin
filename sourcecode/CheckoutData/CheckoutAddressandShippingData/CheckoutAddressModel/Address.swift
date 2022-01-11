//
//  Address.swift
//
//  Created by bhavuk.chawla on 18/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct Address {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let id = "id"
        static let value = "value"
    }
    
    // MARK: Properties
    public var id: String!
    public var value: String!
    public var newAddress: [String: Any]!
    
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
        id = json[SerializationKeys.id].stringValue
        value = json[SerializationKeys.value].stringValue.html2String
        newAddress = json["newAddress"].dictionaryObject ?? [:]
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = value { dictionary[SerializationKeys.value] = value }
        return dictionary
    }
    
}
