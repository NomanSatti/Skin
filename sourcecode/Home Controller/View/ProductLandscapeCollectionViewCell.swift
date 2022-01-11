//
/**
 Mobikul_Magento2V3_App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: ProductLandscapeCollectionViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class ProductLandscapeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var wishListButton: UIButton!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if NetworkManager.AddOnsEnabled.wishlistEnable {
            wishListButton.isHidden = false
        } else {
            wishListButton.isHidden = true
        }
        mainView.shadowBorderWithCorner()
        //        priceLabel.font = UIFont(name: BOLDFONT, size: 15)
        priceLabel.textColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 1 / 1.0)
        
        //        productName.font = UIFont(name: REGULARFONT, size: 12)
        productName.textColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 1 / 1.0)
        
        // Initialization code
    }
    
}
