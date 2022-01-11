//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: ProductActionTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class ProductActionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var compareBtn: UIButton!
    @IBOutlet weak var wishlishtBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        if NetworkManager.AddOnsEnabled.wishlistEnable {
            wishlishtBtn.isHidden = false
        } else {
            wishlishtBtn.isHidden = true
        }
        wishlishtBtn.setTitle("Wishlist".localized.uppercased(), for: .normal)
        compareBtn.setTitle("Compare".localized.uppercased(), for: .normal)
        shareBtn.setTitle("Share".localized.uppercased(), for: .normal)
        if Defaults.language == "ar" {
            shareBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            compareBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            wishlishtBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        }
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func wishlistClicked(_ sender: Any) {
    }
    
    @IBAction func shareClicked(_ sender: Any) {
    }
    
    @IBAction func compareClicked(_ sender: Any) {
    }
}
