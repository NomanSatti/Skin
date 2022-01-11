//
//  ShowMessages.swift
//  Magento_POS
//
//  Created by bhavuk.chawla on 04/09/18.
//  Copyright © 2018 bhavuk.chawla. All rights reserved.
//

import Foundation
import SwiftMessages

class ShowNotificationMessages {
    
    private init() { }
    
    static let sharedInstance = ShowNotificationMessages()
    
    func showSuccessSnackBar(message: String) {
        let info = MessageView.viewFromNib(layout: .messageView)
        info.configureTheme(.success)
        info.button?.isHidden = true
        info.configureContent(title: "Success".localized, body: message)
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        infoConfig.presentationStyle = .top
        infoConfig.duration = .seconds(seconds: 2)
        infoConfig.duration = .automatic
        SwiftMessages.show(config: infoConfig, view: info)
    }
    
    func warningView(message: String) {
        let success = MessageView.viewFromNib(layout: .messageView)
        success.configureTheme(.warning)
        success.configureDropShadow()
        success.configureContent(title: "Warning".localized, body: message)
        //        success.configureContent(title: "warning".localized, body: message, iconText: "😳")
        success.button?.isHidden = true
        var successConfig = SwiftMessages.defaultConfig
        successConfig.presentationStyle = .top
        successConfig.duration = .seconds(seconds: 2)
        successConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: successConfig, view: success)
    }
    
    func showSuccessActionSnackBar(message: String, completion: @escaping ((Bool) -> Void)) {
        let info = MessageView.viewFromNib(layout: .messageView)
        info.configureTheme(.success)
        info.button?.isHidden = false
        info.configureContent(title: "Success".localized, body: message)
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        infoConfig.presentationStyle = .top
        info.button?.setTitle("View".localized, for: .normal)
        info.buttonTapHandler = { _ in
            SwiftMessages.hide()
            completion(true)
        }
        infoConfig.duration = .forever
        SwiftMessages.show(config: infoConfig, view: info)
    }
    
}
