//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: OrderListFotterView.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class OrderListFotterView: UIView {
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var backToTop: UIButton!
    
    override func awakeFromNib() {
        descLabel.text = "You have just reached to the bottom of page.".localized
        backToTop.setTitle("Back to Top".localized.uppercased(), for: .normal)
    }
}
