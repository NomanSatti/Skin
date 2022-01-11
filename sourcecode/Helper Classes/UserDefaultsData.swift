//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: UserDefaultsData.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation

struct Defaults {
    enum Key: String {
        case storeId = "storeId"
        case customerToken = "customerId"
        case quoteId = "quoteId"
        case currency = "currency"
        case language = "language"
        case eTag = "eTag"
        case customerEmail = "customerEmail"
        case customerName = "customerName"
        case profilePicture = "profilePicture"
        case profileBanner = "profileBanner"
        case deviceToken = "deviceToken"
        case isAdmin = "isAdmin"
        case isSeller = "isSeller"
        case isSupplier = "isSupplier"
        case isPending = "isPending"
        case appleLanguages = "AppleLanguages"
        case cartBadge = "cartBadge"
        case notificationCount = "notificationCount"
        case searchEnable  = "searchEnable"
        case websiteId  = "websiteId"
    }
    
    static var notificationCount: String? {
        get {
            let notificationCount = UserDefaults.standard.string(forKey: Key.notificationCount.rawValue)
            return notificationCount ?? nil
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.notificationCount.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var searchEnable: String? {
        get {
            let searchEnable = UserDefaults.standard.string(forKey: Key.searchEnable.rawValue)
            return searchEnable
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.searchEnable.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var deviceToken: String? {
        get {
            let deviceToken = UserDefaults.standard.string(forKey: Key.deviceToken.rawValue)
            return deviceToken ?? nil
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.deviceToken.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var cartBadge: String {
        get {
            let cartBadge = UserDefaults.standard.string(forKey: Key.cartBadge.rawValue)
            return cartBadge ?? "0"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.cartBadge.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
//    static var isAdmin: String? {
//        get {
//            let isAdmin = UserDefaults.standard.string(forKey: Key.isAdmin.rawValue)
//            return isAdmin ?? nil
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: Key.isAdmin.rawValue)
//            UserDefaults.standard.synchronize()
//        }
//    }
    
    static var isAdmin: Bool {
        get {
            let isAdmin = UserDefaults.standard.bool(forKey: Key.isAdmin.rawValue)
            return isAdmin
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.isAdmin.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var isSeller: Bool {
        get {
            let isSeller = UserDefaults.standard.bool(forKey: Key.isSeller.rawValue)
            return isSeller
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.isSeller.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var isSupplier: Bool {
        get {
            let isSupplier = UserDefaults.standard.bool(forKey: Key.isSupplier.rawValue)
            return isSupplier
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.isSupplier.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var isPending: String? {
        get {
            let isPending = UserDefaults.standard.string(forKey: Key.isPending.rawValue)
            return isPending ?? nil
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.isPending.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var profileBanner: String? {
        get {
            let profileBanner = UserDefaults.standard.string(forKey: Key.profileBanner.rawValue)
            return profileBanner ?? nil
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.profileBanner.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var profilePicture: String? {
        get {
            let profilePicture = UserDefaults.standard.string(forKey: Key.profilePicture.rawValue)
            return profilePicture ?? nil
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.profilePicture.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var customerName: String? {
        get {
            let customerName = UserDefaults.standard.string(forKey: Key.customerName.rawValue)
            return customerName ?? nil
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.customerName.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var customerEmail: String? {
        get {
            let customerEmail = UserDefaults.standard.string(forKey: Key.customerEmail.rawValue)
            return customerEmail ?? nil
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.customerEmail.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var language: String? {
        get {
            let language = UserDefaults.standard.string(forKey: Key.language.rawValue)
            return language ?? nil
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.language.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var currency: String? {
        get {
            let currency = UserDefaults.standard.string(forKey: Key.currency.rawValue)
            return currency
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.currency.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var storeId: String {
        get {
            let storeId = UserDefaults.standard.string(forKey: Key.storeId.rawValue)
            return storeId ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.storeId.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var quoteId: String {
        get {
            let quoteId = UserDefaults.standard.string(forKey: Key.quoteId.rawValue)
            return quoteId ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.quoteId.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var customerToken: String? {
        get {
            let customerToken = UserDefaults.standard.string(forKey: Key.customerToken.rawValue)
            return customerToken
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.customerToken.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var eTag: String {
        get {
            let eTag = UserDefaults.standard.string(forKey: Key.eTag.rawValue)
            return eTag ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.eTag.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var websiteId: String {
        get {
            let websiteId = UserDefaults.standard.string(forKey: Key.websiteId.rawValue)
            return websiteId ?? "1"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.websiteId.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
}
