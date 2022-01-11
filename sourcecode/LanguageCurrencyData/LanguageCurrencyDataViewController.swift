//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: LanguageCurrencyDataViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit
import Realm
import RealmSwift

class LanguageCurrencyDataViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var type = ""
    var languageData = [StoreData]()//[Stores]()
    var allowedCurrencies = [Currency]()
    var navTitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = navTitle
        tableView.register(cellType: LanguageCurrencyTableViewCell.self)
        tableView.register(ProductSectionHeading.nib, forHeaderFooterViewReuseIdentifier: ProductSectionHeading.identifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func crossClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

extension LanguageCurrencyDataViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if languageData.count > 0 {
            return languageData.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if languageData.count > 0 {
            return languageData[section].stores.count
        }
        return  allowedCurrencies.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProductSectionHeading.identifier) as? ProductSectionHeading, languageData.count > 0 {
            headerView.titleLabel?.text = languageData[section].name
            headerView.arrowLabel.isHidden = true
            headerView.setBackgroundViewColor(color: UIColor(named: "ShadedColor")!)
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if languageData.count > 0 {
            return 56
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: LanguageCurrencyTableViewCell = tableView.dequeueReusableCell(with: LanguageCurrencyTableViewCell.self, for: indexPath) {
            cell.tintColor = AppStaticColors.accentColor
            if languageData.count > 0 {
                cell.headingLabel.text = languageData[indexPath.section].stores[indexPath.row].name
                cell.subLabel.text = languageData[indexPath.section].stores[indexPath.row].code
                if let language = Defaults.language, languageData[indexPath.section].stores[indexPath.row].code == language, languageData[indexPath.section].stores[indexPath.row].id == Defaults.storeId {
                    cell.accessoryType = .checkmark
                }
            } else {
                cell.headingLabel.text = allowedCurrencies[indexPath.row].code
                cell.subLabel.text = allowedCurrencies[indexPath.row].label
                if let currency = Defaults.currency, allowedCurrencies[indexPath.row].code == currency  {
                    cell.accessoryType = .checkmark
                }
            }
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if languageData.count > 0 {
            Defaults.language = languageData[indexPath.section].stores[indexPath.row].code
            
            print(languageData[indexPath.section].stores[indexPath.row].id)
            
            Defaults.storeId = languageData[indexPath.section].stores[indexPath.row].id
            self.setView()
        } else {
            Defaults.currency = allowedCurrencies[indexPath.row].code
        }
        deleteAllRecentViewProductData()
        LaunchHome.shared.launchHome()
    }
    
    func setView() {
        if Defaults.language == "ar" {
            L102Language.setAppleLAnguageTo(lang: "ar")
            if #available(iOS 9.0, *) {
                UINavigationBar.appearance().semanticContentAttribute = .forceRightToLeft
                UITabBar.appearance().semanticContentAttribute = .forceRightToLeft
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            } else {
                // Fallback on earlier versions
            }
        } else {
            L102Language.setAppleLAnguageTo(lang: "en")
            if #available(iOS 9.0, *) {
                UINavigationBar.appearance().semanticContentAttribute = .forceLeftToRight
                UITabBar.appearance().semanticContentAttribute =  .forceLeftToRight
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    func deleteAllRecentViewProductData() {
        if let results: Results<Productcollection> = DBManager.sharedInstance.database?.objects(Productcollection.self) {
            for obj in results {
                do {
                    try DBManager.sharedInstance.database?.write {
                        DBManager.sharedInstance.database?.delete(obj)
                    }
                } catch {
                    print("Error occurred \(error)")
                }
            }
        }
    }
}
