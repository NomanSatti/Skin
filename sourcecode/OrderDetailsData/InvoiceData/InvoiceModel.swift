//
//  BaseClass.swift
//
//  Created by bhavuk.chawla on 14/02/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct InvoiceModel {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let orderId = "orderId"
        static let success = "success"
        static let message = "message"
        static let itemList = "itemList"
        static let customerId = "customerId"
        static let totals = "totals"
    }
    
    // MARK: Properties
    public var orderId: Int?
    public var success: Bool? = false
    public var message: String?
    public var itemList = [CartProducts]()
    public var customerId: Int?
    public var totals = [TotalsData]()
    var cartTotal: String!
    
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
        orderId = json[SerializationKeys.orderId].int
        success = json[SerializationKeys.success].boolValue
        message = json[SerializationKeys.message].string
        if let items = json[SerializationKeys.itemList].array { itemList = items.map { CartProducts(json: $0) } }
        customerId = json[SerializationKeys.customerId].int
        if let items = json[SerializationKeys.totals].array {
            let array = items.map { TotalsData(json: $0) }
            totals = array.filter{ $0.unformattedValue != 0 }
        }
        cartTotal = json["cartTotal"].stringValue
    }
    
}
