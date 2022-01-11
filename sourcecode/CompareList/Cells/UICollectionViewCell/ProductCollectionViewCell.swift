//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: ProductCollectionViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var proImgView: UIImageView!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var proName: UILabel!
    @IBOutlet weak var proPrice: UILabel!
    @IBOutlet weak var proSpecialPrice: UILabel!
    @IBOutlet weak var wishlistBtn: UIButton!
    @IBOutlet weak var starRatingView: UIView!
    @IBOutlet weak var starRatingLbl: UILabel!
    @IBOutlet weak var starRatingViewWidth: NSLayoutConstraint!
    @IBOutlet weak var reviewsBtn: UIButton!
    @IBOutlet weak var addToCartBtn: UIButton!
    weak var delegate: MoveController?
    
    var productData: CompareProductList! {
        didSet {
            proImgView.setImage(fromURL: productData?.thumbNail, dominantColor: productData.dominantColor)
            proName.text = productData?.name
            proPrice.text = productData?.formattedFinalPrice
            proSpecialPrice.text = ""
            if let strikePrice = productData?.strikePrice {
                proSpecialPrice.attributedText = strikePrice
            }
            //            let string  = productData.reviewCount + " " + "Reviews".localized
            //            reviewsBtn.setTitle(string, for: .normal)
            //            starRatingLbl.text = (productData?.rating == "0" || productData?.rating == "0.0" || productData?.rating == "") ? "0" : productData?.rating
            if productData?.rating == "0" || productData?.rating == "0.0" || productData?.rating == "" {
                starRatingViewWidth.constant = 0
                reviewsBtn.setTitle("No Reviews yet".localized, for: .normal)
            } else {
                starRatingViewWidth.constant = 50
                let string  = productData.reviewCount + " " + "Reviews".localized
                reviewsBtn.setTitle(string, for: .normal)
                starRatingLbl.text = productData?.rating
            }
            if (productData?.isInWishlist)! {
                wishlistBtn.setImage(UIImage(named: "ic_compare_favorite_selected"), for: .normal)
            } else {
                wishlistBtn.setImage(UIImage(named: "ic_compare_favorite_unselected"), for: .normal)
            }
            proImgView.contentMode = .scaleAspectFit
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        starRatingView.backgroundColor = AppStaticColors.accentColor
        addToCartBtn.backgroundColor = AppStaticColors.accentColor
    }
    
    // MARK: - UIButton
    @IBAction func removeBtnClicked(_ sender: UIButton) {
        var dict = [String: Any]()
        dict["index"] = sender.tag
        delegate?.moveController(id: (productData?.entityId ?? ""), name: "", dict: dict, jsonData: JSON.null, type: "", controller: .removeCompare)
    }
    
    @IBAction func wishlistBtnClicked(_ sender: UIButton) {
        if Defaults.customerToken == nil {
            let customerLoginVC = SignInViewController.instantiate(fromAppStoryboard: .customer)
            let nav = UINavigationController(rootViewController: customerLoginVC)
            //nav.navigationBar.tintColor = AppStaticColors.accentColor
            nav.modalPresentationStyle = .fullScreen
            self.viewContainingController?.present(nav, animated: true, completion: nil)
        } else {
            if (productData?.isInWishlist)! {
                //remove from wishlist
                var dict = [String: Any]()
                dict["index"] = sender.tag
                dict["entityId"] = productData?.entityId
                dict["wishlistItemId"] = productData?.wishlistItemId
                delegate?.moveController(id: "", name: "", dict: dict, jsonData: JSON.null, type: "", controller: .removeFromWishlist)
            } else {
                //add to wishlist
                var dict = [String: Any]()
                dict["index"] = sender.tag
                dict["entityId"] = productData?.entityId
                dict["wishlistItemId"] = productData?.wishlistItemId
                delegate?.moveController(id: "", name: "", dict: dict, jsonData: JSON.null, type: "", controller: .addToWishlist)
            }
        }
    }
    
    @IBAction func reviewsBtnClicked(_ sender: UIButton) {
        if let count = Int(productData.reviewCount), count != 0 {
            let nextController = AllReviewsDataViewController.instantiate(fromAppStoryboard: .product)
            nextController.productId = productData?.entityId ?? ""
            self.viewContainingController?.navigationController?.pushViewController(nextController, animated: true)
        }
    }
    
    @IBAction func addToCartBtnClicked(_ sender: UIButton) {
        var dict = [String: Any]()
        dict["name"] = productData?.name
        dict["entityId"] = productData?.entityId
        dict["isAvailable"] = productData?.isAvailable
        dict["hasRequiredOptions"] = productData?.hasRequiredOptions
        dict["thumbNail"] = productData?.thumbNail
        
        delegate?.moveController(id: "", name: "", dict: dict, jsonData: JSON.null, type: "", controller: .addToCart)
    }
}
