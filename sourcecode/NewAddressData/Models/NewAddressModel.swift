//
//  BaseClass.swift
//
//  Created by Webkul <support@webkul.com> on 23/01/19
//  Copyright (c) Webkul. All rights reserved.
//

import Foundation

public struct NewAddressModel {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    struct SerializationKeys {
        static let suffixHasOptions = "suffixHasOptions"
        static let prefixHasOptions = "prefixHasOptions"
        static let lastName = "lastName"
        static let eTag = "eTag"
        static let countryData = "countryData"
        static let success = "success"
        static let addressData = "addressData"
        static let prefixOptions = "prefixOptions"
        static let suffixOptions = "suffixOptions"
        static let defaultCountry = "defaultCountry"
        static let message = "message"
        static let streetLineCount = "streetLineCount"
        static let firstName = "firstName"
        static let allowToChooseState = "allowToChooseState"
    }
    
    var keys = SerializationKeys()
    // MARK: Properties
    public var suffixHasOptions: Bool! = false
    public var prefixHasOptions: Bool! = false
    public var lastName: String?
    public var eTag: String?
    public var countryData = [CountryData]()
    public var success: Bool! = false
    //  public var addressData: AddressData?
    public var prefixOptions = [String]()
    public var suffixOptions = [String]()
    public var defaultCountry: String?
    public var message: String?
    public var streetLineCount: Int?
    public var firstName: String?
    public var allowToChooseState: Bool! = false
    var isPrefixRequired: Bool!
    var isPrefixVisible: Bool!
    var isSuffixRequired: Bool!
    var isSuffixVisible: Bool!
    var isTelephoneVisible: Bool!
    var isCompanyVisible: Bool!
    var isFaxVisible: Bool!
    public var addressData: StoredAddressData?
    
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
        prefixHasOptions = json[SerializationKeys.prefixHasOptions].boolValue
        lastName = json[SerializationKeys.lastName].string
        eTag = json[SerializationKeys.eTag].string
        if let items = json[SerializationKeys.countryData].array { countryData = items.map { CountryData(json: $0) } }
        success = json[SerializationKeys.success].boolValue
        //    addressData = AddressData(json: json[SerializationKeys.addressData])
        if let items = json[SerializationKeys.prefixOptions].array { prefixOptions = items.map { $0.stringValue } }
        if let items = json[SerializationKeys.suffixOptions].array { suffixOptions = items.map { $0.stringValue } }
        defaultCountry = json[SerializationKeys.defaultCountry].string
        message = json[SerializationKeys.message].string
        streetLineCount = json[SerializationKeys.streetLineCount].int
        firstName = json[SerializationKeys.firstName].string
        allowToChooseState = json[SerializationKeys.allowToChooseState].boolValue
        self.isPrefixRequired = json["isPrefixRequired"].boolValue
        self.isPrefixVisible = json["isPrefixVisible"].boolValue
        self.isSuffixRequired = json["isSuffixRequired"].boolValue
        self.isSuffixVisible = json["isSuffixVisible"].boolValue
        self.isTelephoneVisible = json["isTelephoneVisible"].boolValue
        self.isCompanyVisible = json["isCompanyVisible"].boolValue
        self.isFaxVisible = json["isFaxVisible"].boolValue
        addressData = StoredAddressData(json: json[SerializationKeys.addressData])
    }
    
    
    func getFirstRegionId(countryId: String) -> String {
        if countryData.count > 0 {
            if let index = countryData.firstIndex(where: { $0.countryId == countryId }) {
                if countryData[index].states.count > 0 {
                    return countryData[index].states.first?.regionId ?? ""
                }
            }
        }
        return ""
    }
}
