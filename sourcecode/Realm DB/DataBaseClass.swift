//

/*
 Mobikul_Magento2V3_App
 @Category Webkul
 @author Webkul
 FileName: DataBaseClass.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html
 */

import RealmSwift

class AllDataCollection: Object {
    @objc dynamic var hashKey: String = ""
    @objc dynamic var data: String = ""
    @objc dynamic var eTag: String = ""
    @objc dynamic var timeStamp: String = String(Date().ticks)
    
    override static func primaryKey() -> String? {
        return "hashKey"
        
    }
    
}

class GetHashKey {
    private init() {
        
    }
    
    static let sharedInstance = GetHashKey()
    
    func getDataBaseObject() -> AllDataCollection {
        return AllDataCollection()
    }
    
    func getHashKey(controllerName: String) -> String {
        
        var valueForHashKey = [String]()
        
        valueForHashKey.append(Defaults.storeId)
        valueForHashKey.append(Defaults.customerToken ?? "")
        valueForHashKey.append(Defaults.quoteId)
        valueForHashKey.append(Defaults.currency ?? "")
        
        return NetworkManager.sharedInstance.getHashKey(forView: controllerName, keys: valueForHashKey)
        
    }
    
    //    var dataBaseObject = AllDataCollection()
}
