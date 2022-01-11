//
//  CategoryProductsModal.swift
//
//  Created by akash on 27/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import RealmSwift

public struct CategoryProductsModal {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let success = "success"
        static let dominantColor = "dominantColor"
        static let productList = "productList"
        static let showSwatchOnCollection = "showSwatchOnCollection"
        static let totalCount = "totalCount"
        static let sortingData = "sortingData"
        static let bannerImage = "bannerImage"
        static let message = "message"
        static let layeredData = "layeredData"
    }
    
    // MARK: Properties
    public var success: Bool? = false
    public var dominantColor: String!
    public var productList: [ProductList]?
    public var showSwatchOnCollection: Bool? = false
    public var totalCount: Int?
    public var sortingData: [SortingData]?
    public var bannerImage: String?
    public var message: String?
    var layeredData = [LayeredData]()
    
    // MARK: SwiftyJSON Initializers
    /// Initiates the instance based on the object.
    ///
    /// - parameter object: The object of either Dictionary or Array kind that was passed.
    /// - returns: An initialized instance of the class.
    public init(object: Any) {
        self.init(json: JSON(object))
    }
    
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    public init(json: JSON) {
        success = json[SerializationKeys.success].boolValue
        dominantColor = json[SerializationKeys.dominantColor].stringValue
        if let items = json[SerializationKeys.productList].array { productList = items.map { ProductList(json: $0) } }
        showSwatchOnCollection = json[SerializationKeys.showSwatchOnCollection].boolValue
        totalCount = json[SerializationKeys.totalCount].int
        if let items = json[SerializationKeys.sortingData].array {
            //sortingData = items.map { SortingData(json: $0) }
            sortingData = []
            for item in items {
                var sortData = SortingData(json: item)
                let name = sortData.label ?? ""
                if sortData.code == "name" {
                    sortData.direction = "0"
                    sortData.label = name + " " + "A to Z".localized
                    sortingData?.append(sortData)
                    
                    sortData.direction = "1"
                    sortData.label = name  + " " + "Z to A".localized
                    sortingData?.append(sortData)
                } else {
                    sortData.direction = "0"
                    sortData.label = name + " " + "Low to High".localized
                    sortingData?.append(sortData)
                    
                    sortData.direction = "1"
                    sortData.label = name + " " + "High to Low".localized
                    sortingData?.append(sortData)
                }
            }
        }
        bannerImage = json[SerializationKeys.bannerImage].string
        
        if let items = json[SerializationKeys.layeredData].array { layeredData = items.map { LayeredData(data: $0)} }
        message = json[SerializationKeys.message].string
    }
    
}

enum ProductDegisn {
    case grid
    case list
}

struct LayeredData {
    var code: String!
    var label: String!
    var option: [LayeredOption]!
    var isSelected: Bool?
    
    init(data: JSON) {
        self.code = data["code"].stringValue
        self.label = data["label"].stringValue
        
        if let arrObj = data["options"].arrayObject {
            self.option = arrObj.map({(val) -> LayeredOption in
                return LayeredOption(data: JSON(val))
            })
        }
    }
    
    mutating func isSelectd (isSelected: Bool) {
        self.isSelected = isSelected
    }
}

struct LayeredOption {
    var id: String = ""
    var label: String = ""
    var count: Int = 0
    var isSelected: Bool = false
    
    init(data: JSON) {
        id = data["id"].stringValue
        label = data["label"].stringValue
        count = data["count"].intValue
    }
    
    mutating func isSelectd (isSelected: Bool) {
        self.isSelected = isSelected
    }
}

class CategoryProductsModalData: Object {
    @objc dynamic var data: String?
    @objc dynamic var categoryId: String?
    convenience init(data: String, categoryId:String ) {
        self.init()
        self.data = data
        self.categoryId = categoryId
    }
    
    override class func primaryKey() -> String? {
        return "categoryId"
    }
}
