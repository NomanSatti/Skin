import Foundation
import SwiftyJSON

public final class LanguageData {

  public var id: String!
  public var name: String!
  public var stores: [Stores]!

  init(json: JSON) {
    id = json["id"].stringValue
    name = json["name"].stringValue
    if let items = json["stores"].array { stores = items.map { Stores(json: $0) } }

  }

}
