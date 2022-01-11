//
//  ConfigurableData.swift
//
//  Created by bhavuk.chawla on 27/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct ConfigurableData {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let chooseText = "chooseText"
        static let productId = "productId"
        static let attributes = "attributes"
        static let swatchData = "swatchData"
        static let optionPrices = "optionPrices"
        static let images = "images"
        static let prices = "prices"
        static let template = "template"
        static let index = "index"
    }
    
    // MARK: Properties
    public var chooseText: String?
    public var productId: String?
    public var attributes = [Attributes]()
    public var swatchData: String?
    public var optionPrices: [OptionPrices]?
    public var images: String!
    public var prices: Prices?
    public var template: String?
    public var index: String!
    
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
        chooseText = json[SerializationKeys.chooseText].string
        productId = json[SerializationKeys.productId].string
        if let items = json[SerializationKeys.attributes].array { attributes = items.map { Attributes(json: $0) } }
        swatchData = json[SerializationKeys.swatchData].string
        if let items = json[SerializationKeys.optionPrices].array { optionPrices = items.map { OptionPrices(json: $0) } }
        images = json[SerializationKeys.images].stringValue
        prices = Prices(json: json[SerializationKeys.prices])
        template = json[SerializationKeys.template].string
        index = json[SerializationKeys.index].stringValue
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    
}
