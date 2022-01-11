//
//  TrackingData.swift
//
//  Created by bhavuk.chawla on 14/02/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct TrackingData {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let number = "number"
        static let title = "title"
        static let id = "id"
        static let carrier = "carrier"
    }
    
    // MARK: Properties
    public var number: String!
    public var title: String!
    public var id: String!
    public var carrier: String!
    
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
        number = json[SerializationKeys.number].stringValue
        title = json[SerializationKeys.title].stringValue
        id = json[SerializationKeys.id].stringValue
        carrier = json[SerializationKeys.carrier].stringValue
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = number { dictionary[SerializationKeys.number] = value }
        if let value = title { dictionary[SerializationKeys.title] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = carrier { dictionary[SerializationKeys.carrier] = value }
        return dictionary
    }
    
}
