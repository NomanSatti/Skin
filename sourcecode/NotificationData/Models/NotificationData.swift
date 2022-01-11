//
//  NotificationData.swift
//
//  Created by bhavuk.chawla on 24/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct NotificationData {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let message = "message"
        static let notificationList = "notificationList"
        static let success = "success"
    }
    
    // MARK: Properties
    public var message: String?
    public var notificationList = [NotificationList]()
    public var success: Bool = false
    
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
        message = json[SerializationKeys.message].string
        if let items = json[SerializationKeys.notificationList].array { notificationList = items.map { NotificationList(json: $0) } }
        success = json[SerializationKeys.success].boolValue
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = message { dictionary[SerializationKeys.message] = value }
        //    if let value = notificationList { dictionary[SerializationKeys.notificationList] = value.map { $0.dictionaryRepresentation() } }
        dictionary[SerializationKeys.success] = success
        return dictionary
    }
    
}
