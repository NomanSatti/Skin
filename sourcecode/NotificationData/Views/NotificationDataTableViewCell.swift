//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: NotificationDataTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class NotificationDataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var notificationImage: UIImageView!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var mainView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.shadowBorder()
        mainView.layer.cornerRadius = 4
        notificationImage.clipsToBounds = true
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var item: NotificationList! {
        didSet {
            title.text = item.title
            desc.text = item.content
            notificationImage.setImage(fromURL: item.banner, dominantColor: item.dominantColor)
        }
    }
    
}
