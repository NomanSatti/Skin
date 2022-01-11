//
//  CmsData.swift
//
//  Created by rakesh on 21/07/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class CmsData {
    
    private struct SerializationKeys {
        static let id = "id"
        static let title = "title"
    }
    
    // MARK: Properties
    public var id: String?
    public var title: String?
    
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    
    public required init(json: JSON) {
        id = json[SerializationKeys.id].string
        title = json[SerializationKeys.title].string
    }
    
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = title { dictionary[SerializationKeys.title] = value }
        return dictionary
    }
    
}
