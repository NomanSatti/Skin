//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: AccountInformationViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class AccountInformationViewController: UIViewController {
    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var viewModel: AccountInformationViewModal!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Account Information".localized
        viewModel = AccountInformationViewModal()
        viewModel.tableView = tableView
        btn.setTitle("Save".localized.uppercased(), for: .normal)
        self.prepareSubViews()
        self.callRequest()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    @IBAction func btnClicked(_ sender: Any) {
        viewModel?.saveAddressClicked { _ in
            self.navigationController?.popViewController(animated: true)
        }
    }
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
