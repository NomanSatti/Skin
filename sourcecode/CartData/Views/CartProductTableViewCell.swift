import UIKit
import Alamofire
import AlamofireImage


class CartProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var wishlistBtn: UIButton!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var discountPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var productOptions: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var editButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        removeBtn.setTitle("Remove Item".localized, for: .normal)
        wishlistBtn.setTitle("Move to Wishlist".localized, for: .normal)
        
        /*productImage.addTapGestureRecognizer {
            let nextController = ProductPageDataViewController.instantiate(fromAppStoryboard: .product)
            nextController.productId = self.item.productId
            nextController.productName = self.item.name
            self.viewContainingController?.navigationController?.pushViewController(nextController, animated: true)
        }*/
        
        /*productName.addTapGestureRecognizer {
            let nextController = ProductPageDataViewController.instantiate(fromAppStoryboard: .product)
            nextController.productId = self.item.productId
            nextController.productName = self.item.name
            self.viewContainingController?.navigationController?.pushViewController(nextController, animated: true)
        }*/
        
        // Configure the view for the selected state
    }
    @IBAction func wishlistClicked(_ sender: Any) {
    }
    @IBAction func removeClicked(_ sender: Any) {
    }
    @IBAction func editClicked(_ sender: Any) {
        let nextController = ProductPageDataViewController.instantiate(fromAppStoryboard: .product)
        nextController.productId = self.item.productId
        nextController.itemId = self.item.id
        nextController.parentController = "cart"
        nextController.productName = self.item.name
        self.viewContainingController?.navigationController?.pushViewController(nextController, animated: true)
    }
    
    var item: CartProducts! {
        didSet {
            
            if item.sku == "TestCustomUpload" {
                self.productImage.isUserInteractionEnabled = false
                self.editButton.isHidden = true
            }
            
            
            
            if item.sku != "TestCustomUpload" {
                
                
                
                CartImageManager.getProductMedia(sku: item.sku) { (file) in
                    // print(CART_MEDIA_URL + file)
                    
                    if let _ = file {
                        if let url = URL(string: CART_MEDIA_URL + file!){
                            //self.productImage.setImage(fromURL: CART_MEDIA_URL + file, dominantColor: self.item.dominantColor)
                            self.productImage.af_setImage(withURL: url) { (image) in
                                
                            }
                        }
                    }else{
                        self.productImage.setImage(fromURL: self.item.image, dominantColor: self.item.dominantColor)
                    }
                    
                }
            }
            else{
                self.productImage.setImage(fromURL: self.item.image, dominantColor: self.item.dominantColor)
            }
            
            self.productName.text = item.name
            self.productOptions.text = item.optionString
            self.qtyLabel.text = "Qty".localized + ": " + item.qty
            self.priceLabel.text = item.formattedFinalPrice1
            self.messageLabel.text = item.messages
            discountPriceLabel.attributedText = item.strikePrice
            self.subTotalLabel.text = "Subtotal".localized + ": " + item.subTotal
            self.subTotalLabel.halfTextWithColorChange(fullText: self.subTotalLabel.text!, changeText: "Subtotal".localized + ": ", color: AppStaticColors.labelSecondaryColor)
            self.qtyLabel.halfTextWithColorChange(fullText: self.qtyLabel.text!, changeText: "Qty".localized + ": ", color: AppStaticColors.labelSecondaryColor)
        }
    }
    
}
