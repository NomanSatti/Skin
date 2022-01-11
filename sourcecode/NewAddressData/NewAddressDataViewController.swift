//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: NewAddressDataViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class NewAddressDataViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var viewModel: NewAddressViewModel!
    weak var delegate: CheckoutSelectAddress?
    var addressType = ""
    var addressId = ""
    var address = [String: Any]()
    var completionBlock: (() -> Void)?
    var isDefaultSave = false
    var automaticSaveAddress = false
    var oldTableViewHeight = AppDimensions.screenWidth - 136
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if addressId.count > 0 {
            self.navigationItem.title = "Edit Address".localized
            
        } else {
            self.navigationItem.title = "Add New Address".localized
        }
        
        saveBtn.setTitle("Save Address".localized.uppercased(), for: .normal)
        self.prepareSubViews()
        viewModel = NewAddressViewModel()
        viewModel.moveDelegate = self
        viewModel.isDefaultSave = isDefaultSave
        viewModel.automaticSaveAddress = automaticSaveAddress
        viewModel.addressDictionary = address
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        viewModel.addressType = addressType
        viewModel.addressId = addressId
        self.callRequest()
        // Do any additional setup after loading the view.
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        oldTableViewHeight = tableViewHeight.constant
//        tableViewHeight.constant = AppDimensions.screenHeight * 4
//        self.tableView.reloadData()
//    }
    
    private func prepareSubViews() {
        //Prepare tableView
        FormItemCellType.registerCells(for: self.tableView)
        self.tableView.allowsSelection = false
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
    
    func callRequest() {
        viewModel?.callingHttppApi { [weak self] success in
            guard let self = self else { return }
            if success {
                self.tableView.reloadData()
                //                self.priceLabel.text = self.cartViewModalObject?.cartModel.grandtotal?.value
//                self.tableViewHeight.constant = self.oldTableViewHeight
            } else {
                
            }
        }
    }
    @IBAction func saveAddressClicked(_ sender: Any) {
        viewModel?.saveAddressClicked { success in
            if let completionBlock = self.completionBlock {
                completionBlock()
            }
            
            if success && (self.addressId == "0" || self.addressId == "" )  {
                if let dict = self.viewModel?.addressDictionary, self.addressType == "Checkout" {
                    var formatAddress = ""
                    if let firstname = dict[NewAddressModel.SerializationKeys.firstName] as? String {
                        formatAddress += firstname
                    }
                    
                    if let lastname = dict[ NewAddressModel.SerializationKeys.lastName] as? String {
                        formatAddress += " " + lastname + " ,"
                    }
                    
                    if let street = dict["street"] as? [String] {
                        formatAddress += street.joined(separator: ", ")
                    }
                    
                    if let city = dict["city"] as? String {
                        formatAddress += city + " ,"
                    }
                    
                    if let countryid = dict["country_id"] as? String,
                        self.viewModel.dataModel.countryData.count > 0,
                        let index = self.viewModel.dataModel.countryData.firstIndex(where: { $0.countryId == countryid }) {
                        formatAddress += self.viewModel.dataModel.countryData[index].name + " ,"
                        
                        if let regionid = dict["region_id"] as? String, regionid.count >= 1, regionid != "", regionid != "0", let index1 = self.viewModel.dataModel.countryData[index].states.firstIndex(where: { $0.regionId == regionid }) {
                            formatAddress += self.viewModel.dataModel.countryData[index].states[index1].name + " ,"
                        }
                        
                    }
                    
                    if let postcode = dict["postcode"] as? String {
                        formatAddress += postcode
                    }
                    self.delegate?.newaddress(selectedAdress: dict, addressId: "0", formatedAddress: formatAddress)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
            if success && self.addressId != "0" && self.addressId.count > 0 {
                self.delegate?.checkoutSelectAddress(address: "yes")
                self.navigationController?.popViewController(animated: true)
            }
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

extension NewAddressDataViewController: MoveController {
    func moveController(id: String, name: String, dict: [String : Any], jsonData: JSON, type: String, controller: AllControllers) {
        let AC = UIAlertController(title: "Signin".localized , message: "You already have an account with us.Sign in or continue as guest".localized, preferredStyle: .alert)
        
        let cancelBtn = UIAlertAction(title: "Continue".localized, style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
            
        })
        AC.addAction(cancelBtn)
        let okBtn = UIAlertAction(title: "Ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            let customerLoginVC = SignInViewController.instantiate(fromAppStoryboard: .customer)
            customerLoginVC.email = name
            customerLoginVC.delegate = self
            let nav = UINavigationController(rootViewController: customerLoginVC)
            //nav.navigationBar.tintColor = AppStaticColors.accentColor
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        })
        AC.addAction(okBtn)
        self.present(AC, animated: true, completion: {  })
    }
}
extension NewAddressDataViewController: LoginPop {
    func loginPop() {
        self.dismiss(animated: true, completion: nil)
    }
}
