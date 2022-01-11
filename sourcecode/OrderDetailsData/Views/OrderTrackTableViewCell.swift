//
/**
 Med Code Arrow
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: OrderTrackTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */


import UIKit

class OrderTrackTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var otp: UILabel!
    @IBOutlet weak var phNumber: UILabel!
    @IBOutlet weak var ratingBtn: UIButton!
    @IBOutlet weak var vechileNumber: UILabel!
    @IBOutlet weak var trackBtn: UIButton!
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var deliveryImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chatBtn.setTitle("Support".localized, for: .normal)
    }
}
