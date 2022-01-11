//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: ProductQuantityViewTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class ProductQuantityViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    var quantityValue = 1
    weak var delegate: GettingProductQuantity?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        unitLabel.text = String(quantityValue) + " " + "Unit".localized
        delegate?.gettingProductQuantity(qty: quantityValue)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func minusClicked(_ sender: Any) {
        if quantityValue > 1 {
            quantityValue -= 1
            if quantityValue == 1 {
                unitLabel.text = String(quantityValue) + " " + "Unit".localized
            } else {
                unitLabel.text = String(quantityValue) + " " + "Units".localized
            }
        }
        delegate?.gettingProductQuantity(qty: quantityValue)
    }
    
    @IBAction func plusClicked(_ sender: Any) {
        quantityValue += 1
        if quantityValue == 1 {
            unitLabel.text = String(quantityValue) + " " + "Unit".localized
        } else {
            unitLabel.text = String(quantityValue) + " " + "Units".localized
        }
        delegate?.gettingProductQuantity(qty: quantityValue)
    }
}
