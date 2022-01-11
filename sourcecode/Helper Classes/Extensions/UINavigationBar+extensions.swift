//
/**
 Mobikul_Magento2V3_App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: UINavigationBar+extensions.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit

extension UINavigationBar {
    /// Applies a background gradient with the given colors
    func applyNavigationGradient( colors: [UIColor]) {
        //        var frameAndStatusBar: CGRect = self.bounds
        //        frameAndStatusBar.size.height += 20 // add 20 to account for the status bar
        
        //        setBackgroundImage(UINavigationBar.gradient(size: frameAndStatusBar.size, colors: colors), for: .default)
    }
    
    /// Creates a gradient image with the given settings
    static func gradient(size: CGSize, colors: [UIColor]) -> UIImage? {
        // Turn the colors into CGColors
        let cgcolors = colors.map { $0.cgColor }
        
        // Begin the graphics context
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        
        // If no context was retrieved, then it failed
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // From now on, the context gets ended if any return happens
        defer { UIGraphicsEndImageContext() }
        
        // Create the Coregraphics gradient
        var locations: [CGFloat] = [0.0, 1.0]
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: cgcolors as NSArray as CFArray, locations: &locations) else { return nil }
        
        // Draw the gradient
        context.drawLinearGradient(gradient, start: CGPoint(x: 0.0, y: 0.0), end: CGPoint(x: size.width, y: 0.0), options: [])
        
        // Generate the image (the defer takes care of closing the context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension UINavigationBar {
    func transparentNavigation() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.backgroundColor = .clear
        self.isTranslucent = true
    }
    
    func makeDefaultNavigation() {
        self.setBackgroundImage(nil, for: .default)
        self.shadowImage = nil
        self.backgroundColor = AppStaticColors.primaryColor
        self.isTranslucent = true
    }
}
