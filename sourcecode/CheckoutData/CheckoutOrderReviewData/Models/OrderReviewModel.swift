//
//  BaseClass.swift
//
//  Created by bhavuk.chawla on 25/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct OrderReviewModel {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let success = "success"
        static let shippingAddress = "shippingAddress"
        static let orderReviewData = "orderReviewData"
        static let paymentMethods = "paymentMethods"
        static let message = "message"
        static let billingAddress = "billingAddress"
        static let shippingMethod = "shippingMethod"
        static let currencyCode = "currencyCode"
        static let cartCount = "cartCount"
    }
    
    // MARK: Properties
    public var success: Bool? = false
    public var shippingAddress: String?
    public var orderReviewData: OrderReviewData?
    public var paymentMethods = [PaymentMethods]()
    public var message: String?
    public var billingAddress: String?
    public var shippingMethod: String?
    public var currencyCode: String?
    var cartTotal: String!
    public var cartCount: Int?
    var couponCode: String?
    
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
        shippingAddress = json[SerializationKeys.shippingAddress].string
        orderReviewData = OrderReviewData(json: json[SerializationKeys.orderReviewData])
        if let items = json[SerializationKeys.paymentMethods].array { paymentMethods = items.map { PaymentMethods(json: $0) }
            
            
            for method in paymentMethods {
                UserDefaults.standard.set(method.extraInformation, forKey: "bankExtraInfo")
            }
            
            
            
        }
       
        message = json[SerializationKeys.message].string
        billingAddress = json[SerializationKeys.billingAddress].string
        shippingMethod = json[SerializationKeys.shippingMethod].string
        currencyCode = json[SerializationKeys.currencyCode].string
        cartCount = json[SerializationKeys.cartCount].int
        cartTotal = json["cartTotal"].stringValue
        couponCode = json["couponCode"].string
    }
    

        
    
    
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[SerializationKeys.success] = success
        if let value = shippingAddress { dictionary[SerializationKeys.shippingAddress] = value }
        if let value = orderReviewData { dictionary[SerializationKeys.orderReviewData] = value.dictionaryRepresentation() }
        //    if let value = paymentMethods { dictionary[SerializationKeys.paymentMethods] = value.map { $0.dictionaryRepresentation() } }
        if let value = message { dictionary[SerializationKeys.message] = value }
        if let value = billingAddress { dictionary[SerializationKeys.billingAddress] = value }
        if let value = shippingMethod { dictionary[SerializationKeys.shippingMethod] = value }
        if let value = currencyCode { dictionary[SerializationKeys.currencyCode] = value }
        if let value = cartCount { dictionary[SerializationKeys.cartCount] = value }
        return dictionary
    }
    
}
