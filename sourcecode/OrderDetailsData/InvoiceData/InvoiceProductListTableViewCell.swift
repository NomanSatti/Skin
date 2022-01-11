//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: InvoiceProductListTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class InvoiceProductListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var productOptionsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        productOptionsLabel.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var item: CartProducts! {
        didSet {
            nameLabel.text = item.name
            qtyLabel.text = "Qty Invoiced".localized + " - " + item.qty
            self.subTotalLabel.text = "Subtotal".localized + ": " + item.subTotal
            self.priceLabel.text = "Price".localized + ": " + item.formattedPrice
            //            nameLabel.text = item.name
            
            self.subTotalLabel.halfTextWithColorChange(fullText: self.subTotalLabel.text!, changeText: "Subtotal".localized + ": ", color: AppStaticColors.labelSecondaryColor)
            self.qtyLabel.halfTextWithColorChange(fullText: self.qtyLabel.text!, changeText: "Qty Invoiced".localized + ": ", color: AppStaticColors.labelSecondaryColor)
            self.priceLabel.halfTextWithColorChange(fullText: self.priceLabel.text!, changeText: "Price".localized + ": ", color: AppStaticColors.labelSecondaryColor)
        }
    }
    
}
