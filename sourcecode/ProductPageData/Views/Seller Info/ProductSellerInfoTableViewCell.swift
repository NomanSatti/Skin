//
//  ProductSellerInfoTableViewCell.swift
//  Mobikul Single App
//
//  Created by akash on 11/09/19.
//  Copyright © 2019 Webkul. All rights reserved.
//

import UIKit

class ProductSellerInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var sellByLbl: UILabel!
    @IBOutlet weak var sellerNameLbl: UILabel!
    @IBOutlet weak var verifiedImg: UIImageView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var ratingViewHeight: NSLayoutConstraint!
    @IBOutlet weak var averageRatinglbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var noReviewLbl: UILabel!
    @IBOutlet weak var supplierContactViewHeight: NSLayoutConstraint!
    @IBOutlet weak var requestQuoteBtn: UIButton!
    @IBOutlet weak var quickOrderbtn: UIButton!
    @IBOutlet weak var sendMessagebtn: UIButton!
    @IBOutlet weak var contactUsBtn: UIButton!
    @IBOutlet weak var contactUsBtnHeight: NSLayoutConstraint!
    
    var callBack: ((SellerInfoActionType) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //mainView.shadowBorder()
        requestQuoteBtn.applyButtonBorder(colours: .black)
        sendMessagebtn.applyButtonBorder(colours: .black)
        contactUsBtn.applyButtonBorder(colours: .black)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var item: SellerInfo? {
        didSet {
            guard let item = item else { return }
                        sellByLbl.text = "Sold By".localized
            sellerNameLbl.text = item.shoptitle
            sellerNameLbl.addTapGestureRecognizer {
//                let viewController = SellerInfoViewController.instantiate(fromAppStoryboard: .seller)
//                viewController.sellerId = item.sellerId ?? ""
//                viewController.navTitle = item.shoptitle ?? ""
//                self.viewContainingController?.navigationController?.pushViewController(viewController, animated: true)
            }
            if item.isVerifiedSupplier ?? false {
                verifiedImg.image = UIImage(named: "security")
            } else {
                verifiedImg.image = nil
            }
            addressLbl.text = item.locSeach
            if let rating = item.sellerAverageRating, rating != 0 {
                ratingViewHeight.constant = 50
                averageRatinglbl.text = "\(rating)"
                noReviewLbl.text = ""
            } else {
                ratingViewHeight.constant = 0
                noReviewLbl.text = "No Reviews yet".localized
            }
            ratingLbl.text = item.reviewDescription
            requestQuoteBtn.setTitle("Request a Quote".localized, for: .normal)
            quickOrderbtn.setTitle("Quick Order".localized, for: .normal)
            sendMessagebtn.setTitle("Message Supplier".localized, for: .normal)
            contactUsBtn.setTitle("Contact Seller".localized, for: .normal)
            if (item.displaySellerInfo ?? true) && item.sellerId != "0" && item.sellerId != "" {
                contactUsBtnHeight.constant = 40
            } else {
                contactUsBtnHeight.constant = 0
            }
        }
    }
    
    @IBAction func tapRequestQuoteBtn(_ sender: Any) {
        
    }
    
    @IBAction func tapQuickOrderBtn(_ sender: Any) {
        
    }
    
    @IBAction func tapSendMessageBtn(_ sender: Any) {
        
    }
    
    @IBAction func tapContactSellerBtn(_ sender: Any) {
        
//        let viewController = SellerContactUsViewController.instantiate(fromAppStoryboard: .marketplace)
//        viewController.sellerId = item?.sellerId
//        self.viewContainingController?.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

enum SellerInfoActionType {
    
    case requestQuote
    case quickOrder
    case sendMessage
   
}
