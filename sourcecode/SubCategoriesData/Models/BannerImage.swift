//
//  BannerImage.swift
//
//  Created by bhavuk.chawla on 08/02/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct BannerImage {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let dominantColor = "dominantColor"
        static let url = "url"
    }
    
    // MARK: Properties
    public var dominantColor: String?
    public var url: String?
    var bannerType: String!
    var name: String!
    var id: String!
    
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
        dominantColor = json[SerializationKeys.dominantColor].string
        url = json[SerializationKeys.url].string
        id = json["id"].stringValue
        id = json["id"].stringValue
        name = json["name"].stringValue
        bannerType = json["bannerType"].stringValue
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = dominantColor { dictionary[SerializationKeys.dominantColor] = value }
        if let value = url { dictionary[SerializationKeys.url] = value }
        return dictionary
    }
    
}
