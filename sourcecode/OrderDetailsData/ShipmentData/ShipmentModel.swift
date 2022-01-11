//
//  BaseClass.swift
//
//  Created by bhavuk.chawla on 14/02/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct ShipmentModel {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let success = "success"
        static let message = "message"
        static let trackingData = "trackingData"
        static let itemList = "itemList"
        static let eTag = "eTag"
        static let orderId = "orderId"
    }
    
    // MARK: Properties
    public var success: Bool? = false
    public var message: String?
    public var trackingData = [TrackingData]()
    public var itemList = [CartProducts]()
    public var eTag: String?
    public var orderId: Int?
    
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
        message = json[SerializationKeys.message].string
        if let items = json[SerializationKeys.trackingData].array { trackingData = items.map { TrackingData(json: $0) } }
        if let items = json[SerializationKeys.itemList].array { itemList = items.map { CartProducts(json: $0) } }
        eTag = json[SerializationKeys.eTag].string
        orderId = json[SerializationKeys.orderId].int
    }
    
}
