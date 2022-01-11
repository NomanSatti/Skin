//
/**
Mustalem
@Category Webkul
@author Webkul <support@webkul.com>
FileName: CheckoutNewAddressTableViewCell.swift
Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
@license https://store.webkul.com/license.html ASL Licence
@link https://store.webkul.com/license.html

*/


import UIKit

class CheckoutNewAddressTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newAddressBtn: UIButton!
    @IBOutlet weak var shippingAddressLabel: UILabel!
    var address = [Address]()
    var addressId = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newAddressBtn.setTitle("New Address".localized, for: .normal)
        shippingAddressLabel.text = "Shipping Address".localized
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func newAddressClicked(_ sender: UIButton) {
        let viewController = AppStoryboard.customer.instance.instantiateViewController(withIdentifier: "NewAddressDataViewController") as! NewAddressDataViewController
        if let vc = self.viewContainingController as? CheckoutAddressAndShippingViewController {
            viewController.delegate = vc
        }
        if let index  = self.address.firstIndex(where: {$0.id == self.addressId }) {
            viewController.address = self.address[index].newAddress
        }
        if let vc = self.viewContainingController as? CheckoutOrderReviewViewController {
            viewController.delegate = vc
        }
        viewController.addressType = "Checkout"
        self.viewContainingController?.navigationController?.pushViewController(viewController, animated: true)
    }
}
