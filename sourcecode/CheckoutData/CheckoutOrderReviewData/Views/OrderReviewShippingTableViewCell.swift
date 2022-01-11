//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: OrderReviewShippingTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class OrderReviewShippingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var shippingMethodValue: UILabel!
    @IBOutlet weak var shippingMethodLabel: UILabel!
    @IBOutlet weak var shippingAddressValue: UILabel!
    @IBOutlet weak var shippingAddressLabel: UILabel!
    @IBOutlet weak var shippingInfoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        shippingInfoLabel.text = "Shipping Info".localized
        shippingAddressLabel.text = "Shipping Address".localized
        shippingMethodLabel.text = "Shipping Method".localized
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
