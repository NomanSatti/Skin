//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: UITableViewHeaderFooterView+Extension.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit

extension UITableViewHeaderFooterView {
    
    func setBackgroundViewColor(color: UIColor) {
        let backgroundView = UIView(frame: self.bounds)
        backgroundView.backgroundColor = color
        self.backgroundView = backgroundView
    }
    
}
