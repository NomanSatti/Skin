//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: DasboardAction.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class DasboardAction: UITableViewHeaderFooterView {
    
    @IBOutlet weak var lineviewX: NSLayoutConstraint!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var ordersBtn: UIButton!
    @IBOutlet weak var addressBtn: UIButton!
    @IBOutlet weak var reviewBtn: UIButton!
    
    override func awakeFromNib() {
        addressBtn.setTitle("Address".localized, for: .normal)
        ordersBtn.setTitle("Recent Orders".localized, for: .normal)
        
        //        if Defaults.language == "ar" {
        //
        //        } else {
        //             lineviewX.constant = AppDimensions.screenWidth - AppDimensions.screenWidth/3
        //            lineviewX.constant = ordersBtn.frame.origin.x
        //        }
        
        stackView.shadowBorder()
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    @IBAction func addressClicked(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.lineviewX.constant = sender.frame.origin.x
            self.layoutIfNeeded()
        }
    }
    
    @IBAction func orderClicked(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.lineviewX.constant = sender.frame.origin.x
            self.layoutIfNeeded()
        }
    }
    
    @IBAction func reviewClicked(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.lineviewX.constant = sender.frame.origin.x
            self.layoutIfNeeded()
        }
    }
}
