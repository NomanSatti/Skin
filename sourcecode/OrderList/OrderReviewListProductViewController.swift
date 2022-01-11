//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: OrderReviewListProductViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class OrderReviewListProductViewController: UIViewController {
    var orderId = ""
    var viewModel: OrderReviewListProductViewModel!
    @IBOutlet weak var heightOfTable: NSLayoutConstraint!
    @IBOutlet weak var productListTable: UITableView!
    
    @IBOutlet weak var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        productListTable.register(cellType: ReviewProductTableViewCell.self)
        viewModel = OrderReviewListProductViewModel()
        viewModel.orderId = orderId
        viewModel.moveDelegate = self
        productListTable.separatorStyle = .none
        view.isOpaque = false
        view.backgroundColor = .clear
        callRequest()
    }
    
    @IBAction func dismissAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func callRequest() {
        viewModel?.callingHttppApi { [weak self] success in
            guard let self = self else { return }
            if success {
                let conditionValue = CGFloat((self.viewModel?.modelProductReviewData?.orderData?.itemList.count ?? 0) * 113) < AppDimensions.screenHeight / 2
                if conditionValue {
                    self.productListTable.isScrollEnabled = false
                    self.heightOfTable.constant = CGFloat(((self.viewModel?.modelProductReviewData?.orderData?.itemList.count)!) * 113) + 60
                } else {
                    self.productListTable.isScrollEnabled = true
                    self.heightOfTable.constant = AppDimensions.screenHeight / 2 + 60
                }
                self.productListTable.delegate = self.viewModel
                self.productListTable.dataSource = self.viewModel
                self.productListTable.reloadData()
            } else {
                
            }
        }
    }
}
extension OrderReviewListProductViewController: moveToControlller {
    func moveController(id: String, name: String, dict: [String: Any], jsonData: JSON, index: Int, controller: AllControllers) {
        let viewController = AddReviewDataViewController.instantiate(fromAppStoryboard: .customer)
        viewController.id = id
        viewController.name = name
        viewController.imageUrl = dict["image"]as? String ?? ""
        let nav = UINavigationController(rootViewController: viewController)
        //nav.navigationBar.tintColor = AppStaticColors.accentColor
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}
