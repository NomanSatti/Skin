//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: OrderItemsTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class OrderItemsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var discountPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var productOptions: UILabel!
    @IBOutlet weak var productName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var item: OrderReviewProducts! {
        didSet {
            self.productImg.setImage(fromURL: item.thumbNail, dominantColor: item.dominantColor)
            self.productName.text = item.productName
            self.qtyLabel.text = "Qty".localized + ": " + item.qty
            self.priceLabel.text = item.price
            productOptions.text = item.optionString
            
            self.subTotalLabel.text = "Subtotal".localized + ": " + item.subTotal
            self.discountPriceLabel.attributedText = item.strikePrice
            self.subTotalLabel.halfTextWithColorChange(fullText: self.subTotalLabel.text!, changeText: "Subtotal".localized + ": ", color: AppStaticColors.labelSecondaryColor)
            self.qtyLabel.halfTextWithColorChange(fullText: self.qtyLabel.text!, changeText: "Qty".localized + ": ", color: AppStaticColors.labelSecondaryColor)
        }
    }
    
}
