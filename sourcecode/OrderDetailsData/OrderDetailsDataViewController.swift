//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: OrderDetailsDataViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class OrderDetailsDataViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var orderId: String!
    var viewModel: OrderDetailsViewModal!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = OrderDetailsViewModal(orderId: orderId)
        viewModel.controller = self
        tableView.register(cellType: OrderHeadingTableViewCell.self)
        tableView.register(cellType: OrderDetailProductTableViewCell.self)
        tableView.register(cellType: CartPriceTableViewCell.self)
        tableView.register(cellType: OrderDetailsExtraTableViewCell.self)
        tableView.register(cellType: OrderTrackTableViewCell.self)
        tableView.register(cellType: ReorderTableViewCell.self)
        tableView.register(cellType: DeliveryboyRatingTableViewCell.self)
        tableView.register(ProductSectionHeading.nib, forHeaderFooterViewReuseIdentifier: ProductSectionHeading.identifier)
        tableView.register(OrderDetailsHeaderView.nib, forHeaderFooterViewReuseIdentifier: OrderDetailsHeaderView.identifier)
        tableView.register(cellType: OrderDetailInvoiceTableViewCell.self)
        
        viewModel.reloadSections = { [weak self] (section: Int) in
            self?.tableView?.beginUpdates()
            self?.tableView?.reloadSections([section], with: .fade)
            self?.tableView?.endUpdates()
        }
        
        viewModel.navigateAdminChatDelivery = { [weak self] (success: Bool) in
            if success {
                let vc = CustomerAdminChatViewController.instantiate(fromAppStoryboard: .customer)
                vc.otherUserId = "deliveryAdmin"
                vc.otherUserName = "Admin"
                vc.accountType = "customer"
                vc.childIdKey = Defaults.customerToken!
                vc.senderId = Defaults.customerToken
                vc.senderDisplayName = Defaults.customerName
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        viewModel.navigateToMap = { [weak self] (lat: String, long: String) in
            let vc = PinLocationController.instantiate(fromAppStoryboard: .customer)
            vc.deliveryBoyLatLong = (lat: lat, long: long)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        tableView.tableFooterView = UIView()
        //self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "sharp-cross")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(backPress))
        self.navigationItem.leftBarButtonItem?.tintColor = AppStaticColors.itemTintColor
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
            } else {
                
            }
        }
    }
}
