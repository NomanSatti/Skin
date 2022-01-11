//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: GroupProductTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class GroupProductTableViewCell: UITableViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var qty: UILabel!
    var groupedDict = [String: Any]()
    var index = ""
    var section = 0
    weak var delegate: GettingGroupedData?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    override func layoutSubviews() {
        if let value  = groupedDict[index] as? String {
            qty.text = value
        }
    }
    
    
    @IBAction func minusBtn(_ sender: Any) {
        
        if let value  = groupedDict[index] as? String, let quantity = Int(value) {
            var quantityValue = quantity
            if quantityValue > 0 {
                quantityValue -= 1
                qty.text = String(quantityValue)
            }
            groupedDict[index] = String(quantityValue)
            delegate?.gettingGroupedData(data: groupedDict, section: self.section)
        }
    }
    @IBAction func plusBtn(_ sender: Any) {
        if let value  = groupedDict[index] as? String, let quantity = Int(value) {
            var quantityValue = quantity
            //if quantityValue > 0 {
                quantityValue += 1
                qty.text = String(quantityValue)
            //}
            groupedDict[index] = String(quantityValue)
            delegate?.gettingGroupedData(data: groupedDict, section: self.section)
        }
    }
    
    var item: CartProducts! {
        didSet {
            productImage.setImage(fromURL: item.image, dominantColor: item.dominantColor)
            productName.text = item.name
            priceLabel.text = item.formattedFinalPrice
            qty.text = groupedDict[index] as? String
        }
    }
    
}
