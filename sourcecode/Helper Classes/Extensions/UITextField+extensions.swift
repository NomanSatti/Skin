//
/**
 Mobikul_Magento2V3_App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: UITextField+extensions.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit

extension UITextField {
    func bottomBorder(texField: UITextField) {
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 49, width: AppDimensions.screenWidth, height: 1)
        topBorder.backgroundColor = UIColor.gray.cgColor
        texField.layer.addSublayer(topBorder)
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: texField.frame.height - 1.0, width: AppDimensions.screenWidth, height: texField.frame.height - 1.0)
        bottomBorder.backgroundColor = UIColor.gray.cgColor
        texField.layer.addSublayer(bottomBorder)
        
    }
    
    func isLanguageLayoutDirectionRightToLeft() -> Bool {
        let languageCode = UserDefaults.standard
        if #available(iOS 9.0, *) {
            if languageCode.string(forKey: "language") == "ar" {
                return true
            } else {
                return false
            }
            
        } else {
            return false
        }
    }
    
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
}
