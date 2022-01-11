//
//  BundleOptions.swift
//
//  Created by bhavuk.chawla on 06/02/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct BundleOptions {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let position = "position"
        static let defaultTitle = "default_title"
        static let parentId = "parent_id"
        static let optionId = "option_id"
        static let optionValues = "optionValues"
        static let title = "title"
        static let required = "required"
        static let type = "type"
    }
    
    // MARK: Properties
    public var position: String!
    public var defaultTitle: String!
    public var parentId: String!
    public var optionId: String!
    public var optionValues = [OptionValues]()
    public var title: String!
    public var required: String!
    public var type: String!
    
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
        position = json[SerializationKeys.position].stringValue
        parentId = json[SerializationKeys.parentId].stringValue
        optionId = json[SerializationKeys.optionId].stringValue
        if let items = json[SerializationKeys.optionValues].array { optionValues = items.map { OptionValues(json: $0) } }
        title = json[SerializationKeys.title].stringValue
        required = json[SerializationKeys.required].stringValue
        
        if required == "1" {
            defaultTitle = json[SerializationKeys.defaultTitle].stringValue + " *"
        } else {
            defaultTitle = json[SerializationKeys.defaultTitle].stringValue
        }
        type = json[SerializationKeys.type].stringValue
    }
    
}
