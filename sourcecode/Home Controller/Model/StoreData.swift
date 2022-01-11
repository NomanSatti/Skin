import Foundation
import SwiftyJSON

public final class StoreData {
    
    public var id: String!
    public var name: String!
    public var stores: [Stores]!
    
    init(json: JSON) {
        id = json["id"].stringValue
        name = json["name"].stringValue
        if let items = json["stores"].array { stores = items.map { Stores(json: $0) } }
        
    }
    
}

public final class WebsiteData {
    
    public var id: String!
    public var name: String!
    public var stores: [Stores]!
    
    init(json: JSON) {
        id = json["id"].stringValue
        name = json["name"].stringValue
        if let items = json["stores"].array { stores = items.map { Stores(json: $0) } }
        
    }
    
}
