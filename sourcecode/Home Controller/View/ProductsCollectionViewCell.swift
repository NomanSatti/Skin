//
/**
 Mobikul_Magento2V3_App
 @Category Webkul
 @author    Webkul
 Created by: rakesh on 21/07/18
 FileName: ProductsCollectionViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license   https://store.webkul.com/license.html
 */

import UIKit

class ProductsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var newTagBtn: UIButton!
    @IBOutlet weak var wishListButton: UIButton!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var specialPrice: UILabel!
    @IBOutlet weak var availabilityLbl: UILabel!
    
    var productList: ProductList! {
        didSet {
            productImageView.setImage(fromURL: productList.thumbNail!, dominantColor: productList.dominantColor!)
            specialPrice.attributedText = productList.strikePrice
            productName.text = productList.name
            priceLabel.text = "SAR \(productList.finalPrice!)" //productList.formattedFinalPrice
            percentageLabel.text = productList?.percentage
            productImageView.contentMode = .scaleAspectFit
            if productList.isNew ?? false {
                newTagBtn.isHidden = false
            } else {
                newTagBtn.isHidden = true
            }
            if productList.isAvailable ?? true {
                availabilityLbl.text = ""
                availabilityLbl.isHidden = true
            } else {
                availabilityLbl.text = productList.availability
                availabilityLbl.isHidden = false
            }
        }
    }
    
    var relatedProduct: RelatedProductList! {
        didSet {
            productImageView.setImage(fromURL: relatedProduct.thumbNail!, dominantColor: relatedProduct.dominantColor!)
            specialPrice.attributedText = relatedProduct.strikePrice
            productName.text = relatedProduct.name
            percentageLabel.text = relatedProduct.percentage
            priceLabel.text = "SAR \(relatedProduct.finalPrice!)"//formattedPrice
            productImageView.contentMode = .scaleAspectFit
            if relatedProduct.isInWishlist ?? false {
                self.wishListButton.setImage(UIImage(named: "ic_wishlist_fill"), for: .normal)
            } else {
                self.wishListButton.setImage(UIImage(named: "ic_wishlist"), for: .normal)
            }
            if relatedProduct.isNew ?? false {
                newTagBtn.isHidden = false
            } else {
                newTagBtn.isHidden = true
            }
            if relatedProduct.isAvailable ?? true {
                availabilityLbl.text = ""
                availabilityLbl.isHidden = true
            } else {
                availabilityLbl.text = relatedProduct.availability
                availabilityLbl.isHidden = false
            }
        }
    }
    
    var products: Productcollection! {
        didSet {
            productImageView.setImage(fromURL: products.thumbNail, dominantColor: "" )
            productName.text = products.name
            priceLabel.text = "SAR \(products.price!)"
            productImageView.contentMode = .scaleAspectFit
            if products.isInRange == "false" || products.isInRange == "true"{
                percentageLabel.text = ""
            } else {
                percentageLabel.text = products.isInRange
            }
            if products.showSpecialPrice != "" {
                let strikePrice = NSMutableAttributedString(string: products.showSpecialPrice)
                strikePrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: strikePrice.length))
                specialPrice.attributedText = strikePrice
            } else {
                specialPrice.attributedText = NSAttributedString()
            }
            if products.isAvailable == "1" {
                availabilityLbl.text = ""
                availabilityLbl.isHidden = true
            } else {
                availabilityLbl.text = products.availability
                availabilityLbl.isHidden = false
            }
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if NetworkManager.AddOnsEnabled.wishlistEnable {
            wishListButton.isHidden = false
        } else {
            wishListButton.isHidden = true
        }
        mainView.shadowBorderWithCorner()
        newTagBtn.setTitle("New".localized, for: .normal)
        priceLabel.textColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 1 / 1.0)
        productName.textColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 1 / 1.0)
    }
    
}
