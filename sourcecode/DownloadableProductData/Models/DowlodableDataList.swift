//
//  BaseClass.swift
//
//  Created by bhavuk.chawla on 29/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct DowlodableDataList {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let success = "success"
        static let message = "message"
        static let totalCount = "totalCount"
        static let eTag = "eTag"
        static let downloadsList = "downloadsList"
    }
    
    // MARK: Properties
    public var success: Bool? = false
    public var message: String?
    public var totalCount: Int?
    public var eTag: String?
    public var downloadsList = [DownloadsList]()
    
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
        success = json[SerializationKeys.success].boolValue
        message = json[SerializationKeys.message].string
        totalCount = json[SerializationKeys.totalCount].int
        eTag = json[SerializationKeys.eTag].string
        if let items = json[SerializationKeys.downloadsList].array { downloadsList = items.map { DownloadsList(json: $0) } }
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[SerializationKeys.success] = success
        if let value = message { dictionary[SerializationKeys.message] = value }
        if let value = totalCount { dictionary[SerializationKeys.totalCount] = value }
        if let value = eTag { dictionary[SerializationKeys.eTag] = value }
        //    if let value = downloadsList { dictionary[SerializationKeys.downloadsList] = value.map { $0.dictionaryRepresentation() } }
        return dictionary
    }
    
}
