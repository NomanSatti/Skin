//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: SelectionMethodTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class SelectionMethodTableViewCell: UITableViewCell {
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var internalImageView: UIImageView!
    @IBOutlet weak var methodName: UILabel!
    
    @IBOutlet weak var extraInfoLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.methodName.numberOfLines = 0
        imageview.layer.borderColor = AppStaticColors.accentColor.cgColor
        imageview.layer.borderWidth = 1
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
