//
//  CategoryImages.swift
//
//  Created by rakesh on 21/07/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class CategoryImages {
    
    private struct SerializationKeys {
        static let id = "id"
        static let banner = "banner"
        static let thumbnail = "thumbnail"
    }
    
    // MARK: Properties
    public var id: String!
    public var banner: String!
    public var thumbnail: String!
    
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    
    public required init(json: JSON) {
        id = json[SerializationKeys.id].stringValue
        banner = json[SerializationKeys.banner].stringValue
        thumbnail = json[SerializationKeys.thumbnail].stringValue
    }
    
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = banner { dictionary[SerializationKeys.banner] = value }
        if let value = thumbnail { dictionary[SerializationKeys.thumbnail] = value }
        return dictionary
    }
    
}
