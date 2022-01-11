//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: ShipmentDetailTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class ShipmentDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var productName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var item: CartProducts! {
        didSet {
            self.productName.text = item.name
            qtyLabel.text = "Qty Shipped".localized + " - " + item.qty
            self.qtyLabel.halfTextWithColorChange(fullText: self.qtyLabel.text!, changeText: "Qty Shipped".localized + ": ", color: AppStaticColors.labelSecondaryColor)
        }
    }
}
