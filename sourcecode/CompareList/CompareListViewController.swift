//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: CompareListViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class CompareListViewController: UIViewController {
    
    @IBOutlet weak var compareTblView: UITableView!
    var compareListViewModel = CompareListViewModel()
    var emptyView: EmptyView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "compare".localized
        compareListViewModel.obj = self
        compareTblView.register(CompareCollectionTableViewCell.nib, forCellReuseIdentifier: CompareCollectionTableViewCell.identifier)
        compareListViewModel.delegate = self
        compareTblView.rowHeight = UITableView.automaticDimension
        compareTblView.estimatedRowHeight = 200.0
        compareTblView.delegate = compareListViewModel
        compareTblView.dataSource = compareListViewModel
        
        //call API to get compare list data
        hitRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if emptyView == nil {
            emptyView = EmptyView(frame: self.view.frame)
            self.view.addSubview(emptyView)
            emptyView.isHidden = true
            emptyView.emptyImages.addSubview(LottieHandler.sharedInstance.initializeLottie(bounds: emptyView.emptyImages.bounds, fileName: "CompareFile"))
            emptyView.actionBtn.setTitle("Start Shopping".localized, for: .normal)
            emptyView.labelMessage.text = "You didn’t add any items to this list yet.".localized
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
    
    func addCutomBtn() {
        let removeBtn = UIButton(type: .custom)
        removeBtn.frame = CGRect(x: 0, y: 0, width: 96, height: 30)
        removeBtn.backgroundColor = UIColor().hexToColor(hexString: "f5f5f5", alpha: 1.0)
        removeBtn.setTitleColor(UIColor().hexToColor(hexString: "000000", alpha: 1.0), for: .normal)
        removeBtn.setTitle("Remove All".localized, for: .normal)
        removeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        
        removeBtn.addTarget(self, action: #selector(removeBtnClicked(_:)), for: .touchUpInside)
        let item = UIBarButtonItem(customView: removeBtn)
        
        self.navigationItem.setRightBarButton(item, animated: false)
    }
    
    @IBAction func removeBtnClicked(_ sender: UIButton) {
        let AC = UIAlertController(title: "Remove All".localized, message: "doyouwanttoremovealltheproductfromcomparelist".localized, preferredStyle: .alert)
        let yesBtn = UIAlertAction(title: "Yes".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.compareListViewModel.compareListDataModel.attributeValueList?.removeAll()
            self.compareListViewModel.compareListDataModel.productList.removeAll()
            self.compareTblView.reloadData()
        })
        let noBtn = UIAlertAction(title: "No".localized, style: .cancel, handler: nil)
        
        AC.addAction(yesBtn)
        AC.addAction(noBtn)
        self.present(AC, animated: true, completion: {})
    }
    
    func hitRequest() {
        compareListViewModel = CompareListViewModel()
        compareListViewModel.obj = self
        compareListViewModel.delegate = self
        compareListViewModel.callingHttppApi { success,jsonResponse in
            if self.compareListViewModel.compareListDataModel.productList.count > 0 {
                self.emptyView.isHidden = true
                self.compareTblView.isHidden = false
                self.compareTblView.delegate = self.compareListViewModel
                self.compareTblView.dataSource = self.compareListViewModel
                self.compareTblView.reloadData()
            } else {
                self.compareTblView.reloadData()
                self.emptyView.isHidden = false
                self.compareTblView.isHidden = true
                LottieHandler.sharedInstance.playLoattieAnimation()
            }
        }
    }
}

// MARK: - Custom delegates
extension CompareListViewController: MoveController {
    func moveController(id: String, name: String, dict: [String: Any], jsonData: JSON, type: String, controller: AllControllers) {
        if controller == .reloadTableView {
            compareTblView.reloadData()
        } else if controller == .productPage {
            _ = dict["name"] as? String
            _ = dict["entityId"] as? String
            _ = dict["thumbNail"] as? String
            let nextController = ProductPageDataViewController.instantiate(fromAppStoryboard: .product)
            nextController.productId = dict["entityId"] as? String ?? id
            nextController.productName = dict["name"] as? String
            self.navigationController?.pushViewController(nextController, animated: true)
            //move to product detail
            //product detail page is not created
        }
    }
}
