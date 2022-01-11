//
//  BaseClass.swift
//
//  Created by bhavuk.chawla on 04/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct CartDataModel {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let crossSellList = "crossSellList"
        static let allowMultipleShipping = "allowMultipleShipping"
        static let items = "items"
        static let subtotal = "subtotal"
        static let totalCount = "totalCount"
        static let cartCount = "cartCount"
        static let tax = "tax"
        static let success = "success"
        static let minimumFormattedAmount = "minimumFormattedAmount"
        static let minimumAmount = "minimumAmount"
        static let showThreshold = "showThreshold"
        static let isCheckoutAllowed = "isCheckoutAllowed"
        static let shipping = "shipping"
        static let grandtotal = "grandtotal"
        static let isAllowedGuestCheckout = "isAllowedGuestCheckout"
        static let totalsData = "totalsData"
        static let cartTotal = "cartTotal"
    }
    
    // MARK: Properties
    public var allowMultipleShipping: Bool? = false
    public var crossSellList = [RelatedProductList]()
    public var cartProducts = [CartProducts]()
    public var totalsData = [TotalsData]()
    public var totalCount: Int?
    public var cartCount: Int?
    public var success: Bool? = false
    public var minimumFormattedAmount: String?
    public var minimumAmount: Int!
    public var showThreshold: Bool? = false
    public var isCheckoutAllowed: Bool! = false
    public var isAllowedGuestCheckout: Bool! = false
    public var cartTotal: String!
    var isVirtual: Bool!
    
    var couponCode: String?
    var unformattedCartTotal: Int!
    var descriptionMessage: String!
    
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
        if let items = json[SerializationKeys.crossSellList].array { crossSellList = items.map { RelatedProductList(json: $0) } }
        allowMultipleShipping = json[SerializationKeys.allowMultipleShipping].boolValue
        if let cartProducts = json[SerializationKeys.items].array { self.cartProducts = cartProducts.map { CartProducts(json: $0) } }
        totalCount = json[SerializationKeys.totalCount].int
        cartCount = json[SerializationKeys.cartCount].int
        success = json[SerializationKeys.success].boolValue
        minimumFormattedAmount = json[SerializationKeys.minimumFormattedAmount].string
        minimumAmount = json[SerializationKeys.minimumAmount].intValue
        showThreshold = json[SerializationKeys.showThreshold].boolValue
        isCheckoutAllowed = json[SerializationKeys.isCheckoutAllowed].boolValue
        isAllowedGuestCheckout = json[SerializationKeys.isAllowedGuestCheckout].boolValue
        cartTotal = json[SerializationKeys.cartTotal].stringValue
        couponCode = json["couponCode"].string
        unformattedCartTotal = json["unformattedCartTotal"].intValue
        descriptionMessage = json["descriptionMessage"].stringValue
        isVirtual = json["isVirtual"].boolValue
        if let items = json[SerializationKeys.totalsData].array {
            let array = items.map { TotalsData(json: $0) }
            totalsData = array.filter{ $0.unformattedValue != 0 }
        }
    }
    
}
