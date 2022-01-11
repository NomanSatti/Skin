//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: TrackingTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class TrackingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var shippmentId: UILabel!
    @IBOutlet weak var carrierName: UILabel!
    @IBOutlet weak var carrierNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var item: TrackingData! {
        didSet {
            shippmentId.text = "Shipment".localized + " #" + item.id
            carrierName.text = item.title
            carrierNumber.text = item.number
        }
    }
    
}
