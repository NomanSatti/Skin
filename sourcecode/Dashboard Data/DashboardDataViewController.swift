//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: DashboardDataViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class DashboardDataViewController: UIViewController {
    
    var viewModel: DashboardViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    var customView: CustomTableHeaderView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DashboardViewModel()
        viewModel.moveDelegate = self
        self.tableView.register(DasboardAction.nib, forHeaderFooterViewReuseIdentifier: DasboardAction.identifier)
        tableView.register(cellType: OrderListTableViewCell.self)
        self.tableView.register(ActionButtonFooterView.nib, forHeaderFooterViewReuseIdentifier: ActionButtonFooterView.identifier)
        tableView.register(cellType: DashboardAddressTableViewCell.self)
        tableView.register(cellType: DashboardReviewTableViewCell.self)
        self.callRequest()
        
        if let customView = Bundle.main.loadNibNamed("\(CustomTableHeaderView.self)", owner: nil, options: nil)?.first as? CustomTableHeaderView {
            self.customView = customView
            customView.frame = CGRect(x: 0, y: 0, width: AppDimensions.screenWidth, height: AppDimensions.screenWidth*2 / 3)
            customView.frame.size.height = AppDimensions.screenWidth*2 / 3
            customView.nameLabel.text = Defaults.customerName
            if let banner  = Defaults.profileBanner {
                customView.bannerImage.setImage(fromURL: banner)
            }
            if let profilePic = Defaults.profilePicture {
                customView.profileImage.setImage(fromURL: profilePic)
            }
            customView.emailLabel.text = Defaults.customerEmail
            self.tableView.tableHeaderView = customView
        }
        self.tableView.sectionHeaderHeight = AppDimensions.screenWidth*2 / 3
        self.tableView.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        self.tableView.delegate = viewModel
        self.tableView.dataSource = viewModel
    }
    
    func callRequest() {
        viewModel?.networkCalls { [weak self] success in
            guard let self = self else { return }
            if success {
                self.tableView.delegate = self.viewModel
                self.tableView.dataSource = self.viewModel
                self.tableView.reloadData()
                //                self.priceLabel.text = self.cartviewModelObject?.cartModel.grandtotal?.value
            } else {
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.customView?.nameLabel.text = Defaults.customerName
        self.customView?.emailLabel.text = Defaults.customerEmail
        self.navigationController?.navigationBar.transparentNavigation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.transparentNavigation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.makeDefaultNavigation()
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView.tableHeaderView?.frame.size.height = AppDimensions.screenWidth*3 / 4
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

extension DashboardDataViewController: DashboardMoveDelegate {
    
    func moveToAnother(id: String, controller: AllControllers) {
        switch controller {
        case .addressBookListViewController:
            let viewController = AddressBookListViewController.instantiate(fromAppStoryboard: .customer)
            viewController.completionBlock = {
                self.viewModel.apiToCall = .address
                self.viewModel.callingHttppApi { [weak self] jsonData in
                    if let data = AddressBookModel(data: jsonData) {
                        self?.viewModel?.addressDaatArray = data.addressDaatArray
                    }
                    NetworkManager.sharedInstance.dismissLoader()
                    self?.tableView.reloadData()
                }
            }
            self.navigationController?.pushViewController(viewController, animated: true)
            
        case .newAddress:
            let viewController = NewAddressDataViewController.instantiate(fromAppStoryboard: .customer)
            if id != "0" {
                viewController.addressId = id
            } else {
                viewController.isDefaultSave = true
            }
            viewController.completionBlock = {
                self.viewModel.apiToCall = .address
                self.viewModel.callingHttppApi { [weak self] jsonData in
                    if let data = AddressBookModel(data: jsonData) {
                        self?.viewModel?.addressDaatArray = data.addressDaatArray
                    }
                    NetworkManager.sharedInstance.dismissLoader()
                    self?.tableView.reloadData()
                }
            }
            self.navigationController?.pushViewController(viewController, animated: true)
        case .myOrders:
            let orderDetails = OrderListViewController.instantiate(fromAppStoryboard: .customer)
            self.navigationController?.pushViewController(orderDetails, animated: true)
        case .productReviewList:
            let viewController = ProductReviewListViewController.instantiate(fromAppStoryboard: .customer)
            self.navigationController?.pushViewController(viewController, animated: true)
        case .orderDetailsDataViewController:
            let viewController = OrderDetailsDataViewController.instantiate(fromAppStoryboard: .customer)
            viewController.orderId = id
            let nav = UINavigationController(rootViewController: viewController)
            //nav.navigationBar.tintColor = AppStaticColors.accentColor
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        case .orderReview:
            let viewController = OrderReviewListProductViewController.instantiate(fromAppStoryboard: .customer)
            viewController.orderId = id
            viewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(viewController, animated: true, completion: nil)
        case .reviewDetails:
            let viewController = ProductReviewDetailDataViewController.instantiate(fromAppStoryboard: .customer)
            let arr = viewModel.reviewModel.reviewList
            if let index = arr.firstIndex(where: { $0.id == id }) {
                viewController.data = arr[index]
            }
            self.navigationController?.pushViewController(viewController, animated: true)
        case .none:
            let AC = UIAlertController(title: "Reorder".localized, message: "Product(s) has been added to cart".localized, preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "Go to Cart".localized.uppercased(), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                let viewController = CartDataViewController.instantiate(fromAppStoryboard: .product)
                let nav = UINavigationController(rootViewController: viewController)
                //nav.navigationBar.tintColor = AppStaticColors.accentColor
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            })
            let cancelBtn = UIAlertAction(title: "Dismiss".localized.uppercased(), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                
            })
            AC.addAction(okBtn)
            AC.addAction(cancelBtn)
            self.present(AC, animated: true, completion: {})
            //            viewController.data = model.reviewList[indexPath.row]
            
        default:
            break
        }
    }
}
