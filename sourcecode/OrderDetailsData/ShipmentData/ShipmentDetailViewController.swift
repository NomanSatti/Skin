//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: ShipmentDetailViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class ShipmentDetailViewController: UIViewController {
    var viewModel: ShippmentViewModel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var trackBtn: UIButton!
    var shippmentId: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.trackBtn.setTitle("Track Shipment".localized, for: .normal)
        self.navigationItem.title = "Shipment".localized + " - #" + shippmentId
        tableView.register(cellType: InvoiceProductListTableViewCell.self)
        tableView.register(cellType: ShipmentDetailTableViewCell.self)
        tableView.register(ProductSectionHeading.nib, forHeaderFooterViewReuseIdentifier: ProductSectionHeading.identifier)
        viewModel = ShippmentViewModel(shippmentId: shippmentId)
        tableView.tableFooterView = UIView()
        //        tableView.separatorStyle = .none
        self.callRequest()
        // Do any additional setup after loading the view.
    }
    
    func callRequest() {
        viewModel?.callingHttppApi { [weak self] success in
            guard let self = self else { return }
            if success {
                self.tableView.delegate = self.viewModel
                self.tableView.dataSource = self.viewModel
                self.tableView.reloadData()
                //                self.priceLabel.text = self.cartViewModalObject?.cartModel.grandtotal?.value
            } else {
            }
        }
    }
    
    @IBAction func crossClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func trackClicked(_ sender: Any) {
        if viewModel.model.trackingData.count > 0 {
            let viewController = TrackingDataViewController.instantiate(fromAppStoryboard: .customer)
            viewController.trackingData = viewModel.model.trackingData
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            ShowNotificationMessages.sharedInstance.warningView(message: "No data found".localized)
        }
        
    }
}
