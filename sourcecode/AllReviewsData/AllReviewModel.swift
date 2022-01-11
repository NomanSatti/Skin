//
//  BaseClass.swift
//
//  Created by bhavuk.chawla on 14/02/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct AllReviewModel {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let ratingData = "ratingData"
        static let message = "message"
        static let rating = "rating"
        static let ratingFormData = "ratingFormData"
        static let reviewList = "reviewList"
        static let success = "success"
    }
    
    // MARK: Properties
    public var ratingData: [RatingData]?
    public var message: String?
    public var rating: String?
    public var ratingFormData: [RatingFormData]?
    public var reviewList =  [ReviewList]()
    public var success: Bool? = false
    
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
        if let items = json[SerializationKeys.ratingData].array { ratingData = items.map { RatingData(json: $0) } }
        message = json[SerializationKeys.message].string
        rating = json[SerializationKeys.rating].string
        if let items = json[SerializationKeys.ratingFormData].array { ratingFormData = items.map { RatingFormData(json: $0) } }
        if let items = json[SerializationKeys.reviewList].array { reviewList = items.map { ReviewList(json: $0) } }
        success = json[SerializationKeys.success].boolValue
    }
    
}
