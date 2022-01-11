//
//  BaseClass.swift
//
//  Created by bhavuk.chawla on 08/02/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct SubCategoryModel {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let success = "success"
        static let message = "message"
        static let hotSeller = "hotSeller"
        static let bannerImage = "bannerImage"
        static let categories = "categories"
        static let eTag = "eTag"
        static let productList = "productList"
    }
    
    // MARK: Properties
    public var success: Bool? = false
    public var message: String?
    public var hotSeller =  [RelatedProductList]()
    public var bannerImage =  [BannerImage]()
    public var categories = [Categories]()
    public var eTag: String?
    public var productList = [RelatedProductList]()
    
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
        if let items = json[SerializationKeys.hotSeller].array { hotSeller = items.map { RelatedProductList(json: $0) } }
        if let items = json[SerializationKeys.bannerImage].array { bannerImage = items.map { BannerImage(json: $0) } }
        if let items = json[SerializationKeys.categories].array { categories = items.map { Categories(json: $0) } }
        eTag = json[SerializationKeys.eTag].string
        if let items = json[SerializationKeys.productList].array { productList = items.map { RelatedProductList(json: $0) } }
    }
    
}
