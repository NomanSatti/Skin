//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: OrderDetailProductTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class OrderDetailProductTableViewCell: UITableViewCell {
    @IBOutlet weak var writeAReviewBtn: UIButton!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var subtotal: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var qty1: UILabel!
    @IBOutlet weak var qty2: UILabel!
    @IBOutlet weak var qty4: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var qty3: UILabel!
    @IBOutlet weak var valuesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if Defaults.language == "ar" {
            writeAReviewBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        }
        writeAReviewBtn.setTitle("Write a Review".localized.uppercased(), for: .normal)
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func writeAReviewClicked(_ sender: Any) {
        let viewController = AddReviewDataViewController.instantiate(fromAppStoryboard: .customer)
        viewController.id = item.id
        viewController.name = item.name
        viewController.imageUrl = item.image
        let nav = UINavigationController(rootViewController: viewController)
        //nav.navigationBar.tintColor = AppStaticColors.accentColor
        nav.modalPresentationStyle = .fullScreen
        self.viewContainingController?.present(nav, animated: true, completion: nil)
    }
    
    var item: CartProducts! {
        didSet {
            valuesLabel.text = ""
            productImage.setImage(fromURL: item.image, dominantColor: item.dominantColor)
            nameLabel.text = item.name
            subtotal.text = "Subtotal".localized + " - " + item.subTotal
            priceLabel.text = "Price".localized + " - " + item.formattedFinalPrice
            qty1.text = "Qty".localized + " - " + item.qties.ordered
            self.qty1.halfTextWithColorChange(fullText: self.qty1.text!, changeText: "Qty".localized + " - ", color: AppStaticColors.labelSecondaryColor)
            
            if let qty2 = qty2, let shipped = item.qties.shipped, shipped != "0" {
                qty2.isHidden = false
                qty2.text = "Qty Shipped".localized + " - " + shipped
                self.qty2.halfTextWithColorChange(fullText: self.qty2.text!, changeText: "Qty Shipped".localized + " - ", color: AppStaticColors.labelSecondaryColor)
            } else {
                qty2.isHidden = true
            }
            
            if let qty3 = qty3, let refunded = item.qties.refunded, refunded != "0" {
                qty3.isHidden = false
                qty3.text = "Qty Refunded".localized + " - " + refunded
                self.qty3.halfTextWithColorChange(fullText: self.qty3.text!, changeText: "Qty Refunded".localized + " - ", color: AppStaticColors.labelSecondaryColor)
            } else {
                qty3.isHidden = true
            }
            
            if let qty4 = qty4, let canceled = item.qties.canceled, canceled != "0" {
                qty4.isHidden = false
                qty4.text = "Qty Canceled".localized + " - " + canceled
                self.qty4.halfTextWithColorChange(fullText: self.qty4.text!, changeText: "Qty Canceled".localized + " - ", color: AppStaticColors.labelSecondaryColor)
            } else {
                qty4.isHidden = true
            }
            
            self.priceLabel.halfTextWithColorChange(fullText: self.priceLabel.text!, changeText: "Price".localized + " - ", color: AppStaticColors.labelSecondaryColor)
            self.subtotal.halfTextWithColorChange(fullText: self.subtotal.text!, changeText: "Subtotal".localized + " - ", color: AppStaticColors.labelSecondaryColor)
        }
    }
    
    override func layoutSubviews() {
        self.qty1.halfTextWithColorChange(fullText: self.qty1.text!, changeText: "Qty".localized + ": ", color: AppStaticColors.labelSecondaryColor)
        if let qty2 = qty2, let shipped = item.qties.shipped, shipped != "0" {
            qty2.text = "Qty Shipped".localized + " - " + shipped
            self.qty2.halfTextWithColorChange(fullText: self.qty2.text!, changeText: "Qty Shipped".localized + " - ", color: AppStaticColors.labelSecondaryColor)
        }
        
        if let qty3 = qty3, let refunded = item.qties.refunded, refunded != "0" {
            qty3.text = "Qty Refunded".localized + " - " + refunded
            self.qty3.halfTextWithColorChange(fullText: self.qty3.text!, changeText: "Qty Refunded".localized + " - ", color: AppStaticColors.labelSecondaryColor)
        }
        
        if let qty4 = qty4, let canceled = item.qties.canceled, canceled != "0" {
            qty4.text = "Qty Canceled".localized + " - " + canceled
            self.qty4.halfTextWithColorChange(fullText: self.qty4.text!, changeText: "Qty Canceled".localized + " - ", color: AppStaticColors.labelSecondaryColor)
        }
        self.priceLabel.halfTextWithColorChange(fullText: self.priceLabel.text!, changeText: "Price".localized + " - ", color: AppStaticColors.labelSecondaryColor)
        self.subtotal.halfTextWithColorChange(fullText: self.subtotal.text!, changeText: "Subtotal".localized + " - ", color: AppStaticColors.labelSecondaryColor)
    }
}
