//
//  BaseClass.swift
//
//  Created by bhavuk.chawla on 04/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class AdvanceSearchModel: NSCoding {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let fieldList = "fieldList"
        static let message = "message"
        static let eTag = "eTag"
        static let success = "success"
    }
    
    // MARK: Properties
    public var fieldList: [FieldList]?
    public var message: String?
    public var eTag: String?
    public var success: Bool? = false
    
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
        if let items = json[SerializationKeys.fieldList].array { fieldList = items.map { FieldList(json: $0) } }
        message = json[SerializationKeys.message].string
        eTag = json[SerializationKeys.eTag].string
        success = json[SerializationKeys.success].boolValue
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = fieldList { dictionary[SerializationKeys.fieldList] = value.map { $0.dictionaryRepresentation() } }
        if let value = message { dictionary[SerializationKeys.message] = value }
        if let value = eTag { dictionary[SerializationKeys.eTag] = value }
        dictionary[SerializationKeys.success] = success
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.fieldList = aDecoder.decodeObject(forKey: SerializationKeys.fieldList) as? [FieldList]
        self.message = aDecoder.decodeObject(forKey: SerializationKeys.message) as? String
        self.eTag = aDecoder.decodeObject(forKey: SerializationKeys.eTag) as? String
        self.success = aDecoder.decodeBool(forKey: SerializationKeys.success)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(fieldList, forKey: SerializationKeys.fieldList)
        aCoder.encode(message, forKey: SerializationKeys.message)
        aCoder.encode(eTag, forKey: SerializationKeys.eTag)
        aCoder.encode(success, forKey: SerializationKeys.success)
    }
    
}
