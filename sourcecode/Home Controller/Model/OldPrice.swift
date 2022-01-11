import Foundation
import SwiftyJSON

public final class OldPrice {
    
    private struct SerializationKeys {
        static let amount = "amount"
    }
    
    // MARK: Properties
    public var amount: String?
    
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    
    public required init(json: JSON) {
        amount = json[SerializationKeys.amount].stringValue
    }
    
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = amount { dictionary[SerializationKeys.amount] = value }
        return dictionary
    }
    
}
