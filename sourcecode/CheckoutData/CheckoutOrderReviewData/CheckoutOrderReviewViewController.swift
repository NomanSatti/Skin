//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: CheckoutOrderReviewViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class CheckoutOrderReviewViewController: UIViewController {
    
    var shippingId: String = ""
    var viewModel: CheckoutOrderReviewViewModel!
    var isVirtual: Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountToBePaid: UILabel!
    var completionBlock: ((_ payement: PaymentMethods,_ billingDiff: Bool,_ billingDict: [String: Any]) -> Void)?
    var address = [Address]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomView.shadowBorder()
        tableView.register(cellType: CheckoutNewAddressTableViewCell.self)
        tableView.register(cellType: SelectionAddressTableViewCell.self)
        tableView.register(cellType: OrderReviewShippingTableViewCell.self)
        tableView.register(cellType: OrderReviewProductsTableViewCell.self)
        tableView.register(cellType: PaymentMethodTableViewCell.self)
        tableView.register(cellType: ShippingAddressTableViewCell.self)
        tableView.register(cellType: CartVoucherTableViewCell.self)
        tableView.register(cellType: CartPriceTableViewCell.self)
        self.bottomView.isHidden = true
        tableView.separatorStyle = .none
        proceedBtn.setTitle("Proceed".localized, for: .normal)
        amountToBePaid.text = "Amount to be paid".localized
        viewModel = CheckoutOrderReviewViewModel()
        viewModel.isVirtual = isVirtual
        viewModel.tableView = tableView
        // Do any additional setup after loading the view.
    }
    
    func callRequest() {
        if viewModel == nil {
            viewModel = CheckoutOrderReviewViewModel()
        }
        if isVirtual {
            viewModel.apicall = "isVirtual"
        }
        viewModel.shippingMethod = shippingId
        viewModel.address = address
        viewModel?.callingHttppApi { [weak self] success in
            guard let self = self else { return }
            if success {
                self.bottomView.isHidden = false
                self.priceLabel.text = self.viewModel.model.cartTotal
                self.tableView.delegate = self.viewModel
                self.tableView.dataSource = self.viewModel
                self.tableView.reloadData()
            } else {
                
            }
        }
    }
    
    @IBAction func proceedClicked(_ sender: Any) {
        if viewModel.address.count > 0 {
            if let viewModel = viewModel, let paymentMethod = viewModel.paymentMethod, paymentMethod.code.count > 0 {
                guard let completionBlock = self.completionBlock else {return}
                var billingDict = [String: Any]()
                if self.viewModel.billingAvailable || isVirtual {
                    billingDict["addressId"] = self.viewModel.addressId
                    billingDict["newAddress"] = self.viewModel.address[self.viewModel.selectedRow].newAddress
                    billingDict["sameAsShipping"] = "0"
                }
                completionBlock(paymentMethod, self.viewModel.billingAvailable || isVirtual, billingDict)
            } else {
                ShowNotificationMessages.sharedInstance.warningView(message: "Select Payment Method".localized)
            }
        } else {
            ShowNotificationMessages.sharedInstance.warningView(message: "Please add an Address".localized)
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension CheckoutOrderReviewViewController: CheckoutSelectAddress {
    func checkoutSelectAddress(address: String) {
        if let viewModel = viewModel, viewModel.address.count > 0 {
            if let index = viewModel.address.firstIndex(where: { $0.id == address }) {
                viewModel.selectedRow = index
                viewModel.addressId = address
                self.tableView.reloadData()
            }
        }
    }
    
    func newaddress(selectedAdress: [String: Any], addressId: String, formatedAddress: String) {
        
        if let viewModel = viewModel {
            var dict = [String: Any]()
            dict["id"] = addressId
            dict["value"] = formatedAddress
            dict["newAddress"] = selectedAdress
            if let index = viewModel.address.firstIndex(where: { $0.id == "0" }) {
                viewModel.address.remove(at: index)
            }
            viewModel.address.append(Address(json: JSON(dict)))
            if let index = viewModel.address.firstIndex(where: { $0.id == addressId }) {
                viewModel.selectedRow = index
                viewModel.addressId = addressId
                self.tableView.reloadData()
            }
            self.tableView.reloadData()
        }
    }
}
