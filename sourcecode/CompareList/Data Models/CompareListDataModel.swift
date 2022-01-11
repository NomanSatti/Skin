//
//  CompareListDataModel.swift
//
//  Created by Webkul on 19/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public class CompareListDataModel {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let showSwatchOnCollection = "showSwatchOnCollection"
        static let message = "message"
        static let attributeValueList = "attributeValueList"
        static let eTag = "eTag"
        static let productList = "productList"
        static let success = "success"
    }
    
    // MARK: Properties
    var showSwatchOnCollection: Bool? = false
    var message: String?
    var attributeValueList: [CompareAttributeValueList]?
    var eTag: String?
    var productList = [CompareProductList]()
    var success: Bool? = false
    
    // MARK: SwiftyJSON Initializers
    /// Initiates the instance based on the object.
    ///
    /// - parameter object: The object of either Dictionary or Array kind that was passed.
    /// - returns: An initialized instance of the class.
    convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    init(json: JSON) {
        showSwatchOnCollection = json[SerializationKeys.showSwatchOnCollection].boolValue
        message = json[SerializationKeys.message].string
        if let items = json[SerializationKeys.attributeValueList].array { attributeValueList = items.map { CompareAttributeValueList(json: $0) } }
        eTag = json[SerializationKeys.eTag].string
        if let items = json[SerializationKeys.productList].array { productList = items.map { CompareProductList(json: $0) } }
        success = json[SerializationKeys.success].boolValue
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    
    func removeItemAttributesValue(index: Int) {
        
        if let attributeValueListArr = attributeValueList {
            for attr in attributeValueListArr {
                let attributeData = attr
                attributeData.value?.remove(at: index)
            }
        }
    }
}
