//
//  BaseClass.swift
//
//  Created by bhavuk.chawla on 28/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct CustomerReviewData {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let message = "message"
        static let totalCount = "totalCount"
        static let eTag = "eTag"
        static let reviewList = "reviewList"
        static let success = "success"
    }
    
    // MARK: Properties
    public var message: String?
    public var totalCount: Int!
    public var eTag: String?
    public var reviewList = [CustomerReviewList]()
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
        message = json[SerializationKeys.message].string
        totalCount = json[SerializationKeys.totalCount].intValue
        eTag = json[SerializationKeys.eTag].string
        if let items = json[SerializationKeys.reviewList].array { reviewList = items.map { CustomerReviewList(json: $0) } }
        success = json[SerializationKeys.success].boolValue
    }
    
    
}
