//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: AddressBookModel.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation

class AddressBookModel {
    
    var addressDaatArray = [AddressData]()
    var addressCount: Int!
    init?(data: JSON) {
        addressCount = data["addressCount"].intValue
        addressDaatArray.append(AddressData.init(data: data))
    }
    
}

struct AddressData {
    var billingAddress: String?
    var billingId: String?
    var billingIdValue: String?
    var shippingIdValue: String?
    var shippingAddress: String?
    var shippingId: String?
    var otherAddressDataArray = [OtherAddressData]()
    init(data: JSON) {
        self.billingAddress = data["billingAddress"]["value"].stringValue.html2String
        self.shippingAddress = data["shippingAddress"]["value"].stringValue.html2String
        self.billingId = data["billingAddress"]["id"].stringValue
        self.shippingId = data["shippingAddress"]["id"].stringValue
        self.billingIdValue = data["billingAddress"]["id"].stringValue
        self.shippingIdValue = data["shippingAddress"]["id"].stringValue
        for i in 0..<data["additionalAddress"].count {
            otherAddressDataArray.append(OtherAddressData.init(data: data["additionalAddress"][i]))
        }
        
    }
}
struct OtherAddressData {
    var address: String?
    var id: String?
    init(data: JSON) {
        self.address = data["value"].stringValue.html2String
        self.id = data["id"].stringValue
        
    }
}
