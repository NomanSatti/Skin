//
//  BaseClass.swift
//
//  Created by bhavuk.chawla on 15/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct WishlistModel {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let wishList = "wishList"
        static let message = "message"
        static let totalCount = "totalCount"
        static let eTag = "eTag"
        static let success = "success"
    }
    
    // MARK: Properties
    public var wishList = [WishlistProduct]()
    public var message: String?
    public var totalCount: Int!
    public var eTag: String?
    public var success: Bool? = false
    
    
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
        if let items = json[SerializationKeys.wishList].array { wishList = items.map { WishlistProduct(json: $0) } }
        message = json[SerializationKeys.message].string
        totalCount = json[SerializationKeys.totalCount].intValue
        eTag = json[SerializationKeys.eTag].string
        success = json[SerializationKeys.success].boolValue
        
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        //    if let value = wishList { dictionary[SerializationKeys.wishList] = value.map { $0.dictionaryRepresentation() } }
        if let value = message { dictionary[SerializationKeys.message] = value }
        if let value = totalCount { dictionary[SerializationKeys.totalCount] = value }
        if let value = eTag { dictionary[SerializationKeys.eTag] = value }
        dictionary[SerializationKeys.success] = success
        return dictionary
    }
    
}
