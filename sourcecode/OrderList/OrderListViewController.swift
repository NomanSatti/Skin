//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: OrderListViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class OrderListViewController: UIViewController {
    
    //@IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var orderListTable: UITableView!
    var emptyView: EmptyView!
    
    var viewModel: OrderListViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //backBtn.image = backBtn.image?.flipImage()
        orderListTable.register(cellType: OrderListTableViewCell.self)
        viewModel = OrderListViewModel()
        viewModel.delegate = self
        viewModel.orderListTable = self.orderListTable
        viewModel.reOrderDelegate = self
        viewModel.moveDelegate = self
        orderListTable.separatorStyle = .none
        self.navigationItem.title = "My Orders".localized
        callRequest(apiType: ApiTypeForOrderList.details)
    }
    
    func callRequest(apiType: ApiTypeForOrderList) {
        viewModel?.callingHttppApi(apiType: apiType) { [weak self] success in
            guard let self = self else { return }
            if success {
                switch apiType {
                case .details:
                    
                    if self.viewModel.orderListData.count > 0 {
                        self.emptyView.isHidden = true
                        self.orderListTable.isHidden = false
                        self.orderListTable.delegate = self.viewModel
                        self.orderListTable.dataSource = self.viewModel
                        self.orderListTable.reloadData()
                    } else {
                        self.emptyView.isHidden = false
                        self.orderListTable.isHidden = true
                        LottieHandler.sharedInstance.playLoattieAnimation()
                    }
                    
                    
                default:
                    print("")
                }
            } else {
                
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if emptyView == nil {
            emptyView = EmptyView(frame: self.view.frame)
            self.view.addSubview(emptyView)
            emptyView.isHidden = true
            //            emptyView.emptyImages.image = UIImage(named: "illustration-box")
            emptyView.emptyImages.addSubview(LottieHandler.sharedInstance.initializeLottie(bounds: emptyView.emptyImages.bounds, fileName: "OrderFile"))
            emptyView.actionBtn.setTitle("Start Shopping".localized, for: .normal)
            emptyView.labelMessage.text = "You have not placed ay order with us yet.".localized
            emptyView.titleText.text = "No Orders".localized
            emptyView.actionBtn.addTapGestureRecognizer {
                self.emptyClicked()
            }
        }
    }
    
    
    func emptyClicked() {
        self.tabBarController?.selectedIndex = 0
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}

extension OrderListViewController: Pagination, moveToControlller, ReOrder {
    func reOrderAct() {
        callRequest(apiType: ApiTypeForOrderList.reOrder)
    }
    
    func moveController(id: String, name: String, dict: [String: Any], jsonData: JSON, index: Int, controller: AllControllers) {
        if controller == .orderDetailsDataViewController {
            let viewController = OrderDetailsDataViewController.instantiate(fromAppStoryboard: .customer)
            viewController.orderId = id
            let nav = UINavigationController(rootViewController: viewController)
            //nav.navigationBar.tintColor = AppStaticColors.accentColor
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        } else if controller == .reOrder {
            self.tabBarController!.tabBar.items?[3].badgeValue = jsonData["cartCount"].stringValue
            let AC = UIAlertController(title: id, message: jsonData["message"].stringValue, preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                self.tabBarController?.selectedIndex =  3
            })
            AC.addAction(okBtn)
            self.present(AC, animated: true, completion: {})
        } else if controller == .orderReview {
            let viewController = OrderReviewListProductViewController.instantiate(fromAppStoryboard: .customer)
            viewController.orderId = id
            viewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(viewController, animated: true, completion: nil)
        } else {
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
        }
    }
    func pagination() {
        callRequest(apiType: ApiTypeForOrderList.details)
    }
}
