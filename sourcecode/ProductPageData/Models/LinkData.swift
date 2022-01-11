//
//  LinkData.swift
//
//  Created by bhavuk.chawla on 06/02/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct LinkData {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let linkTitle = "linkTitle"
        static let linkSampleTitle = "linkSampleTitle"
        static let id = "id"
        static let formattedPrice = "formattedPrice"
        static let mimeType = "mimeType"
        static let fileName = "fileName"
        static let haveLinkSample = "haveLinkSample"
        static let price = "price"
        static let url = "url"
    }
    
    // MARK: Properties
    public var linkTitle: String!
    public var linkSampleTitle: String!
    public var id: String!
    public var formattedPrice: String!
    public var mimeType: String!
    public var fileName: String!
    public var haveLinkSample: Int?
    public var price: String!
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
        linkTitle = json[SerializationKeys.linkTitle].stringValue.html2String
        linkSampleTitle = json[SerializationKeys.linkSampleTitle].stringValue
        id = json[SerializationKeys.id].stringValue
        formattedPrice = json[SerializationKeys.formattedPrice].stringValue
        mimeType = json[SerializationKeys.mimeType].stringValue
        fileName = json[SerializationKeys.fileName].stringValue
        haveLinkSample = json[SerializationKeys.haveLinkSample].int
        price = json[SerializationKeys.price].stringValue
        url = json[SerializationKeys.url].stringValue
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = linkTitle { dictionary[SerializationKeys.linkTitle] = value }
        if let value = linkSampleTitle { dictionary[SerializationKeys.linkSampleTitle] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = formattedPrice { dictionary[SerializationKeys.formattedPrice] = value }
        if let value = mimeType { dictionary[SerializationKeys.mimeType] = value }
        if let value = fileName { dictionary[SerializationKeys.fileName] = value }
        if let value = haveLinkSample { dictionary[SerializationKeys.haveLinkSample] = value }
        if let value = price { dictionary[SerializationKeys.price] = value }
        if let value = url { dictionary[SerializationKeys.url] = value }
        return dictionary
    }
    
}
