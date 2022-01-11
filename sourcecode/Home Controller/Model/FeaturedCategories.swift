import Foundation
import SwiftyJSON

public final class FeaturedCategories {
    
    // MARK: Properties
    public var categoryId: String!
    public var url: String!
    public var categoryName: String!
    public var dominantColor: String!
    
    public required init(json: JSON) {
        categoryId = json["categoryId"].stringValue
        url = json["url"].stringValue
        categoryName = json["categoryName"].stringValue
        dominantColor = json["dominantColor"].stringValue
    }
    
}
