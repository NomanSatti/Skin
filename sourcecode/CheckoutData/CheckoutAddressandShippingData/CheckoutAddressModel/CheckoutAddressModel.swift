//
//  BaseClass.swift
//
//  Created by bhavuk.chawla on 18/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public class CheckoutAddressModel {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let suffixHasOptions = "suffixHasOptions"
        static let middleName = "middleName"
        static let prefixHasOptions = "prefixHasOptions"
        static let suffixValue = "suffixValue"
        static let address = "address"
        static let lastName = "lastName"
        static let prefixValue = "prefixValue"
        static let cartCount = "cartCount"
        static let isVirtual = "isVirtual"
        static let success = "success"
        static let prefixOptions = "prefixOptions"
        static let suffixOptions = "suffixOptions"
        static let defaultCountry = "defaultCountry"
        static let message = "message"
        static let firstName = "firstName"
        static let streetLineCount = "streetLineCount"
        static let allowToChooseState = "allowToChooseState"
    }
    
    // MARK: Properties
    public var suffixHasOptions: Bool? = false
    public var middleName: String?
    public var prefixHasOptions: Bool? = false
    public var suffixValue: String?
    public var address = [Address]()
    public var lastName: String?
    public var prefixValue: String?
    public var cartCount: Int?
    public var isVirtual: Bool? = false
    public var success: Bool? = false
    public var prefixOptions: [String]?
    public var suffixOptions: [String]?
    public var defaultCountry: String?
    public var message: String?
    public var firstName: String?
    public var streetLineCount: Int?
    public var allowToChooseState: Bool? = false
    
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    public init(json: JSON) {
        suffixHasOptions = json[SerializationKeys.suffixHasOptions].boolValue
        middleName = json[SerializationKeys.middleName].string
        prefixHasOptions = json[SerializationKeys.prefixHasOptions].boolValue
        suffixValue = json[SerializationKeys.suffixValue].string
        if let items = json[SerializationKeys.address].array { address = items.map { Address(json: $0) } }
        lastName = json[SerializationKeys.lastName].string
        prefixValue = json[SerializationKeys.prefixValue].string
        cartCount = json[SerializationKeys.cartCount].int
        isVirtual = json[SerializationKeys.isVirtual].boolValue
        success = json[SerializationKeys.success].boolValue
        if let items = json[SerializationKeys.prefixOptions].array { prefixOptions = items.map { $0.stringValue } }
        if let items = json[SerializationKeys.suffixOptions].array { suffixOptions = items.map { $0.stringValue } }
        defaultCountry = json[SerializationKeys.defaultCountry].string
        message = json[SerializationKeys.message].string
        firstName = json[SerializationKeys.firstName].string
        streetLineCount = json[SerializationKeys.streetLineCount].int
        allowToChooseState = json[SerializationKeys.allowToChooseState].boolValue
    }
    
}
