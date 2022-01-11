//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: TableBottomView.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class TableBottomView: UIView {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var backToTopBrn: UIButton!
    @IBOutlet weak var descLabel: UILabel!
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override func awakeFromNib() {
        descLabel.text = "You have just reached to the bottom of page.".localized
        backToTopBrn.setTitle("Back to Top".localized.uppercased(), for: .normal)
        backToTopBrn.isEnabled = false
    }
}
