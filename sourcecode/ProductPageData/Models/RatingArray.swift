//
//  RatingArray.swift
//
//  Created by bhavuk.chawla on 18/02/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import UIKit

public struct RatingArray {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let five = "5"
        static let two = "2"
        static let one = "1"
        static let three = "3"
        static let four = "4"
    }
    
    // MARK: Properties
    public var five: CGFloat!
    public var two: CGFloat!
    public var one: CGFloat!
    public var three: CGFloat!
    public var four: CGFloat!
    
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
        let sum  = json[SerializationKeys.five].floatValue + json[SerializationKeys.four].floatValue + json[SerializationKeys.three].floatValue + json[SerializationKeys.two].floatValue + json[SerializationKeys.one].floatValue
        five = CGFloat((json[SerializationKeys.five].floatValue / sum) * 100)
        two = CGFloat((json[SerializationKeys.two].floatValue / sum) * 100)
        one = CGFloat((json[SerializationKeys.one].floatValue / sum) * 100)
        three = CGFloat((json[SerializationKeys.three].floatValue / sum) * 100)
        four = CGFloat((json[SerializationKeys.four].floatValue / sum) * 100)
    }
    
}
