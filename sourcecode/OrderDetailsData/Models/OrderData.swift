//
//  OrderData.swift
//
//  Created by bhavuk.chawla on 03/02/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct OrderData {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let itemList = "itemList"
        static let totals = "totals"
    }
    
    // MARK: Properties
    public var itemList = [CartProducts]()
    public var totals = [TotalsData]()
    
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
        if let items = json[SerializationKeys.itemList].array { itemList = items.map { CartProducts(json: $0) } }
        if let items = json[SerializationKeys.totals].array {
            let array = items.map { TotalsData(json: $0) }
            totals = array.filter{ $0.unformattedValue != 0 }
        }
    }
    
}
