//
//  ReviewList.swift
//
//  Created by bhavuk.chawla on 26/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct ReviewList {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let details = "details"
        static let title = "title"
        static let reviewOn = "reviewOn"
        static let reviewBy = "reviewBy"
        static let ratings = "ratings"
    }
    
    // MARK: Properties
    public var details: String?
    public var title: String?
    public var reviewOn: String?
    public var reviewBy: String?
    var avgRatings: String!
    var floatRatingValue: Float
    public var ratings: [Ratings]?
    
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
        details = json[SerializationKeys.details].string
        title = json[SerializationKeys.title].string
        reviewOn = json[SerializationKeys.reviewOn].string
        reviewBy = json[SerializationKeys.reviewBy].string
        avgRatings = json["avgRatings"].stringValue
        floatRatingValue = json["avgRatings"].floatValue
        if let items = json[SerializationKeys.ratings].array { ratings = items.map { Ratings(json: $0) } }
    }
    
}
