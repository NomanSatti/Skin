//
/**
 Mobikul_Magento2V3_App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: UIImageView+extensions.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import Kingfisher
import UIKit

extension UIImageView {
    func addBlackGradientLayer(frame: CGRect, colors: [UIColor]) {
        let gradient = CAGradientLayer()
        gradient.frame = frame
        
        gradient.colors = colors.map {$0.cgColor}
        self.layer.addSublayer(gradient)
    }
    
    func setImage(fromURL url: String?, dominantColor: String? = "", placeholder: UIImage? = nil) {        
        if let urlString = url, let url = URL(string: urlString) {
            var placeHolder = placeholder
            let resource = ImageResource(downloadURL: url, cacheKey: urlString)
            if let dominantColor = dominantColor, dominantColor.count > 0 {
                self.backgroundColor = UIColor().hexToColor(hexString: dominantColor)
            } else {
                placeHolder = UIImage(named: "placeholder")
            }            
            self.kf.setImage(with: resource, placeholder: placeHolder, options: nil, progressBlock: nil) { (_) in
                self.backgroundColor = UIColor.white
            }
        } else {
            self.image = UIImage(named: "placeholder")
        }
    }
}

public enum ImageAnimation {
    case flipFromLeft
    case flipFromRight
    case fade
    
    /// Kingfisher transition. This keeps all animation code together rather than distributed in the codebase.
    /// Makes it easier to hadle it and modify it in the future
    ///
    /// - Returns: current third party library animator. Currently: ImageTransition
    func convert(withDuration duration: TimeInterval) -> ImageTransition {
        switch self {
        case .flipFromLeft:
            return ImageTransition.flipFromLeft(duration)
        case .flipFromRight:
            return ImageTransition.flipFromRight(duration)
        case .fade:
            return ImageTransition.fade(duration)
        }
    }
}
