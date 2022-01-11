//
//  ShippingAddressTableViewCell.swift
//  MobikulMPMagento2
//
//  Created by bhavuk.chawla on 10/12/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class ShippingAddressTableViewCell: UITableViewCell {
    
    @IBOutlet weak var arrowLabel: UIImageView!
    @IBOutlet weak var newAddressBtn: UIButton!
    @IBOutlet weak var changeAddressBtn: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var shippingAddressLabel: UILabel!
    var address = [Address]()
    var addressId = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        changeAddressBtn.setTitle("  Change Address".localized, for: .normal)
        newAddressBtn.setTitle("  New Address".localized, for: .normal)
        shippingAddressLabel.text = "Shipping Address".localized
        arrowLabel.addTapGestureRecognizer {
            if self.addressId !=  "0" {
                let viewController = NewAddressDataViewController.instantiate(fromAppStoryboard: .customer)
                viewController.addressId = self.addressId
                if let vc = self.viewContainingController as? CheckoutAddressAndShippingViewController {
                    viewController.delegate = vc
                    self.viewContainingController?.navigationController?.pushViewController(viewController, animated: true)
                }
                
            }
        }
        addressLabel.addTapGestureRecognizer {
            if self.addressId !=  "0" {
                let viewController = NewAddressDataViewController.instantiate(fromAppStoryboard: .customer)
                viewController.addressId = self.addressId
                if let vc = self.viewContainingController as? CheckoutAddressAndShippingViewController {
                    viewController.delegate = vc
                    self.viewContainingController?.navigationController?.pushViewController(viewController, animated: true)
                }
                
            }
        }
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func newAddressClicked(_ sender: UIButton) {
        let viewController = NewAddressDataViewController.instantiate(fromAppStoryboard: .customer)
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
    
    @IBAction func changeAddressClicked(_ sender: UIButton) {
        let viewController = CheckoutAddressListViewController.instantiate(fromAppStoryboard: .checkout)
        viewController.address = address
        viewController.addressId = addressId
        if let vc = self.viewContainingController as? CheckoutAddressAndShippingViewController {
            viewController.delegate = vc
        }
        if let vc = self.viewContainingController as? CheckoutOrderReviewViewController {
            viewController.delegate = vc
        }
        
        self.viewContainingController?.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}

protocol CheckoutSelectAddress: NSObjectProtocol {
    func checkoutSelectAddress(address: String)
    func newaddress(selectedAdress: [String: Any], addressId: String, formatedAddress: String)
}
