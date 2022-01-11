//
//  Items.swift
//
//  Created by bhavuk.chawla on 04/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct CartProducts {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let groupedProductId = "groupedProductId"
        static let productId = "productId"
        static let messages = "messages"
        static let canMoveToWishlist = "canMoveToWishlist"
        static let thresholdQty = "thresholdQty"
        static let qty = "qty"
        static let name = "name"
        static let typeId = "typeId"
        static let remainingQty = "remainingQty"
        static let price = "price"
        static let options = "options"
        static let sku = "sku"
        static let id = "id"
        static let dominantColor = "dominantColor"
        static let image = "image"
        static let subTotal = "subTotal"
        static let foramtedPrice = "foramtedPrice"
        
    }
    
    // MARK: Properties
    public var groupedProductId: Int?
    public var productId: String!
    public var messages: String!
    public var canMoveToWishlist: Bool? = false
    public var thresholdQty: String!
    public var qty: String!
    public var qties: Qty!
    public var name: String!
    public var typeId: String!
    public var remainingQty: Int?
    public var price: Int!
    public var options = [CartOptions]()
    public var sku: String!
    public var id: String!
    public var dominantColor: String!
    public var image: String!
    public var subTotal: String!
    
    var showSpecialPrice: Bool!
    var strikePrice: NSMutableAttributedString!
    var percentage: String!
    public var finalPrice: Int!
    public var isInRange: Bool! = false
    var formattedPrice: String!
    public var formattedFinalPrice: String!
    var optionString = ""
    var formattedFinalPrice1: String!
    
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
        
       // NetworkManager.sharedInstance.showLoader()
        
        if json[SerializationKeys.sku].stringValue != "TestCustomUpload" {
            let sku = json[SerializationKeys.sku].stringValue
         
        }
        
        
        groupedProductId = json[SerializationKeys.groupedProductId].int
        productId = json[SerializationKeys.productId].stringValue
        
        canMoveToWishlist = json[SerializationKeys.canMoveToWishlist].boolValue
        thresholdQty = json[SerializationKeys.thresholdQty].stringValue
        qty = json[SerializationKeys.qty].stringValue.count > 0 ? json[SerializationKeys.qty].stringValue : json["defaultQty"].stringValue
        name = json[SerializationKeys.name].stringValue
        typeId = json[SerializationKeys.typeId].stringValue
        remainingQty = json[SerializationKeys.remainingQty].int
        price = json[SerializationKeys.price].intValue
        qties = Qty(json: json[SerializationKeys.qty])
        if let items = json[SerializationKeys.options].array { options = items.map { CartOptions(json: $0) } }
        sku = json[SerializationKeys.sku].stringValue
        id = json[SerializationKeys.id].string ?? json["productId"].stringValue
        dominantColor = json[SerializationKeys.dominantColor].stringValue
        image = json[SerializationKeys.image].string ?? json["thumbNail"].stringValue
        subTotal = json[SerializationKeys.subTotal].stringValue
        formattedPrice = json[SerializationKeys.foramtedPrice].string ?? json["formattedPrice"].string ?? json[SerializationKeys.price].stringValue
        
        
        finalPrice = json["finalPrice"].intValue
        formattedFinalPrice = json["formattedFinalPrice"].stringValue
        formattedFinalPrice1 = json["formattedFinalPrice"].stringValue
        isInRange = json["isInRange"].boolValue
        showSpecialPrice = finalPrice != 0 && finalPrice < price && isInRange
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
        
        if options.count > 0 {
            for i in 0..<options.count {
                if i != 0 {
                   optionString += "\n"
                }
                optionString += options[i].label + ": " + options[i].stringValues
            }
        }
        
        if let array = json[SerializationKeys.messages].array , array.count > 0 {
            let text = array.map { $0["text"].stringValue }
            messages = text.joined(separator: ", ")
        }
        
    }
    
    mutating func updateQty(qty: String) {
        self.qty = qty
    }
    
}
