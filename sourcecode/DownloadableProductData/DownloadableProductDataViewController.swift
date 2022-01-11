//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: DownloadableProductDataViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class DownloadableProductDataViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: DownloadOrderViewModel!
    var emptyView: EmptyView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Downloadable Product".localized
        tableView.register(cellType: DownloadProductListTableViewCell.self)
        viewModel = DownloadOrderViewModel()
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        self.callRequest()
        viewModel.callBackPagination = { [weak self] in
            self?.viewModel.download = false
            self?.callRequest()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if emptyView == nil {
            emptyView = EmptyView(frame: self.view.frame)
            self.view.addSubview(emptyView)
            emptyView.isHidden = true
            emptyView.emptyImages.addSubview(LottieHandler.sharedInstance.initializeLottie(bounds: emptyView.emptyImages.bounds, fileName: "DownloadFile"))
            //            emptyView.emptyImages.image = UIImage(named: "illustration-download")
            emptyView.actionBtn.setTitle("Start Shopping".localized, for: .normal)
            emptyView.labelMessage.text = "You didn’t purchase any downloadable products yet.".localized
            emptyView.titleText.text = "No Items".localized
            emptyView.actionBtn.addTapGestureRecognizer {
                self.emptyClicked()
            }
        }
    }
    
    
    func emptyClicked() {
        self.tabBarController?.selectedIndex = 0
        self.navigationController?.popViewController(animated: true)
    }
    
    func callRequest() {
        viewModel?.callingHttppApi { [weak self] success in
            guard let self = self else { return }
            if success {
                if self.viewModel.model.downloadsList.count > 0 {
                    self.emptyView.isHidden = true
                    self.tableView.isHidden = false
                    self.tableView.delegate = self.viewModel
                    self.tableView.dataSource = self.viewModel
                    self.tableView.reloadData()
                } else {
                    LottieHandler.sharedInstance.playLoattieAnimation()
                    self.emptyView.isHidden = false
                    self.tableView.isHidden = true
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
