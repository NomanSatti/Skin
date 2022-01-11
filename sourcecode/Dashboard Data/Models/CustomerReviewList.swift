//
//  ReviewList.swift
//
//  Created by bhavuk.chawla on 28/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct CustomerReviewList {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let ratingData = "ratingData"
        static let productId = "productId"
        static let id = "id"
        static let details = "details"
        static let date = "date"
        static let proName = "proName"
        static let thumbNail = "thumbNail"
    }
    
    // MARK: Properties
    public var ratingData: [CustomerRatingData]?
    public var productId: String?
    public var id: String!
    public var details: String?
    public var date: String?
    public var proName: String?
    public var thumbNail: String?
    var totalProductReviews: String!
    var customerRating: Float!
    var totalProductRatings: Float!
    
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
        if let items = json[SerializationKeys.ratingData].array { ratingData = items.map { CustomerRatingData(json: $0) } }
        productId = json[SerializationKeys.productId].string
        id = json[SerializationKeys.id].stringValue
        details = json[SerializationKeys.details].string
        date = json[SerializationKeys.date].string
        proName = json["productName"].string
        thumbNail = json[SerializationKeys.thumbNail].string
        customerRating = json["customerRating"].floatValue
        totalProductReviews = json["totalProductReviews"].stringValue
        totalProductRatings =  json["totalProductRatings"].floatValue
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = ratingData { dictionary[SerializationKeys.ratingData] = value.map { $0.dictionaryRepresentation() } }
        if let value = productId { dictionary[SerializationKeys.productId] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = details { dictionary[SerializationKeys.details] = value }
        if let value = date { dictionary[SerializationKeys.date] = value }
        if let value = proName { dictionary[SerializationKeys.proName] = value }
        if let value = thumbNail { dictionary[SerializationKeys.thumbNail] = value }
        return dictionary
    }
    
}
