//
//  BaseClass.swift
//
//  Created by bhavuk.chawla on 03/02/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct OrderDetailsModel {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let customerEmail = "customerEmail"
        static let state = "state"
        static let shipmentList = "shipmentList"
        static let incrementId = "incrementId"
        static let orderDate = "orderDate"
        static let statusLabel = "statusLabel"
        static let billingAddress = "billingAddress"
        static let eTag = "eTag"
        static let canReorder = "canReorder"
        static let success = "success"
        static let shippingAddress = "shippingAddress"
        static let orderData = "orderData"
        static let paymentMethod = "paymentMethod"
        static let hasInvoices = "hasInvoices"
        static let creditmemoList = "creditmemoList"
        static let message = "message"
        static let shippingMethod = "shippingMethod"
        static let invoiceList = "invoiceList"
        static let hasShipments = "hasShipments"
        static let customerName = "customerName"
    }
    
    // MARK: Properties
    public var customerEmail: String!
    public var state: String!
    public var shipmentList = [ShipmentList]()
    public var incrementId: String!
    public var orderDate: String!
    public var statusLabel: String!
    public var billingAddress: String!
    public var eTag: String!
    public var canReorder: Bool? = false
    public var success: Bool? = false
    public var shippingAddress: String!
    public var orderData: OrderData!
    public var paymentMethod: String!
    public var hasInvoices: Bool? = false
    public var creditmemoList: [Any]?
    public var message: String!
    public var shippingMethod: String!
    public var invoiceList = [InvoiceList]()
    public var hasShipments: Bool? = false
    public var customerName: String!
    var statusColorCode: String!
    var orderTotal: String!
    var isEligibleForDeliveryBoy: Bool!
    var picked: Bool!
    var vehicleNumber: String!
    var avatar: String!
    var name: String!
    var otp: String!
    var mobile: String!
    var deliveryboyId: String!
    var customerId: String!
    var rating: String!
    
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
        customerEmail = json[SerializationKeys.customerEmail].stringValue
        state = json[SerializationKeys.state].stringValue
        if let items = json[SerializationKeys.shipmentList].array { shipmentList = items.map { ShipmentList(json: $0) } }
        incrementId = json[SerializationKeys.incrementId].stringValue
        orderDate = json[SerializationKeys.orderDate].stringValue
        statusLabel = json[SerializationKeys.statusLabel].stringValue
        billingAddress = json[SerializationKeys.billingAddress].stringValue.html2String
        eTag = json[SerializationKeys.eTag].stringValue
        canReorder = json[SerializationKeys.canReorder].boolValue
        success = json[SerializationKeys.success].boolValue
        shippingAddress = json[SerializationKeys.shippingAddress].stringValue.html2String
        orderData = OrderData(json: json[SerializationKeys.orderData])
        paymentMethod = json[SerializationKeys.paymentMethod].stringValue
        hasInvoices = json[SerializationKeys.hasInvoices].boolValue
        if let items = json[SerializationKeys.creditmemoList].array { creditmemoList = items.map { $0.object} }
        message = json[SerializationKeys.message].stringValue
        shippingMethod = json[SerializationKeys.shippingMethod].stringValue
        if let items = json[SerializationKeys.invoiceList].array { invoiceList = items.map { InvoiceList(json: $0) } }
        hasShipments = json[SerializationKeys.hasShipments].boolValue
        customerName = json[SerializationKeys.customerName].stringValue
        orderTotal = json["orderTotal"].stringValue
        statusColorCode = json["statusColorCode"].stringValue
        isEligibleForDeliveryBoy = json["isEligibleForDeliveryBoy"].boolValue
        picked = json["picked"].boolValue
        vehicleNumber = json["vehicleNumber"].stringValue
        avatar = json["avatar"].stringValue
        name = json["name"].stringValue
        otp = json["otp"].stringValue
        mobile = json["mobile"].stringValue
        deliveryboyId = json["id"].stringValue
        customerId = json["customerId"].stringValue
        rating = json["rating"].stringValue
    }
    
}
