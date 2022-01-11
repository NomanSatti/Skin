//
//  WishList.swift
//
//  Created by bhavuk.chawla on 15/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public class WishlistProduct {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let options = "options"
        static let name = "name"
        static let sku = "sku"
        static let productId = "productId"
        static let id = "id"
        static let qty = "qty"
        static let typeId = "typeId"
        static let thumbNail = "thumbNail"
        static let rating = "rating"
        static let price = "price"
        static let wishlistItemId = "wishlistItemId"
        static let availability = "availability"
        static let configurableData = "configurableData"
    }
    
    // MARK: Properties
    public var options = [CartOptions]()
    public var name: String?
    public var sku: String?
    public var productId: String?
    public var id: String?
    public var qty: String?
    public var typeId: String?
    public var thumbNail: String?
    public var rating: Float?
    public var price: Int!
    var dominantColor: String!
    var comment: String!
    var isAvailable: Bool!
    var status: String!
    var hasRequiredOptions: Bool!
    var wishlistItemId: String!
    var showSpecialPrice: Bool!
    var strikePrice: NSMutableAttributedString!
    var percentage: String!
    public var finalPrice: Int!
    public var isInRange: Bool! = false
    var formattedPrice: String!
    var availability: String!
    public var formattedFinalPrice: String!
    public var configurableData: ConfigurableData?
    // MARK: SwiftyJSON Initializers
    /// Initiates the instance based on the object.
    ///
    /// - parameter object: The object of either Dictionary or Array kind that was passed.
    /// - returns: An initialized instance of the class.
    
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    public init(json: JSON) {
        if let items = json[SerializationKeys.options].array { options = items.map { CartOptions(json: $0)} }
        name = json[SerializationKeys.name].string
        sku = json[SerializationKeys.sku].string
        productId = json[SerializationKeys.productId].string
        id = json[SerializationKeys.id].string
        qty = json[SerializationKeys.qty].stringValue
        typeId = json[SerializationKeys.typeId].string
        thumbNail = json[SerializationKeys.thumbNail].string
        rating = json[SerializationKeys.rating].floatValue
        configurableData = ConfigurableData(json: json[SerializationKeys.configurableData])
        comment = json["description"].stringValue
        price = json[SerializationKeys.price].intValue
        isAvailable = json["isAvailable"].boolValue
        hasRequiredOptions = json["hasRequiredOptions"].boolValue
        finalPrice = json["finalPrice"].intValue
        formattedPrice = json["formattedPrice"].stringValue
        formattedFinalPrice = json["formattedFinalPrice"].stringValue
        isInRange = json["isInRange"].boolValue
        dominantColor = json["dominantColor"].stringValue
        wishlistItemId = json["wishlistItemId"].stringValue
        showSpecialPrice = finalPrice != 0 && finalPrice < price && isInRange
        availability = json[SerializationKeys.availability].stringValue
        if showSpecialPrice {
            let val  = ((Float(json["price"].intValue  - json["finalPrice"].intValue) / json["price"].floatValue) * 100)
            percentage = String.init(format: ".2f", val) + " " + "OFF".localized
            strikePrice = NSMutableAttributedString(string: formattedPrice)
            strikePrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: strikePrice.length))
        } else {
            percentage = ""
            formattedFinalPrice = formattedPrice
            strikePrice = NSMutableAttributedString(string: "")
        }
        if !isAvailable {
            status = "Out of Stock".localized
        }
        
        let groupedPrice = json["groupedPrice"].stringValue
        if typeId == "grouped" {
            formattedFinalPrice =  "Starting at".localized + ": " + groupedPrice
        } else if typeId == "bundle" {
            if json["minPrice"].floatValue == json["maxPrice"].floatValue {
                formattedFinalPrice = json["formattedMinPrice"].stringValue
            } else {
                formattedFinalPrice = json["formattedMinPrice"].stringValue + " - " + json["formattedMaxPrice"].stringValue
            }
        } else if typeId == "configurable" {
            if json["price"].floatValue >= json["finalPrice"].floatValue {
                formattedFinalPrice = "\("As low as".localized) \(json["formattedFinalPrice"].stringValue)"
            }
        }
    }
    
    
    func updateQty(qty: String) {
        self.qty = qty
    }
    func updateComment(comment: String) {
        self.comment = comment
    }
    
}
