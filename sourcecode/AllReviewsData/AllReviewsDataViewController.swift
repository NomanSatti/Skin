//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: AllReviewsDataViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class AllReviewsDataViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var viewModel: AllReviewsViewModel!
    var productId: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "All Reviews".localized
        viewModel = AllReviewsViewModel(productId: productId)
        tableView.register(cellType: ProductReviewDataTableViewCell.self)
        tableView.tableFooterView = UIView()
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
