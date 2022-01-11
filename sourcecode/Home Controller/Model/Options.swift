import Foundation
import SwiftyJSON

public final class Options {
    public var id: String!
    public var label: String!
    public var products = [String]()
    
    init(json: JSON) {
        id = json["id"].stringValue
        label = json["label"].stringValue
        if let items = json["products"].array { products = items.map { $0.stringValue } }
    }
}
