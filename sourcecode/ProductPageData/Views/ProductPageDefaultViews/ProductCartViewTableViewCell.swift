//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: ProductCartViewTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class ProductCartViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var buyNowBtn: UIButton!
    weak var delegate: AddToCartProduct?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topView.shadowBorder()
        addToCartBtn.setTitle("Add To Cart".localized.uppercased(), for: .normal)
        buyNowBtn.setTitle("Buy Now".localized.uppercased(), for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func addTocartClicked(_ sender: Any) {
        delegate?.addToCartProduct(cart: false)
    }
    
    @IBAction func buyNowClicked(_ sender: Any) {
        delegate?.addToCartProduct(cart: true)
    }
}
