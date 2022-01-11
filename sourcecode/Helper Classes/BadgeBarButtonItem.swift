//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: BadgeBarButtonItem.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */


import Foundation
import UIKit

//public class BadgeBarButtonItem: UIBarButtonItem {
//    @IBInspectable
//    public var badgeNumber: Int = 0 {
//        didSet {
//            self.updateBadge()
//        }
//    }
//
//    private let label: UILabel
//
//    required public init?(coder aDecoder: NSCoder)
//    {
//        let label = UILabel()
//        label.backgroundColor = UIColor.red // UIColor().hexToColor(hexString: "#5c9b7f")
//        label.alpha = 0.9
//        label.layer.cornerRadius = 9
//        label.clipsToBounds = true
//        label.isUserInteractionEnabled = false
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textAlignment = .center
//        label.font = UIFont.boldSystemFont(ofSize: 12)
//        label.textColor = .white
//        label.layer.zPosition = 1
//        self.label = label
//
//        super.init(coder: aDecoder)
//
//        self.addObserver(self, forKeyPath: "view", options: [], context: nil)
//    }
//
//    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
//    {
//        self.updateBadge()
//    }
//
//    private func updateBadge()
//    {
//        guard let view = self.value(forKey: "view") as? UIView else { return }
//        if badgeNumber
//        self.label.text = "\(badgeNumber)"
//
//        if self.badgeNumber > 0 && self.label.superview == nil
//        {
//            view.addSubview(self.label)
//
//            self.label.widthAnchor.constraint(equalToConstant: 18).isActive = true
//            self.label.heightAnchor.constraint(equalToConstant: 18).isActive = true
//            self.label.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 9).isActive = true
//            self.label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -9).isActive = true
//        }
//        else if self.badgeNumber == 0 && self.label.superview != nil
//        {
//            self.label.removeFromSuperview()
//        }
//    }
//
//    deinit {
//        self.removeObserver(self, forKeyPath: "view")
//    }
//}

public class BadgeBarButtonItem: UIBarButtonItem {
    @IBInspectable
    public var badgeNumber: Int = 0 {
        didSet {
            self.updateBadge()
        }
    }
    
    private let label: UILabel
    
    required public init?(coder aDecoder: NSCoder) {
        let label = UILabel()
        label.backgroundColor = .white//.red
        label.alpha = 1.0
        label.layer.cornerRadius = 2//9
        label.clipsToBounds = true
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .darkGray//.white
        label.layer.borderColor = UIColor.darkGray.cgColor
        label.layer.borderWidth = 1
        label.layer.zPosition = 1
        self.label = label
        
        super.init(coder: aDecoder)
        
        self.addObserver(self, forKeyPath: "view", options: [], context: nil)
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.updateBadge()
    }
    
    private func updateBadge() {
        guard let view = self.value(forKey: "view") as? UIView else { return }
        self.label.removeFromSuperview()
        if badgeNumber > 99 {
            self.label.text = "99+"
        } else {
            self.label.text = "\(badgeNumber)"
        }
        if self.badgeNumber > 0 && self.label.superview == nil {
            view.addSubview(self.label)
            self.label.removeConstraints(self.label.constraints)
            let width = "\(badgeNumber)".widthOfString(usingFont: UIFont.boldSystemFont(ofSize: 12)) + 10
            self.label.widthAnchor.constraint(equalToConstant: width>18 ? width:18).isActive = true
            self.label.heightAnchor.constraint(equalToConstant: 18).isActive = true
            self.label.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 9).isActive = true
            self.label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -9).isActive = true
        } else if self.badgeNumber == 0 && self.label.superview != nil {
            self.label.removeFromSuperview()
        }
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "view")
    }
}
