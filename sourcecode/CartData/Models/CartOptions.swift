//
//  Options.swift
//
//  Created by bhavuk.chawla on 22/02/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct CartOptions {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let label = "label"
        static let value = "value"
    }
    
    // MARK: Properties
    public var label: String!
    public var value =  [String]()
    var stringValues = ""
    
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
        label = json[SerializationKeys.label].stringValue
        if let items = json[SerializationKeys.value].array { value = items.map { $0.stringValue } }
        stringValues = value.joined(separator: ",")
    }
    
    
}
