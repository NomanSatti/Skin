import Foundation
import RealmSwift

class Productcollection: Object {
    
    @objc dynamic var name: String!
    @objc dynamic var productID: String!
    @objc dynamic var thumbNail: String!
    @objc dynamic var price: String!
    @objc dynamic var dateTime: String!
    @objc dynamic var isInWishlist: String!
    @objc dynamic var isInRange: String!
    
    @objc dynamic var specialPrice: String!
    @objc dynamic var originalPrice: String!
    @objc dynamic var showSpecialPrice: String!
    @objc dynamic var formatedPrice: String!
    
    @objc dynamic var formatedMinPrice: String!
    @objc dynamic var formatedMaxPrice: String!
    @objc dynamic var isAvailable: String!
    @objc dynamic var availability: String!
    
    @objc dynamic var isBundle: String!
    
    override static func primaryKey() -> String? {
        return "productID"
        
    }
    
    convenience init (value: JSON) {
        self.init()
        
        self.name = value["name"].stringValue
        self.productID = value["id"].stringValue
        self.thumbNail = value["thumbNail"].stringValue
        self.price = value["price"].stringValue
        self.dateTime = value["dateTime"].stringValue
        self.isInWishlist = value["isInWishlist"].stringValue
        //self.isInRange = value["isInRange"].stringValue
        self.specialPrice = value["specialPrice"].stringValue
        self.originalPrice = value["originalPrice"].stringValue
        self.formatedPrice = value["formattedPrice"].stringValue
        let formattedFinalPrice = value["formattedFinalPrice"].stringValue
        formatedPrice = formattedFinalPrice
        print(formatedPrice)
        
        let groupedPrice = value["groupedPrice"].stringValue
        let typeId = value["typeId"].stringValue
        if typeId == "grouped" {
            formatedPrice = groupedPrice
        } else if typeId == "bundle" {
            if value["minPrice"].floatValue == value["maxPrice"].floatValue {
                formatedPrice = value["formattedMinPrice"].stringValue
            } else {
                formatedPrice = value["formattedMinPrice"].stringValue + " - " + value["formattedMaxPrice"].stringValue
            }
        } else if typeId == "configurable" {
            if value["price"].floatValue >= value["finalPrice"].floatValue {
                formatedPrice = "\("As low as".localized) \(value["formattedFinalPrice"].stringValue)"
            }
        }
        self.formatedMinPrice = value["formatedMinPrice"].stringValue
        self.formatedMaxPrice = value["formatedMaxPrice"].stringValue
        
        //1: true and 0: false
        self.isAvailable = value["isAvailable"].boolValue ? "1":"0"
        self.availability = value["availability"].stringValue
        
        //1: true and 0: false
        self.isBundle = value["isBundle"].stringValue
        
        let finalPrice = value["finalPrice"].intValue
        let price = value["price"].intValue
        let range = value["isInRange"].boolValue
        
        if finalPrice != 0 && finalPrice < price && range {
            let val  = ((Float(value["price"].intValue  - value["finalPrice"].intValue) / value["price"].floatValue) * 100)
            isInRange = String.init(format: "%.0f", val) + "% " + "OFF".localized
            showSpecialPrice = value["formattedPrice"].stringValue
        } else {
            isInRange = ""
            showSpecialPrice = ""
        }
        
    }
}

func json(from object: Any) -> String? {
    
    guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
        return nil
    }
    return String(data: data, encoding: String.Encoding.utf8)
}


//let x = ["options" : ["13" : ["9"],
//                      "11" : "6",
//                      "7" : "test",
//                      "14" : [ "year" : "2019",
//                               "day" : "10",
//                               "month" : "06" ],
//                      "8" : "test",
//                      "10" : "4",
//                      "12" : [ "8" ],
//                      "15" : [ "hour" : "17",
//                               "year" : "2019",
//                               "month" : "06",
//                               "minute" : "7",
//                               "day_part" : "PM",
//                               "day" : "10" ],
//                      "16" : ["hour" : "17",
//                              "minute" : "23",
//                              "day_part" : "PM"]]]
//
//let y = ["options": ["7":"trst",
//                     "8":"test",
//                     "10":"4",
//                     "11":"6",
//                     "12":["8"],
//                     "13":["9"],
//                     "14":["month":"06",
//                           "day":"10",
//                           "year":"19"],
//                     "15":["month":"06",
//                           "day":"10",
//                           "year":"19",
//                           "hour":"05",
//                           "minute":"10",
//                           "day_part":"pm"],
//                     "16":["hour":"05",
//                           "minute":"10",
//                           "day_part":"pm"]]]
