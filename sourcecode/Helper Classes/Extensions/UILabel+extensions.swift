//
/**
 Mobikul_Magento2V3_App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: UILabel+extensions.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit

extension UILabel {
    //
    //    func startBlink() {
    //        UIView.animate(withDuration: 0.1,
    //                       delay: 0.0,
    //                       options: [.allowUserInteraction, .curveEaseInOut, .autoreverse, .repeat],
    //                       animations: { self.alpha = 0 },
    //                       completion: nil)
    //    }
    //
    //    func stopBlink() {
    //        layer.removeAllAnimations()
    //        alpha = 1
    //    }
    
    // for changing half color of label
    
    func halfTextWithColorChange(fullText: String, changeText: String, color: UIColor) {
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        self.attributedText = attribute
    }
    
    func halfTextWithVeriousColorChange(fullText: String, changeText: [String], color: UIColor) {
        let strNumber: NSString = fullText as NSString
        let attribute = NSMutableAttributedString.init(string: fullText)
        for item in changeText {
            let range = (strNumber).range(of: item)
            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
        self.attributedText = attribute
    }
    
    func halfTextBoldWithColorChange(fullText: String, changeText: String, color: UIColor, font: UIFont) {
        let attributedString = NSMutableAttributedString(string: fullText, attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (fullText as NSString).range(of: fullText)
        attributedString.addAttributes(boldFontAttribute, range: range)
        
        let strNumber: NSString = fullText as NSString
        let range1 = (strNumber).range(of: changeText)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range1)
        
        self.attributedText = attributedString
    }
}

//extension UILabel {
//    private struct AssociatedKeys {
//        static var padding = UIEdgeInsets()
//    }
//
//    public var padding: UIEdgeInsets? {
//        get {
//            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
//        }
//        set {
//            if let newValue = newValue {
//                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//            }
//        }
//    }
//
//    override open func draw(_ rect: CGRect) {
//        if let insets = padding {
//            //self.drawText(in: rect.inset(by: insets))
//            self.draw(rect.inset(by: insets))
//        } else {
//            self.drawText(in: rect)
//        }
//    }
//
//    override open var intrinsicContentSize: CGSize {
//        guard let text = self.text else { return super.intrinsicContentSize }
//
//        var contentSize = super.intrinsicContentSize
//        var textWidth: CGFloat = frame.size.width
//        var insetsHeight: CGFloat = 0.0
//        var insetsWidth: CGFloat = 0.0
//
//        if let insets = padding {
//            insetsWidth += insets.left + insets.right
//            insetsHeight += insets.top + insets.bottom
//            textWidth -= insetsWidth
//        }
//
//        let newSize = text.boundingRect(with: CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude),
//                                        options: NSStringDrawingOptions.usesLineFragmentOrigin,
//                                        attributes: [NSAttributedString.Key.font: self.font], context: nil)
//
//        contentSize.height = ceil(newSize.size.height) + insetsHeight
//        contentSize.width = ceil(newSize.size.width) + insetsWidth
//
//        return contentSize
//    }
//}
