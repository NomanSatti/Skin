//
//  Children.swift
//
//  Created by rakesh on 21/07/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Children {
    
    private struct SerializationKeys {
        static let name = "name"
        static let categoryId = "category_id"
        static let children = "children"
    }
    
    // MARK: Properties
    public var name: String?
    public var categoryId: String?
    public var children: [Any]?
    
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    
    public required init(json: JSON) {
        name = json[SerializationKeys.name].string
        categoryId = json[SerializationKeys.categoryId].string
        if let items = json[SerializationKeys.children].array { children = items.map { $0.object} }
    }
    
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = name { dictionary[SerializationKeys.name] = value }
        if let value = categoryId { dictionary[SerializationKeys.categoryId] = value }
        if let value = children { dictionary[SerializationKeys.children] = value }
        return dictionary
    }
    
}
