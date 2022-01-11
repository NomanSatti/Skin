//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: SelectionAddressTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class SelectionAddressTableViewCell: UITableViewCell {
    
    @IBOutlet weak var billingSwitch: UISwitch!
    @IBOutlet weak var sameAsShippingLabel: UILabel!
    @IBOutlet weak var billingHeadingLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        billingHeadingLabel.text = "Billing Adddress".localized
        sameAsShippingLabel.text = "Same as Shipping Address".localized
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func switchChanged(_ sender: Any) {
    }
    
}
