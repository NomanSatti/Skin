//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: DashboardReviewTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit
import Cosmos

class DashboardReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var starView: CosmosView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        starView.isUserInteractionEnabled = false
        starView.settings.fillMode = .half
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var item: CustomerReviewList! {
        didSet {
            productName.text = item.proName
            starView.rating = Double(item.customerRating)
            productImageView.setImage(fromURL: item.thumbNail)
            startLabel.text = String(item.customerRating) + " " + "Stars".localized
        }
    }
    
}
