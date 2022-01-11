//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: ActionButtonFooterView.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class ActionButtonFooterView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var btn: UIButton!
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        self.applyBorder1(colours: UIColor.black)
    }
    
    func applyBorder1(colours: UIColor) {
        btn.layer.borderColor = colours.cgColor
        btn.layer.borderWidth = 2
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
    
    @IBAction func btnClicked(_ sender: Any) {
        
    }
}
