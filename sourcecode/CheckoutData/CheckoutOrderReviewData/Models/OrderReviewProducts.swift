//
//  Items.swift
//
//  Created by bhavuk.chawla on 25/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct OrderReviewProducts {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let unformattedPrice = "unformattedPrice"
        static let productName = "productName"
        static let dominantColor = "dominantColor"
        static let qty = "qty"
        static let subTotal = "subTotal"
        static let thumbNail = "thumbNail"
        static let price = "price"
    }
    
    // MARK: Properties
    public var unformattedPrice: Int?
    public var productName: String!
    public var dominantColor: String!
    public var qty: String!
    public var subTotal: String!
    public var thumbNail: String!
    public var price: String!
    var options = [CartOptions]()
    var optionString = ""
    
    var showSpecialPrice: Bool!
    var strikePrice: NSMutableAttributedString!
    var percentage: String!
    public var finalPrice: Int!
    public var isInRange: Bool! = false
    var formattedPrice: String!
    
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
        if let items = json["option"].array { options = items.map { CartOptions(json: $0) } }
        unformattedPrice = json[SerializationKeys.unformattedPrice].int
        productName = json[SerializationKeys.productName].stringValue
        dominantColor = json[SerializationKeys.dominantColor].stringValue
        qty = json[SerializationKeys.qty].stringValue
        subTotal = json[SerializationKeys.subTotal].stringValue
        thumbNail = json[SerializationKeys.thumbNail].stringValue
        price = json[SerializationKeys.price].stringValue
        formattedPrice = json["foramtedPrice"].string ?? json["formattedPrice"].string ?? json[SerializationKeys.price].stringValue
        if options.count > 0 {
            for i in 0..<options.count {
                optionString += options[i].label + ": " + options[i].stringValues + " "
            }
        }
        
        
        
        showSpecialPrice = json["finalPrice"].intValue != 0 && json["finalPrice"].intValue < json["price"].intValue && isInRange
        if json["unformattedPrice"].floatValue <  json["unformattedOriginalPrice"].floatValue {
            let val  = ((Float(json["price"].intValue  - json["finalPrice"].intValue) / json["price"].floatValue) * 100)
            percentage = String.init(format: ".2f", val) + " " + "OFF".localized
            strikePrice = NSMutableAttributedString(string: json["originalPrice"].stringValue)
            strikePrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: strikePrice.length))
        } else {
            percentage = ""
            strikePrice = NSMutableAttributedString(string: "")
        }
        
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = unformattedPrice { dictionary[SerializationKeys.unformattedPrice] = value }
        if let value = productName { dictionary[SerializationKeys.productName] = value }
        if let value = dominantColor { dictionary[SerializationKeys.dominantColor] = value }
        if let value = qty { dictionary[SerializationKeys.qty] = value }
        if let value = subTotal { dictionary[SerializationKeys.subTotal] = value }
        if let value = thumbNail { dictionary[SerializationKeys.thumbNail] = value }
        if let value = price { dictionary[SerializationKeys.price] = value }
        return dictionary
    }
    
}
