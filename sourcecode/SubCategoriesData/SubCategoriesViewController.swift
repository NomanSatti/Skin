//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: SubCategoriesViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class SubCategoriesViewController: UIViewController {
    
    var categoryId: String!
    var categoryName: String!
    var viewModel: SubCategoriesViewModal!
    @IBOutlet weak var tablView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SubCategoriesViewModal(categoryId: categoryId, categoryName: categoryName)
        viewModel.delegate = self
        self.navigationItem.title = categoryName
        tablView.register(cellType: HomeBannerTableViewCell.self)
        tablView.register(cellType: RelatedProductTableViewCell.self)
        tablView.tableFooterView = UIView()
        self.callRequest()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func callRequest() {
        viewModel?.callingHttppApi { [weak self] success in
            guard let self = self else { return }
            if success {
                self.tablView.delegate = self.viewModel
                self.tablView.dataSource = self.viewModel
                self.tablView.reloadData()
                self.tablView.layoutIfNeeded()
                if let customView = Bundle.main.loadNibNamed("\(TableBottomView.self)", owner: nil, options: nil)?.first as? TableBottomView , self.tablView.contentSize.height > AppDimensions.screenHeight - 100 {
                    customView.frame = CGRect(x: 0, y: 0, width: AppDimensions.screenWidth, height: 100)
                    customView.mainView.addTapGestureRecognizer {
                        self.tablView.setContentOffset(.zero, animated: true)
                    }
                    self.tablView.tableFooterView = customView
                    self.tablView.reloadData()
                }
                
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

extension SubCategoriesViewController: SubCategoryDelegate {
    func moveToCategory(id: String, name: String, hasChildren: Bool) {
        if hasChildren {
            let viewController = SubCategoriesViewController.instantiate(fromAppStoryboard: .product)
            viewController.categoryId = id
            viewController.categoryName = name
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            let nextController = CategoryProductsViewController.instantiate(fromAppStoryboard: .product)
            nextController.categoryId = id
            nextController.titleName = name
            nextController.categoryType = ""
            //            nextController.categories = self.homeViewModel.categories
            self.navigationController?.pushViewController(nextController, animated: true)
        }
    }
}
