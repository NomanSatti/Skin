//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: OrderDetailsExtraTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class OrderDetailsExtraTableViewCell: UITableViewCell {
    
    @IBOutlet weak var paymentData: UILabel!
    @IBOutlet weak var paymentMthdHeading: UILabel!
    @IBOutlet weak var shippingMthdData: UILabel!
    @IBOutlet weak var shippingMthdHeading: UILabel!
    @IBOutlet weak var billingData: UILabel!
    @IBOutlet weak var billingHeading: UILabel!
    @IBOutlet weak var shippingData: UILabel!
    @IBOutlet weak var shippingHeading: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        shippingHeading.text = "Shipping Address".localized.uppercased()
        billingHeading.text = "Billing Address".localized.uppercased()
        shippingMthdHeading.text = "Shipping Method".localized.uppercased()
        paymentMthdHeading.text = "Payment Method".localized.uppercased()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
