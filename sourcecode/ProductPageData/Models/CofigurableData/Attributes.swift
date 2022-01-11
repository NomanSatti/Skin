//
//  Attributes.swift
//
//  Created by bhavuk.chawla on 27/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct Attributes {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let position = "position"
        static let label = "label"
        static let options = "options"
        static let updateProductPreviewImage = "updateProductPreviewImage"
        static let id = "id"
        static let code = "code"
        static let swatchType = "swatchType"
    }
    
    // MARK: Properties
    public var position: String?
    public var label: String?
    public var options = [Options]()
    public var updateProductPreviewImage: Bool? = false
    public var id: String!
    public var code: String?
    public var swatchType: String?
    
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
        position = json[SerializationKeys.position].string
        label = json[SerializationKeys.label].stringValue + " *"
        if let items = json[SerializationKeys.options].array { options = items.map { Options(json: $0) } }
        updateProductPreviewImage = json[SerializationKeys.updateProductPreviewImage].boolValue
        id = json[SerializationKeys.id].stringValue
        code = json[SerializationKeys.code].string
        swatchType = json[SerializationKeys.swatchType].string
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    
}
