//
//  DownloadsList.swift
//
//  Created by bhavuk.chawla on 29/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct DownloadsList {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let state = "state"
        static let status = "status"
        static let incrementId = "incrementId"
        static let proName = "proName"
        static let date = "date"
        static let message = "message"
        static let hash = "hash"
        static let isOrderExist = "isOrderExist"
        static let canReorder = "canReorder"
        static let remainingDownloads = "remainingDownloads"
    }
    
    // MARK: Properties
    public var state: String!
    public var status: String!
    public var incrementId: String!
    public var proName: String!
    public var date: String!
    public var message: String!
    public var hash: String!
    public var isOrderExist: Bool? = false
    public var canReorder: Bool? = false
    public var remainingDownloads: String!
    var statusColorCode: String!
    
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
        state = json[SerializationKeys.state].stringValue
        status = json[SerializationKeys.status].stringValue
        incrementId = json[SerializationKeys.incrementId].stringValue
        proName = json[SerializationKeys.proName].stringValue
        date = json[SerializationKeys.date].stringValue
        message = json[SerializationKeys.message].stringValue
        hash = json[SerializationKeys.hash].stringValue
        isOrderExist = json[SerializationKeys.isOrderExist].boolValue
        canReorder = json[SerializationKeys.canReorder].boolValue
        remainingDownloads = json[SerializationKeys.remainingDownloads].stringValue
        statusColorCode = json["statusColorCode"].stringValue
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = state { dictionary[SerializationKeys.state] = value }
        if let value = status { dictionary[SerializationKeys.status] = value }
        if let value = incrementId { dictionary[SerializationKeys.incrementId] = value }
        if let value = proName { dictionary[SerializationKeys.proName] = value }
        if let value = date { dictionary[SerializationKeys.date] = value }
        if let value = message { dictionary[SerializationKeys.message] = value }
        if let value = hash { dictionary[SerializationKeys.hash] = value }
        dictionary[SerializationKeys.isOrderExist] = isOrderExist
        dictionary[SerializationKeys.canReorder] = canReorder
        if let value = remainingDownloads { dictionary[SerializationKeys.remainingDownloads] = value }
        return dictionary
    }
    
}
