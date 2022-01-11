//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: CreateAnAccountViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class CreateAnAccountViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: SaveFooterView!
    var viewModel: CreateAnAccountViewModel!
    var customerDetails: AccountInformationModel!
    var parentController = ""
    var callback: (()->())?
    weak var delegate: LoginPop?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create an Account".localized
        self.prepareSubViews()
        viewModel = CreateAnAccountViewModel()
        viewModel.customerDetails = customerDetails
        viewModel.tableView = tableView
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        viewModel.footerView = footerView
        viewModel.delegate = self
        self.callRequest()
        // Do any additional setup after loading the view.
    }
    private func prepareSubViews() {
        //Prepare tableView
        FormItemCellType.registerCells(for: self.tableView)
        self.tableView.register(cellType: PasswordTableViewCell.self)
        self.tableView.register(cellType: NewsLaterCheckTableViewCell.self)
        
        self.tableView.allowsSelection = false
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
    func callRequest() {
        viewModel?.callingHttppApi { [weak self] success in
            guard let self = self else { return }
            NetworkManager.sharedInstance.dismissLoader()
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                if self.viewModel.saveData {
                    self.dismiss(animated: true, completion: {
                        self.delegate?.loginPop()
                        self.callback?()
                    })
                }
            } else {
                
            }
        }
    }
    
    @IBAction func backAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension CreateAnAccountViewController: moveToControlller {
    func moveController(id: String, name: String, dict: [String: Any], jsonData: JSON, index: Int, controller: AllControllers) {
        if controller == .none {
            if self.viewModel.saveData {
                self.dismiss(animated: true, completion: {
                    self.delegate?.loginPop()
                    self.callback?()
                })
            }
        } else {
            if parentController == "signIn" {
                self.navigationController?.popViewController(animated: true)
            } else {
                let customerLoginVC = SignInViewController.instantiate(fromAppStoryboard: .customer)
                customerLoginVC.parentController = "signUp"
                customerLoginVC.delegate = delegate
                self.navigationController?.pushViewController(customerLoginVC, animated: true)
            }
            
        }
        
    }
    
}
