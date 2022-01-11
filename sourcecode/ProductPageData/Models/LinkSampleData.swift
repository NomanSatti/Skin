//
//  LinkSampleData.swift
//
//  Created by bhavuk.chawla on 06/02/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct LinkSampleData {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let sampleTitle = "sampleTitle"
        static let mimeType = "mimeType"
        static let fileName = "fileName"
        static let url = "url"
    }
    
    // MARK: Properties
    public var sampleTitle: String!
    public var mimeType: String!
    public var fileName: String!
    public var url: String!
    
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
        sampleTitle = json[SerializationKeys.sampleTitle].stringValue
        mimeType = json[SerializationKeys.mimeType].stringValue
        fileName = json[SerializationKeys.fileName].stringValue
        url = json[SerializationKeys.url].stringValue
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = sampleTitle { dictionary[SerializationKeys.sampleTitle] = value }
        if let value = mimeType { dictionary[SerializationKeys.mimeType] = value }
        if let value = fileName { dictionary[SerializationKeys.fileName] = value }
        if let value = url { dictionary[SerializationKeys.url] = value }
        return dictionary
    }
    
}
