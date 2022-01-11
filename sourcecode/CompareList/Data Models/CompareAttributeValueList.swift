//
//  AttributeValueList.swift
//
//  Created by Webkul on 19/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation

class CompareAttributeValueList {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let value = "value"
        static let attributeName = "attributeName"
    }
    
    // MARK: Properties
    var value: [String]?
    var attributeName: String?
    
    // MARK: SwiftyJSON Initializers
    /// Initiates the instance based on the object.
    ///
    /// - parameter object: The object of either Dictionary or Array kind that was passed.
    /// - returns: An initialized instance of the class.
    convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    init(json: JSON) {
        if let items = json[SerializationKeys.value].array { value = items.map { $0.stringValue } }
        attributeName = json[SerializationKeys.attributeName].string
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = value { dictionary[SerializationKeys.value] = value }
        if let value = attributeName { dictionary[SerializationKeys.attributeName] = value }
        return dictionary
    }
}
