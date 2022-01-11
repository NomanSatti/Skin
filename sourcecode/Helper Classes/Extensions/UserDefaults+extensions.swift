//
/**
 Mobikul_Magento2V3_App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: UserDefaults+extensions.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation

#if os(iOS)
import UIKit
public typealias SystemColor = UIColor
#else
import Cocoa
public typealias SystemColor = NSColor
#endif

extension UserDefaults {
    
    class func set(value: String, key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func fetch(key: String) -> String? {
        if UserDefaults.standard.value(forKey: key) == nil {
            return nil
        } else {
            return  (UserDefaults.standard.value(forKey: key) as? String)
        }
    }
}
//
//
public extension UserDefaults {
    
    func set<T>(_ value: T?, forKey key: Key) {
        set(value, forKey: key.rawValue)
    }
    
    func value<T>(forKey key: Key) -> T? {
        return value(forKey: key.rawValue) as? T
    }
    
    func register(defaults: [Key: Any]) {
        let mapped = Dictionary(uniqueKeysWithValues: defaults.map { (key, value) -> (String, Any) in
            if let color = value as? SystemColor {
                return (key.rawValue, NSKeyedArchiver.archivedData(withRootObject: color))
            } else if let url = value as? URL {
                return (key.rawValue, url.absoluteString)
            } else {
                return (key.rawValue, value)
            }
        })
        
        register(defaults: mapped)
    }
    
}

public extension UserDefaults {
    
    func bool(forKey key: Key) -> Bool {
        return bool(forKey: key.rawValue)
    }
    
    func integer(forKey key: Key) -> Int {
        return integer(forKey: key.rawValue)
    }
    
    func float(forKey key: Key) -> Float {
        return float(forKey: key.rawValue)
    }
    
    func float(forKey key: Key) -> CGFloat {
        return CGFloat(float(forKey: key) as Float)
    }
    
    func double(forKey key: Key) -> Double {
        return double(forKey: key.rawValue)
    }
    
    func url(forKey key: Key) -> URL? {
        return string(forKey: key).flatMap { URL(string: $0) }
    }
    
    func date(forKey key: Key) -> Date? {
        return object(forKey: key.rawValue) as? Date
    }
    
    func string(forKey key: Key) -> String? {
        return string(forKey: key.rawValue)
    }
    
    func set(_ url: URL?, forKey key: Key) {
        set(url?.absoluteString, forKey: key.rawValue)
    }
    
    func set(_ color: SystemColor?, forKey key: Key) {
        guard let color = color else {
            set(nil, forKey: key.rawValue)
            return
        }
        
        let data = NSKeyedArchiver.archivedData(withRootObject: color)
        set(data, forKey: key.rawValue)
    }
    
    func color(forKey key: Key) -> SystemColor? {
        return data(forKey: key.rawValue)
            .flatMap { NSKeyedUnarchiver.unarchiveObject(with: $0) as? SystemColor }
    }
    
}
//
public extension UserDefaults {
    
    struct Key: Hashable, RawRepresentable, ExpressibleByStringLiteral {
        
        public var rawValue: String
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public init(stringLiteral value: String) {
            self.rawValue = value
        }
        
    }
    
}
