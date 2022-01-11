import Foundation
import SwiftyJSON

public final class Prices {
    
    var finalPrice: FinalPrice?
    var oldPrice: OldPrice?
    var basePrice: BasePrice?
    
    init(json: JSON) {
        finalPrice = FinalPrice(json: json["finalPrice"])
        oldPrice = OldPrice(json: json["oldPrice"])
        basePrice = BasePrice(json: json["basePrice"])
    }
    
}
