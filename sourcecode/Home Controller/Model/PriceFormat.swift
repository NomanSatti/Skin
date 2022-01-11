import Foundation
import SwiftyJSON

public final class PriceFormat {
    public var groupSymbol: String?
    public var groupLength: Int?
    public var requiredPrecision: Int?
    public var integerRequired: Int?
    public var precision: Int?
    public var pattern: String?
    public var decimalSymbol: String?
    
    init(json: JSON) {
        groupSymbol = json["groupSymbol"].string
        groupLength = json["groupLength"].int
        requiredPrecision = json["requiredPrecision"].int
        integerRequired = json["integerRequired"].int
        precision = json["precision"].int
        pattern = json["pattern"].string
        decimalSymbol = json["decimalSymbol"].string
    }
}
