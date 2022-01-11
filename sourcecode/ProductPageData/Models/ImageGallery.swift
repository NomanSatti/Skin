//
//  ImageGallery.swift
//
//  Created by bhavuk.chawla on 26/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct ImageGallery {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let dominantColor = "dominantColor"
        static let largeImage = "largeImage"
        static let smallImage = "smallImage"
        static let isVideo = "isVideo"
        static let videoUrl = "videoUrl"
    }
    
    // MARK: Properties
    public var dominantColor: String?
    public var largeImage: String?
    public var smallImage: String?
    public var isVideo: Bool?
    public var videoUrl: String?
    
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
        dominantColor = json[SerializationKeys.dominantColor].string
        largeImage = json[SerializationKeys.largeImage].string ?? json["full"].string
        smallImage = json[SerializationKeys.smallImage].string
        isVideo = json[SerializationKeys.isVideo].bool
        videoUrl = json[SerializationKeys.videoUrl].string
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = dominantColor { dictionary[SerializationKeys.dominantColor] = value }
        if let value = largeImage { dictionary[SerializationKeys.largeImage] = value }
        if let value = smallImage { dictionary[SerializationKeys.smallImage] = value }
        if let value = isVideo { dictionary[SerializationKeys.videoUrl] = value }
        if let value = videoUrl { dictionary[SerializationKeys.videoUrl] = value }
        return dictionary
    }
    
}
