//
/**
 Mobikul_Magento2V3_App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: String+extensions.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit

extension String {
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func CGFloatValue() -> CGFloat {
        guard let doubleValue = Double(self) else {
            return CGFloat(0.0)
        }
        
        return CGFloat(doubleValue)
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8),
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
    var md5: String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for index in 0..<digestLen {
            hash.appendFormat("%02x", result[index])
        }
        result.deallocate()
        return String(format: hash as String)
    }
    
    var appLanguage: String {
        
        get {
            if let language = Defaults.language {
                return language
            } else {
                Defaults.language = "en"
                return "en"
            }
        }
        
        set(value) {
            Defaults.language = value
        }
        
    }
    
    var localized: String {
        return localized(lang: appLanguage)
    }
    
    var localizeStringUsingSystemLang: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(lang: String?) -> String {
        
        if let lang = lang {
            if let path = Bundle.main.path(forResource: lang, ofType: "lproj") {
                let bundle = Bundle(path: path)
                return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
            }
        }
        
        return localizeStringUsingSystemLang
    }
    
    func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@!."
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
    
    var removeWhiteSpace: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}

extension String {
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
}

extension String {
    func isValidPassword() -> Bool {
        let regularExpression = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{7,}$"
        let passwordValidation = NSPredicate.init(format: "SELF MATCHES %@", regularExpression)
        return passwordValidation.evaluate(with: self.removeSpecialCharsFromString(text: self))
    }
}

extension String {
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars: Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-*=(),.:!_")
        return String(text.filter {okayChars.contains($0) })
    }
}

extension String {
    public func isValidVideo() -> Bool {
        // image formats which you want to check
        let videoFormats = ["mp4", "flv", "3gp", "mov", "avi", "wmv", "m3u8", "ts"]
        if URL(string: self) != nil  {
            let videoExtension = (self as NSString).pathExtension
            return videoFormats.contains(videoExtension)
        }
        return false
    }
}

extension String {
    func setDateFormat() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "MMM d, yyyy"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        
        if let date = dateFormatterGet.date(from: self) {
            //print(date)
            return String(format: "%@ %@ %@", dayFormatter.string(from: date), "at".localized, timeFormatter.string(from: date))
        } else {
            //print("There was an error decoding the string")
            return self
        }
    }
    
    func timeAgo() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "d MMM, yy"
        
        if let date = dateFormatterGet.date(from: self) {
            let elapsedTime = Date().timeIntervalSince(date)
            let hours = floor(elapsedTime / 60 / 60)
            let minutes = floor((elapsedTime - (hours * 60 * 60)) / 60)
            print("\(Int(hours)) hr and \(Int(minutes)) min")
            if hours > 0 {
                if hours > 168 {
                   return dayFormatter.string(from: date)
                } else if hours > 24 && hours <= 168 {
                    return String(format: "%d days", Int(Int(hours)%24))
                } else {
                    if minutes > 0 {
                        return String(format: "%d hr %d min", Int(hours), Int(minutes))
                    } else {
                        return String(format: "%d hr", Int(hours))
                    }
                }
            } else {
                return String(format: "%d min", Int(minutes))
            }
        } else {
            print("There was an error decoding the string")
            return self
        }
    }
}
