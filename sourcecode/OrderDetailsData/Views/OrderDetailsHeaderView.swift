//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: OrderDetailsHeaderView.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class OrderDetailsHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var arrowBtn: UIButton!
    @IBOutlet weak var backArrrow: UIButton!
    @IBOutlet weak var heading: UILabel!
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override func awakeFromNib() {
        heading.text = "Items Ordered".localized
        backArrrow.setImage(backArrrow.imageView?.image?.flipImage(), for: .normal)
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.viewContainingController?.dismiss(animated: true, completion: nil)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
