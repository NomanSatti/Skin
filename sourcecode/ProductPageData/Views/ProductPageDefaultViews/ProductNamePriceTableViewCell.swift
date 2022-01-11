//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: ProductNamePriceTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class ProductNamePriceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productName: UILabel!
    
    var productType = ""
    var optionProductId = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        percentageLabel.applyBorder(colours: AppStaticColors.priceOrangeColor!)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    var item: ProductPageModel! {
        didSet {
            self.productName.text = item.name
            self.priceLabel.text = item.formattedFinalPrice
            self.oldPriceLabel.attributedText = item.strikePrice
            if item.percentage.count > 0 {
                self.percentageLabel.isHidden = false
                self.percentageLabel.text = item.percentage
            } else {
                self.percentageLabel.isHidden = true
            }
            if productType == "bundle" {
                self.priceLabel.text = item.formattedMinPrice + " - " + item.formattedMaxPrice
            } else if productType == "grouped" {
                self.priceLabel.text = "As low as ".localized + item.groupedPrice
            } else if productType == "configurable" && optionProductId != "" {
                if let arr = item.configurableData?.optionPrices?.filter({ ($0.product ?? "") == optionProductId }), let currency = Defaults.currency, let amount = arr.first?.finalPrice?.amount {
                    self.priceLabel.text = currency + amount
                }
            }
        }
    }
}
