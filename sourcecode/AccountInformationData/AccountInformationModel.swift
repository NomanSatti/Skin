//
//  BaseClass.swift
//
//  Created by bhavuk.chawla on 11/02/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct AccountInformationModel {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    struct SerializationKeys {
        static let suffixHasOptions = "suffixHasOptions"
        static let isDOBRequired = "isDOBRequired"
        static let dOBValue = "DOBValue"
        static let middleName = "middleName"
        static let isGenderVisible = "isGenderVisible"
        static let suffixValue = "suffixValue"
        static let email = "email"
        static let lastName = "lastName"
        static let taxValue = "taxValue"
        static let prefixValue = "prefixValue"
        static let eTag = "eTag"
        static let success = "success"
        static let dateFormat = "dateFormat"
        static let isDOBVisible = "isDOBVisible"
        static let genderValue = "genderValue"
        static let isMiddlenameVisible = "isMiddlenameVisible"
        static let suffixOptions = "suffixOptions"
        static let isPrefixVisible = "isPrefixVisible"
        static let isSuffixVisible = "isSuffixVisible"
        static let isTaxVisible = "isTaxVisible"
        static let message = "message"
        static let firstName = "firstName"
        static let currentPassword = "currentPassword"
        static let confirmPassword = "confirmPassword"
        static let newPassword = "newPassword"
    }
    
    // MARK: Properties
    public var suffixHasOptions: Bool! = false
    public var isDOBRequired: Bool! = false
    public var dOBValue: String!
    public var middleName: String!
    public var isGenderVisible: Bool! = false
    public var suffixValue: String!
    public var email: String!
    public var lastName: String!
    public var taxValue: String!
    public var prefixValue: String!
    public var eTag: String!
    public var success: Bool! = false
    public var dateFormat: String!
    public var isDOBVisible: Bool! = false
    public var genderValue: String!
    public var isMiddlenameVisible: Bool! = false
    public var suffixOptions = [String]()
    public var prefixOptions = [String]()
    public var isPrefixVisible: Bool! = false
    public var isSuffixVisible: Bool! = false
    public var isTaxVisible: Bool! = false
    public var message: String!
    public var firstName: String!
    
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
        suffixHasOptions = json[SerializationKeys.suffixHasOptions].boolValue
        isDOBRequired = json[SerializationKeys.isDOBRequired].boolValue
        dOBValue = json[SerializationKeys.dOBValue].string ?? json["dob"].string
        middleName = json[SerializationKeys.middleName].string
        isGenderVisible = json[SerializationKeys.isGenderVisible].boolValue
        suffixValue = json[SerializationKeys.suffixValue].string
        email = json[SerializationKeys.email].string ?? json["email"].string
        lastName = json[SerializationKeys.lastName].string ?? json["lastname"].string
        taxValue = json[SerializationKeys.taxValue].string
        prefixValue = json[SerializationKeys.prefixValue].string
        eTag = json[SerializationKeys.eTag].string
        success = json[SerializationKeys.success].boolValue
        dateFormat = json[SerializationKeys.dateFormat].string
        isDOBVisible = json[SerializationKeys.isDOBVisible].boolValue
        genderValue = json[SerializationKeys.genderValue].string
        isMiddlenameVisible = json[SerializationKeys.isMiddlenameVisible].boolValue
        if let items = json[SerializationKeys.suffixOptions].array { suffixOptions = items.map { $0.stringValue } }
        if let items = json["prefixOptions"].array { prefixOptions = items.map { $0.stringValue } }
        isPrefixVisible = json[SerializationKeys.isPrefixVisible].boolValue
        isSuffixVisible = json[SerializationKeys.isSuffixVisible].boolValue
        isTaxVisible = json[SerializationKeys.isTaxVisible].boolValue
        message = json[SerializationKeys.message].string
        firstName = json[SerializationKeys.firstName].string ?? json["firstname"].string
    }
    
}
