//
//  FieldList.swift
//
//  Created by bhavuk.chawla on 04/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class FieldList: NSCoding {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let label = "label"
        static let options = "options"
        static let title = "title"
        static let maxQueryLength = "maxQueryLength"
        static let inputType = "inputType"
        static let attributeCode = "attributeCode"
    }
    
    // MARK: Properties
    public var label: String!
    public var options = [SearchOptions]()
    public var title: String!
    public var maxQueryLength: String!
    public var inputType: String!
    public var attributeCode: String!
    
    // MARK: SwiftyJSON Initializers
    /// Initiates the instance based on the object.
    ///
    /// - parameter object: The object of either Dictionary or Array kind that was passed.
    /// - returns: An initialized instance of the class.
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    public required init(json: JSON) {
        label = json[SerializationKeys.label].stringValue
        if let items = json[SerializationKeys.options].array { options = items.map { SearchOptions(json: $0) } }
        title = json[SerializationKeys.title].stringValue
        maxQueryLength = json[SerializationKeys.maxQueryLength].stringValue
        inputType = json[SerializationKeys.inputType].stringValue
        attributeCode = json[SerializationKeys.attributeCode].stringValue
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = label { dictionary[SerializationKeys.label] = value }
        //    if let value = options { dictionary[SerializationKeys.options] = value }
        if let value = title { dictionary[SerializationKeys.title] = value }
        if let value = maxQueryLength { dictionary[SerializationKeys.maxQueryLength] = value }
        if let value = inputType { dictionary[SerializationKeys.inputType] = value }
        if let value = attributeCode { dictionary[SerializationKeys.attributeCode] = value }
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.label = aDecoder.decodeObject(forKey: SerializationKeys.label) as? String
        self.options = (aDecoder.decodeObject(forKey: SerializationKeys.options) as? [SearchOptions])!
        self.title = aDecoder.decodeObject(forKey: SerializationKeys.title) as? String
        self.maxQueryLength = aDecoder.decodeObject(forKey: SerializationKeys.maxQueryLength) as? String
        self.inputType = aDecoder.decodeObject(forKey: SerializationKeys.inputType) as? String
        self.attributeCode = aDecoder.decodeObject(forKey: SerializationKeys.attributeCode) as? String
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(label, forKey: SerializationKeys.label)
        aCoder.encode(options, forKey: SerializationKeys.options)
        aCoder.encode(title, forKey: SerializationKeys.title)
        aCoder.encode(maxQueryLength, forKey: SerializationKeys.maxQueryLength)
        aCoder.encode(inputType, forKey: SerializationKeys.inputType)
        aCoder.encode(attributeCode, forKey: SerializationKeys.attributeCode)
    }
    
}
