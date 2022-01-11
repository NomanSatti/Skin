//
//  RatingData.swift
//
//  Created by bhavuk.chawla on 26/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct RatingData {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let ratingValue = "ratingValue"
        static let ratingCode = "ratingCode"
    }
    
    // MARK: Properties
    public var ratingValue: String?
    public var ratingCode: String?
    
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
        ratingValue = json[SerializationKeys.ratingValue].string
        ratingCode = json[SerializationKeys.ratingCode].string
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = ratingValue { dictionary[SerializationKeys.ratingValue] = value }
        if let value = ratingCode { dictionary[SerializationKeys.ratingCode] = value }
        return dictionary
    }
    
}
