//
//  SearchTerms.swift
//  DummySwift
//
//  Created by Webkul on 28/12/16.
//  Copyright © 2016 Webkul. All rights reserved.
//

import UIKit

class SearchTerms: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableViewCell: UITableView!
    
    var searchTermsArray = NSArray()
    var searchTermDict: NSDictionary!
    let defaults = UserDefaults.standard
    var searchtermsViewModel: SearchTermViewModel!
    var categoryType = "search"
    var categoryName = "searchresult".localized
    var categoryId = ""
    var searchQuery = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "searchterms".localized
        
        self.navigationController?.isNavigationBarHidden = false
        tableViewCell.isHidden = true
        NetworkManager.sharedInstance.removePreviousNetworkCall()
        NetworkManager.sharedInstance.dismissLoader()
        callingHttppApi()
    }
    
    func callingHttppApi() {
        var requstParams = [String: Any]()
        NetworkManager.sharedInstance.showLoader()
        requstParams["storeId"] = defaults.object(forKey: "storeId") as? String ?? ""
        requstParams["eTag"] = DBManager.sharedInstance.geteTagFromDataBase(hashKey: self.getSearchTermsHashKey())
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .get, apiname: .searchTermList, currentView: self) {success, responseObject in
            if success == 1 {
                self.view.isUserInteractionEnabled = true
                
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                if jsonResponse["success"].boolValue == true {
                    if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]) {
                        DBManager.sharedInstance.storeDataToDataBase(data: data, eTag: jsonResponse["eTag"].stringValue, hashKey: self.getSearchTermsHashKey())
                    }
                    
                    self.searchtermsViewModel = SearchTermViewModel(data: jsonResponse)
                    self.doFurtherProcessingWithResult()
                } else {
                    if jsonResponse["message"].stringValue.removeWhiteSpace.count > 0 {
                        ShowNotificationMessages.sharedInstance.warningView(message: jsonResponse["message"].stringValue)
                    } else {
                        ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
                    }
                }
            } else if success == 2 {   // Retry in case of error
                NetworkManager.sharedInstance.dismissLoader()
                self.callingHttppApi()
            } else if success == 3 {   // No Changes
                let jsonResponse =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: self.getSearchTermsHashKey())
                self.searchtermsViewModel = SearchTermViewModel(data: jsonResponse)
                self.doFurtherProcessingWithResult()
                
            }
        }
        
    }
    
    func getSearchTermsHashKey() -> String {
        var valuesForHashkeys = [String]()
        valuesForHashkeys.append(Defaults.storeId)
        valuesForHashkeys.append(Defaults.quoteId)
        valuesForHashkeys.append(Defaults.customerToken ?? "")
        valuesForHashkeys.append(Defaults.currency ?? "")
        valuesForHashkeys.append(self.categoryType)
        valuesForHashkeys.append(self.categoryId)
        return NetworkManager.sharedInstance.getHashKey(forView: "searchTerms", keys: valuesForHashkeys)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        if self.isMovingToParentViewController{
        //            print("4nd pushed")
        //        }else{
        //            print("clear the previous")
        //            NetworkManager.sharedInstance.removePreviousNetworkCall()
        //            NetworkManager.sharedInstance.dismissLoader()
        //        }
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func doFurtherProcessingWithResult() {
        DispatchQueue.main.async {
            NetworkManager.sharedInstance.dismissLoader()
            self.view.isUserInteractionEnabled = true
            self.tableViewCell.delegate = self
            self.tableViewCell.dataSource = self
            self.tableViewCell.isHidden = false
            self.tableViewCell.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchtermsViewModel.getSearchterms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = searchtermsViewModel.getSearchterms[indexPath.row].term
        cell.textLabel?.textColor = AppStaticColors.linkColor
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchQuery = searchtermsViewModel.getSearchterms[indexPath.row].term
        
        //        let viewController = Productcategory.instantiate(fromAppStoryboard: .main)
        //        viewController.categoryName = self.categoryName
        //        viewController.categoryId = self.categoryId
        //        viewController.categoryType = self.categoryType
        //        viewController.searchQuery = self.searchQuery
        //        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
