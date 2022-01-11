//
//  NotificationList.swift
//
//  Created by bhavuk.chawla on 24/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct NotificationList {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let content = "content"
        static let productId = "productId"
        static let productType = "productType"
        static let id = "id"
        static let productName = "productName"
        static let notificationType = "notificationType"
        static let title = "title"
        static let banner = "banner"
    }
    
    // MARK: Properties
    public var content: String?
    public var productId: String?
    public var productType: String?
    public var id: String!
    public var productName: String?
    public var notificationType: String?
    public var title: String!
    public var banner: String?
    var categoryId: String!
    var categoryName: String!
    var dominantColor: String!
    
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
        content = json[SerializationKeys.content].string
        productId = json[SerializationKeys.productId].string
        productType = json[SerializationKeys.productType].string
        id = json[SerializationKeys.id].stringValue
        productName = json[SerializationKeys.productName].string
        notificationType = json[SerializationKeys.notificationType].string
        title = json[SerializationKeys.title].stringValue
        banner = json[SerializationKeys.banner].string
        categoryId = json["categoryId"].stringValue
        categoryName = json["categoryName"].stringValue
        dominantColor = json["dominantColor"].stringValue
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = content { dictionary[SerializationKeys.content] = value }
        if let value = productId { dictionary[SerializationKeys.productId] = value }
        if let value = productType { dictionary[SerializationKeys.productType] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = productName { dictionary[SerializationKeys.productName] = value }
        if let value = notificationType { dictionary[SerializationKeys.notificationType] = value }
        if let value = title { dictionary[SerializationKeys.title] = value }
        if let value = banner { dictionary[SerializationKeys.banner] = value }
        return dictionary
    }
    
}
