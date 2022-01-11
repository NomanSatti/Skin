//
//  States.swift
//
//  Created by Webkul <support@webkul.com> on 23/01/19
//  Copyright (c) Webkul. All rights reserved.
//

import Foundation

public struct States {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let name = "name"
        static let code = "code"
        static let regionId = "region_id"
    }
    
    // MARK: Properties
    public var name: String!
    public var code: String!
    public var regionId: String!
    
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
        name = json[SerializationKeys.name].stringValue
        code = json[SerializationKeys.code].stringValue
        regionId = json[SerializationKeys.regionId].stringValue
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = name { dictionary[SerializationKeys.name] = value }
        if let value = code { dictionary[SerializationKeys.code] = value }
        if let value = regionId { dictionary[SerializationKeys.regionId] = value }
        return dictionary
    }
    
}
