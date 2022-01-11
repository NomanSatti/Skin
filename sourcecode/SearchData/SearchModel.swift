import Foundation
import RealmSwift

class SearchModel: Object {
    @objc dynamic var searchSuggestions: String?
    convenience init(data: String) {
        self.init()
        searchSuggestions = data
    }
    
    override class func primaryKey() -> String? {
        return "searchSuggestions"
    }
}

protocol SearchViewModelItem {
    var type: ItemType { get }
    var tableRowCount: Int { get }
}

class SearchSuggestionProduct {
    
    var productName : String!
    var specialPrice : String!
    var hasSpecialPrice : Bool!
    var price : String!
    var productId : String!
    var thumbNail : String!
    
    init(json: JSON) {
        productName = json["productName"].stringValue
        specialPrice = json["specialPrice"].stringValue
        hasSpecialPrice = json["hasSpecialPrice"].boolValue
        price = json["price"].stringValue
        productId = json["productId"].stringValue
        thumbNail = json["thumbNail"].stringValue
    }
}

enum ItemType {
    case suggestions
    case recentSearch
    case categories
}

struct SearchViewModelSuggestionItem: SearchViewModelItem {
    var type: ItemType {
        return .suggestions
    }
    var tableRowCount: Int {
        return products.count
    }
    var products: [SearchSuggestionProduct]
    init(products: [SearchSuggestionProduct] ) {
        self.products = products
    }
}

struct SearchViewModelRecentSearchItem: SearchViewModelItem {
    var type: ItemType {
        return .recentSearch
    }
    var tableRowCount: Int {
        return recentSearch.count
    }
    var recentSearch: [SearchModel]
    init(suggestions: [SearchModel] ) {
        self.recentSearch = suggestions
    }
}

struct SearchViewModelCategoryItem: SearchViewModelItem {
    var type: ItemType {
        return .categories
    }
    var tableRowCount: Int {
        return 1
    }
    var categories: [Categories]
    init(categories: [Categories] ) {
        self.categories = categories
    }
}
