//
//  RatingFormData.swift
//
//  Created by bhavuk.chawla on 08/02/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct RatingFormData {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let id = "id"
        static let name = "name"
        static let values = "values"
    }
    
    // MARK: Properties
    public var id: String!
    public var name: String!
    public var values = [String]()
    
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
        id = json[SerializationKeys.id].stringValue
        name = json[SerializationKeys.name].stringValue
        if let items = json[SerializationKeys.values].array { values = items.map { $0.stringValue } }
    }
    
}
