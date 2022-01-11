//
//  AddressData.swift
//
//  Created by bhavuk.chawla on 18/02/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct StoredAddressData {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let suffix = "suffix"
        static let firstname = "firstname"
        static let lastname = "lastname"
        static let fax = "fax"
        static let isActive = "is_active"
        static let vatRequestDate = "vat_request_date"
        static let postcode = "postcode"
        static let regionId = "region_id"
        static let vatId = "vat_id"
        static let middlename = "middlename"
        static let attributes = "attributes"
        static let entityId = "entity_id"
        static let region = "region"
        static let isDefaultShipping = "isDefaultShipping"
        static let isDefaultBilling = "isDefaultBilling"
        static let prefix = "prefix"
        static let company = "company"
        static let city = "city"
        static let parentId = "parent_id"
        static let updatedAt = "updated_at"
        static let incrementId = "increment_id"
        static let vatRequestSuccess = "vat_request_success"
        static let street = "street"
        static let countryId = "country_id"
        static let telephone = "telephone"
        static let createdAt = "created_at"
        static let vatIsValid = "vat_is_valid"
        static let vatRequestId = "vat_request_id"
    }
    
    // MARK: Properties
    public var suffix: String?
    public var firstname: String?
    public var lastname: String?
    public var fax: String?
    public var isActive: String?
    public var vatRequestDate: String?
    public var postcode: String?
    public var regionId: String?
    public var vatId: String?
    public var middlename: String?
    public var attributes: Attributes?
    public var entityId: String?
    public var region: String?
    public var isDefaultShipping: String!
    public var isDefaultBilling: String!
    public var prefix: String?
    public var company: String?
    public var city: String?
    public var parentId: String?
    public var updatedAt: String?
    public var incrementId: String?
    public var vatRequestSuccess: String?
    public var street: [String]?
    public var countryId: String?
    public var telephone: String?
    public var createdAt: String?
    public var vatIsValid: String?
    public var vatRequestId: String?
    var defaultCountry: String?
    var email: String?
    
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
        suffix = json[SerializationKeys.suffix].string
        firstname = json[SerializationKeys.firstname].string ?? json["firstName"].string
        lastname = json[SerializationKeys.lastname].string ?? json["lastName"].string
        fax = json[SerializationKeys.fax].string
        isActive = json[SerializationKeys.isActive].string
        vatRequestDate = json[SerializationKeys.vatRequestDate].string
        postcode = json[SerializationKeys.postcode].string
        regionId = json[SerializationKeys.regionId].string
        vatId = json[SerializationKeys.vatId].string
        middlename = json[SerializationKeys.middlename].string
        attributes = Attributes(json: json[SerializationKeys.attributes])
        entityId = json[SerializationKeys.entityId].string
        region = json[SerializationKeys.region].string
        isDefaultShipping = String(json[SerializationKeys.isDefaultShipping].intValue)
        isDefaultBilling = String(json[SerializationKeys.isDefaultBilling].intValue)
        prefix = json[SerializationKeys.prefix].string
        company = json[SerializationKeys.company].string
        city = json[SerializationKeys.city].string
        parentId = json[SerializationKeys.parentId].string
        updatedAt = json[SerializationKeys.updatedAt].string
        incrementId = json[SerializationKeys.incrementId].string
        vatRequestSuccess = json[SerializationKeys.vatRequestSuccess].string
        if let items = json[SerializationKeys.street].array { street = items.map { $0.stringValue } }
        countryId = json[SerializationKeys.countryId].string
        telephone = json[SerializationKeys.telephone].string
        createdAt = json[SerializationKeys.createdAt].string
        vatIsValid = json[SerializationKeys.vatIsValid].string
        vatRequestId = json[SerializationKeys.vatRequestId].string
        defaultCountry = json["defaultCountry"].string
        email = json["email"].string
    }
    
}
