//
//  Samples.swift
//
//  Created by bhavuk.chawla on 06/02/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct Samples {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let linkSampleData = "linkSampleData"
        static let title = "title"
        static let hasSample = "hasSample"
    }
    
    // MARK: Properties
    public var linkSampleData = [LinkSampleData]()
    public var title: String?
    public var hasSample: Bool? = false
    
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
        if let items = json[SerializationKeys.linkSampleData].array { linkSampleData = items.map { LinkSampleData(json: $0) } }
        title = json[SerializationKeys.title].string
        hasSample = json[SerializationKeys.hasSample].boolValue
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    
}
