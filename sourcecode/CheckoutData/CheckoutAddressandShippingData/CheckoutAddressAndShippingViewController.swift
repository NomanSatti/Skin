//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: CheckoutAddressAndShippingViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class CheckoutAddressAndShippingViewController: UIViewController {
    
    @IBOutlet weak var bottomView: UIView!
    var emptyView: EmptyView!
    var viewModel: CheckoutAddressAndShippingViewModel?
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountToBePaid: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var completionBlock: ((_ shippingId: String, _ shippingDict: [String: Any], _ address: [Address]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomView.shadowBorder()
        self.bottomView.isHidden = true
        proceedBtn.setTitle("Proceed".localized, for: .normal)
        amountToBePaid.text = "Amount to be paid".localized
        tableView.register(cellType: ShippingAddressTableViewCell.self)
        tableView.register(cellType: SelectionAddressTableViewCell.self)
        tableView.register(cellType: ShippingMethodTableTableViewCell.self)
        tableView.separatorStyle = .none
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if emptyView == nil {
            emptyView = EmptyView(frame: self.view.bounds)
            self.view.addSubview(emptyView)
            emptyView.isHidden = true
            emptyView.emptyImages.addSubview(LottieHandler.sharedInstance.initializeLottie(bounds: emptyView.emptyImages.bounds, fileName: "AddressFile"))
            //            emptyView.emptyImages.image = UIImage(named: "illustration-address")
            emptyView.actionBtn.setTitle("Add New Address".localized, for: .normal)
            emptyView.labelMessage.text = "You didn’t add any of your addresses yet.".localized
            emptyView.titleText.text = "No Addresses".localized
            //emptyView.frame.origin.x = 16
            emptyView.actionBtn.addTapGestureRecognizer {
                self.emptyClicked()
            }
        }
    }
    
    func emptyClicked() {
        let viewController = NewAddressDataViewController.instantiate(fromAppStoryboard: .customer)
        viewController.delegate = self
        viewController.addressType = "Checkout"
        viewController.automaticSaveAddress = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func hitRequest() {
        viewModel = CheckoutAddressAndShippingViewModel()
        viewModel?.obj = self
        viewModel?.callingHttppApi { [weak self] success in
            guard let self = self else { return }
            if success {
                if let shippingModel =  self.viewModel?.shippingModel {
                    self.bottomView.isHidden = false
                    self.priceLabel.text = shippingModel.cartTotal
                }
                
                self.emptyView?.isHidden = true
                self.tableView.isHidden = false
                self.tableView.delegate = self.viewModel
                self.tableView.dataSource = self.viewModel
                self.tableView.reloadData()
            } else {
                self.bottomView.isHidden = true
                NetworkManager.sharedInstance.dismissLoader()
                if self.viewModel?.apiToCall == .showAdress {
                    self.showEmpty()
                    self.emptyView.isHidden = false
                    LottieHandler.sharedInstance.playLoattieAnimation()
                    self.tableView.isHidden = true
                }
            }
            
        }
    }
    
    func showEmpty() {
        self.emptyView = EmptyView(frame: self.view.bounds)
        self.view.addSubview(self.emptyView)
        emptyView.emptyImages.addSubview(LottieHandler.sharedInstance.initializeLottie(bounds: emptyView.emptyImages.bounds, fileName: "AddressFile"))
        //            emptyView.emptyImages.image = UIImage(named: "illustration-address")
        emptyView.actionBtn.setTitle("Add New Address".localized, for: .normal)
        emptyView.labelMessage.text = "You didn’t add any of your addresses yet.".localized
        emptyView.titleText.text = "No Addresses".localized
        //emptyView.frame.origin.x = 16
        emptyView.actionBtn.addTapGestureRecognizer {
            self.emptyClicked()
        }
    }
    
    @IBAction func proceedClicked(_ sender: Any) {
        if let viewModel = viewModel, viewModel.shippingId.count > 0 {
            guard let completionBlock = self.completionBlock else {return}
            completionBlock(viewModel.shippingId, viewModel.shippingDict, viewModel.addressModel.address)
        } else {
            ShowNotificationMessages.sharedInstance.warningView(message: "Select Shipping Method".localized)
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

extension CheckoutAddressAndShippingViewController: CheckoutSelectAddress {
    func checkoutSelectAddress(address: String) {
        if let viewModel = viewModel, viewModel.addressModel.address.count > 0 {
            if let index = viewModel.addressModel.address.firstIndex(where: { $0.id == address }) {
                viewModel.selectedRow = index
                viewModel.addressId = address
                self.tableView.reloadData()
                viewModel.apiToCall = .showShippingMethod
                viewModel.shippingDict["addressId"] = address
                viewModel.shippingDict["newAddress"] =  viewModel.addressModel.address[viewModel.selectedRow].newAddress
                viewModel.shippingDict["sameAsShipping"] = "1"
                self.tableView.delegate = self.viewModel
                self.tableView.dataSource = self.viewModel
                self.emptyView.isHidden = true
                self.bottomView.isHidden = false
                self.tableView.isHidden = false
                viewModel.callingHttppApi {_ in
                    self.tableView.reloadData()
                }
            } else {
                if address == "yes" {
                    viewModel.apiToCall = .showAdress
                    viewModel.callingHttppApi {_ in
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func newaddress(selectedAdress: [String: Any], addressId: String, formatedAddress: String) {
        
        if let viewModel = viewModel {
            var dict = [String: Any]()
            dict["id"] = addressId
            dict["value"] = formatedAddress
            dict["newAddress"] = selectedAdress
            if let index = viewModel.addressModel.address.firstIndex(where: { $0.id == "0" }) {
                viewModel.addressModel.address.remove(at: index)
            }
            viewModel.addressModel.address.append(Address(json: JSON(dict)))
            if let index = viewModel.addressModel.address.firstIndex(where: { $0.id == addressId }) {
                viewModel.selectedRow = index
                viewModel.addressId = addressId
                self.tableView.reloadData()
            }
            viewModel.shippingDict["addressId"] = addressId
            viewModel.shippingDict["newAddress"] = viewModel.addressModel.address[viewModel.selectedRow].newAddress
            viewModel.shippingDict["sameAsShipping"] = "1"
            self.emptyView.isHidden = true
            self.bottomView.isHidden = false
            self.tableView.isHidden = false
            self.tableView.delegate = self.viewModel
            self.tableView.dataSource = self.viewModel
            viewModel.apiToCall = .showShippingMethod
            viewModel.callingHttppApi {_ in
                self.tableView.reloadData()
            }
        }
    }
}
