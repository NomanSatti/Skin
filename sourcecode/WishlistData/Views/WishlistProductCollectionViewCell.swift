//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: WishlistProductCollectionViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class WishlistProductCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: MoveController?
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var optionSBtn: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var crossBtn: UIButton!
    @IBOutlet weak var moveToCartBtn: UIButton!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var noReviewsLbl: UILabel!
    @IBOutlet weak var availabilityLbl: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        crossBtn.layer.cornerRadius = 12
        mainView.shadowBorder()
        noReviewsLbl.text = "No Reviews yet".localized
        moveToCartBtn.setTitle("MOVE TO CART".localized, for: .normal)
        // Initialization code
    }
    @IBAction func cartClicked(_ sender: Any) {
    }
    @IBAction func crossClicked(_ sender: Any) {
    }
    
    var item: WishlistProduct! {
        didSet {
            if item.comment.count > 0 {
                commentBtn.setImage(UIImage(named: "sharp-icon-comment"), for: .normal)
            } else {
                commentBtn.setImage(UIImage(named: "sharp-icon-no-comment"), for: .normal)
            }
            priceLabel.text = item.formattedFinalPrice
            productName.text = item.name
            oldPriceLabel.attributedText = item.strikePrice
            imageView.setImage(fromURL: item.thumbNail, dominantColor: item.dominantColor)
            statusLabel.text = item.status
            qtyLabel.text =  "Qty".localized + ": " + (item.qty ?? "")
            self.qtyLabel.halfTextWithColorChange(fullText: self.qtyLabel.text!, changeText: "Qty".localized + ": ", color: AppStaticColors.labelSecondaryColor)
            if let rating = item.rating, rating > 0 {
                self.noReviewsLbl.isHidden = true
                self.ratingLbl.text = "\(rating)"
                self.ratingView.isHidden = false
            } else {
                self.ratingView.isHidden = true
                self.noReviewsLbl.isHidden = false
            }
            if item.isAvailable ?? true {
                availabilityLbl.text = ""
                availabilityLbl.isHidden = true
            } else {
                availabilityLbl.text = item.availability
                availabilityLbl.isHidden = false
            }
        }
    }
    
    @IBAction func cmntClicked(_ sender: Any) {
        delegate?.moveController(id: item.id!, name: item.name!, dict: [:], jsonData: JSON.null, type: item.comment, controller: AllControllers.commentsController)
    }
    
}
