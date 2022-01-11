//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: AddOns.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */


import Foundation


extension NetworkManager {
    static func AddonsChecks(data: JSON) {
        
        if data["wishlistEnable"] != JSON.null {
            if data["wishlistEnable"].boolValue {
                NetworkManager.AddOnsEnabled.wishlistEnable = true
            } else {
                NetworkManager.AddOnsEnabled.wishlistEnable = false
            }
        }
    }
}

