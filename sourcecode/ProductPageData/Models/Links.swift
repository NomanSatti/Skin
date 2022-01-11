//
//  Links.swift
//
//  Created by bhavuk.chawla on 06/02/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct Links {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let linksPurchasedSeparately = "linksPurchasedSeparately"
        static let linkData = "linkData"
        static let title = "title"
    }
    
    // MARK: Properties
    public var linksPurchasedSeparately: String!
    public var linkData = [LinkData]()
    public var title: String?
    
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
        linksPurchasedSeparately = json[SerializationKeys.linksPurchasedSeparately].stringValue
        if let items = json[SerializationKeys.linkData].array { linkData = items.map { LinkData(json: $0) } }
        if linksPurchasedSeparately == "1" {
            title = json[SerializationKeys.title].stringValue + " " + "*"
        } else {
            title = json[SerializationKeys.title].string
        }
        
    }
    
}
