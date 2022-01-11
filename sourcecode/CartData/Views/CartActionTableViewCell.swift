//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: CartActionTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 */

import UIKit

class CartActionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var continueShoppingBtn: UIButton!
    @IBOutlet weak var emptyCartBtn: UIButton!
    @IBOutlet weak var updateCartBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        updateCartBtn.setTitle("Update Cart".localized, for: .normal)
        emptyCartBtn.setTitle("Empty Cart".localized, for: .normal)
        continueShoppingBtn.setTitle("Continue Shopping".localized, for: .normal)
        continueShoppingBtn.applyBorder(colours: AppStaticColors.accentColor)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
