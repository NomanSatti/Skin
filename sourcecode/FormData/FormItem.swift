//
//  FormItem.swift
//  IMOTEX
//
//  Created by bhavuk.chawla on 31/10/18.
//  Copyright © 2018 bhavuk.chawla. All rights reserved.
//

import Foundation
import UIKit

/// ViewModel to display and react to text events, to update data
class FormItem: FormValidable {
    
    var value: Any?
    var value2: Any?
    var placeholder = ""
    var indexPath: IndexPath?
    var valueCompletion: ((String?) -> Void)?
    var valueCompleted: ((String?) -> Void)?
    var isSecure = false
    var isValid = true //FormValidable
    var isRequired = false
    var uiProperties = FormItemUIProperties()
    var keyType = ""
    var keyType2 = ""
    var emailType = false
    var selectedIndex = 0
    var dict = [String: Any]()
    var dropDownEnable = false
    var valiidationType = ""
    var heading = ""
    var image: UIImage!
    var image2: UIImage!
    var rightIcon: UIImage!
    var countryData = [Any]()
    var placeholder2 = ""
    var inputType = ""
    var prifixData = [Any]()
    var id = 0
    var isEditable = true
    var maxDate: Date? = Date()
    var minDate: Date? = nil
    
    // MARK: Init
    init(placeholder: String, value: String? = nil) {
        self.placeholder = placeholder
        self.value = value
        
    }
    
    // MARK: FormValidable
    func checkValidity() {
        if self.isRequired {
            if emailType || valiidationType.contains("validate-email") {
                if let value = self.value as? String {
                    self.isValid = self.value != nil && value.isEmpty == false && value.isEmail
                }
            } else if valiidationType.contains("validate-number") || valiidationType.contains("validate-digits") {
                if let value = self.value as? String {
                    self.isValid = self.value != nil && value.isEmpty == false && value.isNumeric
                }
            } else if valiidationType.contains("validate-alphanum") {
                if let value = self.value as? String {
                    self.isValid = self.value != nil && value.isEmpty == false && value.isAlphanumeric
                }
            } else if valiidationType.contains("validate-url") {
                if let value = self.value as? String {
                    self.isValid = self.value != nil && value.isEmpty == false && value.isUrl
                }
            } else if valiidationType.contains("validate-alpha") {
                if let value = self.value as? String {
                    self.isValid = self.value != nil && value.isEmpty == false && value.isLetters
                }
            } else {
                if let value = self.value as? String {
                    self.isValid = self.value != nil && value.isEmpty == false
                }
                if let value = self.value as? Data {
                    self.isValid = self.value != nil && value.isEmpty == false
                }
            }
        } else {
            self.isValid = true
        }
    }
    
    //    func isValid(_ email: String) -> Bool {
    //
    //    }
    
}

extension String {
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
}

extension String {
    var isUrl: Bool {
        if let url = URL(string: self) {
            // check if your application can open the NSURL instance
            return UIApplication.shared.canOpenURL(url)
        } else {
            return false
        }
    }
}

extension String {
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
}

extension String {
    var isLetters: Bool {
        let letters = CharacterSet.letters
        let range = self.rangeOfCharacter(from: letters)
        
        // range will be nil if no letters is found
        if let _ = range {
            return true
        } else {
            return false
        }
    }
}

extension String {
    var isEmail: Bool {
        let emailRegEx =  """
        (?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}” +
        "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\” +
        "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-” +
        "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
        "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-” +
        "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])
        """
        
        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}

extension String {
    public var isEmpty: Bool {
        if self != "" && self.replacingOccurrences(of: " ", with: "") != "" {
            return false
        }
        return true
    }
}
