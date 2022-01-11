//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: OrderHeadingTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class OrderHeadingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var statusWidth: NSLayoutConstraint!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var dateHeading: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateHeading.text = "Placed on".localized
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var statusColor: String! {
        didSet {
            statusLabel.backgroundColor = UIColor().hexToColor( hexString: statusColor)
        }
    }
    
    override func layoutSubviews() {
        if let statusColor = statusColor {
            statusLabel.backgroundColor = UIColor().hexToColor( hexString: statusColor)
        }
    }
    
}
