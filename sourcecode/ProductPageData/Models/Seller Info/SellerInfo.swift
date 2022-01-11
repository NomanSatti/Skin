//
//  SellerInfo.swift
//
//  Created by akash on 11/09/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct SellerInfo {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let reviewDescription = "reviewDescription"
    static let responseRate = "responseRate"
    static let shoptitle = "shoptitle"
    static let sellerRating = "sellerRating"
    static let showResponseRate = "showResponseRate"
    static let showResponseTime = "showResponseTime"
    static let companyLocality = "companyLocality"
    static let responseTime = "responseTime"
    static let displaySellerInfo = "displaySellerInfo"
    static let isPremiumSupplier = "isPremiumSupplier"
    static let sellerAverageRating = "sellerAverageRating"
    static let shopUrl = "shopUrl"
    static let locSeach = "locSeach"
    static let isVerifiedSupplier = "isVerifiedSupplier"
    static let sellerId = "sellerId"
    static let defaultAddressId = "defaultAddressId"
  }

  // MARK: Properties
  public var reviewDescription: String?
  public var responseRate: String?
  public var shoptitle: String?
  public var sellerRating: [SellerRating]?
  public var showResponseRate: Bool? = false
  public var showResponseTime: Bool? = false
  public var companyLocality: String?
  public var responseTime: String?
  public var displaySellerInfo: Bool? = false
  public var isPremiumSupplier: Bool? = false
  public var sellerAverageRating: Int?
  public var shopUrl: String?
  public var locSeach: String?
  public var isVerifiedSupplier: Bool? = false
  public var sellerId: String?
  public var defaultAddressId: String?

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
    reviewDescription = json[SerializationKeys.reviewDescription].string
    responseRate = json[SerializationKeys.responseRate].string
    shoptitle = json[SerializationKeys.shoptitle].string
    if let items = json[SerializationKeys.sellerRating].array { sellerRating = items.map { SellerRating(json: $0) } }
    showResponseRate = json[SerializationKeys.showResponseRate].boolValue
    showResponseTime = json[SerializationKeys.showResponseTime].boolValue
    companyLocality = json[SerializationKeys.companyLocality].string
    responseTime = json[SerializationKeys.responseTime].string
    displaySellerInfo = json[SerializationKeys.displaySellerInfo].boolValue
    isPremiumSupplier = json[SerializationKeys.isPremiumSupplier].boolValue
    sellerAverageRating = json[SerializationKeys.sellerAverageRating].int
    shopUrl = json[SerializationKeys.shopUrl].string
    locSeach = json[SerializationKeys.locSeach].string
    isVerifiedSupplier = json[SerializationKeys.isVerifiedSupplier].boolValue
    sellerId = json[SerializationKeys.sellerId].stringValue
    defaultAddressId = json[SerializationKeys.defaultAddressId].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = reviewDescription { dictionary[SerializationKeys.reviewDescription] = value }
    if let value = responseRate { dictionary[SerializationKeys.responseRate] = value }
    if let value = shoptitle { dictionary[SerializationKeys.shoptitle] = value }
    if let value = sellerRating { dictionary[SerializationKeys.sellerRating] = value.map { $0.dictionaryRepresentation() } }
    dictionary[SerializationKeys.showResponseRate] = showResponseRate
    dictionary[SerializationKeys.showResponseTime] = showResponseTime
    if let value = companyLocality { dictionary[SerializationKeys.companyLocality] = value }
    if let value = responseTime { dictionary[SerializationKeys.responseTime] = value }
    dictionary[SerializationKeys.displaySellerInfo] = displaySellerInfo
    dictionary[SerializationKeys.isPremiumSupplier] = isPremiumSupplier
    if let value = sellerAverageRating { dictionary[SerializationKeys.sellerAverageRating] = value }
    if let value = shopUrl { dictionary[SerializationKeys.shopUrl] = value }
    if let value = locSeach { dictionary[SerializationKeys.locSeach] = value }
    dictionary[SerializationKeys.isVerifiedSupplier] = isVerifiedSupplier
    if let value = sellerId { dictionary[SerializationKeys.sellerId] = value }
    if let value = defaultAddressId { dictionary[SerializationKeys.defaultAddressId] = value }
    return dictionary
  }

}
