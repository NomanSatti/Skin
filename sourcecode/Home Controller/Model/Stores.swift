import Foundation
import SwiftyJSON

public final class Stores {
    
    private struct SerializationKeys {
        static let id = "id"
        static let name = "name"
        static let code = "code"
    }
    
    // MARK: Properties
    public var id: String!
    public var name: String!
    public var code: String!
    
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    
    public required init(json: JSON) {
        id = json[SerializationKeys.id].stringValue
        name = json[SerializationKeys.name].stringValue
        code = json[SerializationKeys.code].stringValue
    }
    
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = name { dictionary[SerializationKeys.name] = value }
        if let value = code { dictionary[SerializationKeys.code] = value }
        return dictionary
    }
    
}
