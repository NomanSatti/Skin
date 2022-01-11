//
/**
 Mobikul_Magento2V3_App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: UIViewController+extensions.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit
import SwiftMessages

extension UIViewController {
    func showOfflineBar() {
        //        let offlineBar = OfflineBar(addedTo: self, style: .reload)
        //        offlineBar.offlineBackgoundColor  = UIColor.red
        //        offlineBar.offlineText = "youareoffline".localized
    }
    
    // Not using static as it wont be possible to override to provide custom storyboardID then
    class var storyboardID: String {
        return "\(self)"
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
    
    func showSuccessSnackBar(msg: String) {
        let info = MessageView.viewFromNib(layout: .messageView)
        info.configureTheme(.success)
        info.button?.isHidden = true
        info.configureContent(title: "success".localized, body: msg)
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationStyle = .top
        infoConfig.presentationContext = .window(windowLevel: UIWindow.Level(rawValue: UIWindow.Level.statusBar.rawValue))
        infoConfig.duration = .seconds(seconds: 3)
        SwiftMessages.show(config: infoConfig, view: info)
    }
    
    func showWarningSnackBar(msg: String) {
        let info = MessageView.viewFromNib(layout: .messageView)
        info.configureTheme(.warning)
        info.button?.isHidden = true
        info.configureContent(title: "warning".localized, body: msg)
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationStyle = .top
        infoConfig.presentationContext = .window(windowLevel: UIWindow.Level(rawValue: UIWindow.Level.statusBar.rawValue))
        infoConfig.duration = .seconds(seconds: 3)
        SwiftMessages.show(config: infoConfig, view: info)
    }
    
    func showErrorSnackBar(msg: String) {
        let info = MessageView.viewFromNib(layout: .messageView)
        info.configureTheme(.error)
        info.button?.isHidden = true
        info.configureContent(title: "error".localized, body: msg)
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationContext = .window(windowLevel: UIWindow.Level(rawValue: UIWindow.Level.statusBar.rawValue))
        infoConfig.presentationStyle = .top
        infoConfig.dimMode = .gray(interactive: true)
        infoConfig.duration = .forever
        SwiftMessages.show(config: infoConfig, view: info)
        
    }
    
    func showInfoSnackBar(msg: String) {
        let info = MessageView.viewFromNib(layout: .messageView)
        info.configureTheme(.info)
        info.configureContent(title: "info".localized, body: msg)
        info.button?.isHidden = true
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationContext = .window(windowLevel: UIWindow.Level(rawValue: UIWindow.Level.statusBar.rawValue))
        infoConfig.presentationStyle = .top
        infoConfig.dimMode = .gray(interactive: true)
        infoConfig.duration = .forever
        SwiftMessages.show(config: infoConfig, view: info)
    }
    
    func showSuccessMessageWithBack(message: String) {
        let AC = UIAlertController(title: "success".localized, message: message, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.navigationController?.popViewController(animated: true)
        })
        
        AC.addAction(okBtn)
        self.present(AC, animated: true, completion: {  })
    }
    
}

extension UIViewController {
    @objc func backPress() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func popBack(_ nb: Int, animated: Bool, completion:((Bool) -> Void)?) {
        if let viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            guard viewControllers.count < nb else {
                self.navigationController?.popToViewController(viewControllers[viewControllers.count - (nb + 1)], animated: animated)
                defer {
                    completion?(true)
                }
                return
            }
        }
    }
}
