//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: Dictionary+Extension.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation

extension Dictionary {
    func convertDictionaryToString() -> String? {
        do {
            let jsonAddressData =  try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            let jsonaddressString: String = NSString(data: jsonAddressData, encoding: String.Encoding.utf8.rawValue)! as String
            return jsonaddressString
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}

extension Array {
    func convertArrayToString() -> String? {
        do {
            let jsonAddressData =  try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            let jsonaddressString: String = NSString(data: jsonAddressData, encoding: String.Encoding.utf8.rawValue)! as String
            return jsonaddressString
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
