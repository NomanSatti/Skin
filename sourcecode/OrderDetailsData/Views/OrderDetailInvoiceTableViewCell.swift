//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: OrderDetailInvoiceTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class OrderDetailInvoiceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var saveInvoiceBtn: UIButton!
    @IBOutlet weak var viewInvouceBtn: UIButton!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var invoiceLabel: UILabel!
    var incrementId: String!
    var shipmentId: String!
    override func awakeFromNib() {
        super.awakeFromNib()
        invoiceLabel.text = "Invoice".localized
        viewInvouceBtn.setTitle("View Invoice".localized, for: .normal)
        saveInvoiceBtn.setTitle("Save Invoice".localized, for: .normal)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func arrBtn(_ sender: Any) {
        self.inv()
    }
    @IBAction func saveInvoiceClicked(_ sender: Any) {
    }
    @IBAction func viewInvoiceClicked(_ sender: Any) {
        if let shipmentId = shipmentId, shipmentId.count > 0 {
            let viewController = ShipmentDetailViewController.instantiate(fromAppStoryboard: .customer)
            viewController.shippmentId = shipmentId
            let nav = UINavigationController(rootViewController: viewController)
            //nav.navigationBar.tintColor = AppStaticColors.accentColor
            nav.modalPresentationStyle = .fullScreen
            self.viewContainingController?.present(nav, animated: true, completion: nil)
        } else {
            self.inv()
        }
        
    }
    
    func inv() {
        let viewController = InvoiceDetailViewController.instantiate(fromAppStoryboard: .customer)
        viewController.invoiceId = incrementId
        let nav = UINavigationController(rootViewController: viewController)
        //nav.navigationBar.tintColor = AppStaticColors.accentColor
        nav.modalPresentationStyle = .fullScreen
        self.viewContainingController?.present(nav, animated: true, completion: nil)
    }
    
    //    InvoiceDetailViewController
}
