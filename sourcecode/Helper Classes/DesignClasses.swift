//
//  DesignClasses.swift
//  Mobikul Single App
//
//  Created by akash on 17/05/19.
//  Copyright © 2019 Webkul. All rights reserved.
//

import Foundation
import UIKit

class MakeCircle: UIView {
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = true
    }
}

class ImageCircle: UIImageView {
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = true
    }
}

//class RemoveButton: UIButton {
//    
//    override func layoutSubviews() {
//        self.setImage(UIImage(named: "sharp-remove"), for: .normal)
//        self.setTitle("Remove", for: .normal)
//        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: self.frame.width - 24, bottom: 0, right: 0)
//        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -24, bottom: 0, right: 0)
//        self.contentEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
//    }
//}

//class DistanceLayoutConstraint: NSLayoutConstraint {
//    
//    var customConstaint: CGFloat! {
//        didSet {
//            self.constant = CGFloat(50)
//        }
////        get {
////            return self.constant = CGFloat(16)
////        }
////        set {
////            return self.constant = customConstaint
////        }
//    }
//}
