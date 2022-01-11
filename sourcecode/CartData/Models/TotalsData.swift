//
//  TotalsData.swift
//
//  Created by bhavuk.chawla on 24/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct TotalsData {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let unformattedValue = "unformattedValue"
        static let title = "title"
        static let value = "value"
    }
    
    // MARK: Properties
    public var unformattedValue: Int!
    public var title: String?
    public var value: String?
    var formattedValue: String!
    
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
        unformattedValue = json[SerializationKeys.unformattedValue].int
        title = json[SerializationKeys.title].string ?? json["label"].stringValue
        value = json[SerializationKeys.value].string
        formattedValue = json["formattedValue"].stringValue
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = unformattedValue { dictionary[SerializationKeys.unformattedValue] = value }
        if let value = title { dictionary[SerializationKeys.title] = value }
        if let value = value { dictionary[SerializationKeys.value] = value }
        return dictionary
    }
    
}
