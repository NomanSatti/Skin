//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: MoreDataViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class MoreDataViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var sectionCount = 0
    var cmsData = [CMSdata]()
    
    var homeViewModel: HomeViewModel {
        guard let navigationController = self.tabBarController?.viewControllers?[0] as? UINavigationController,
            let viewControllerHome = navigationController.viewControllers[0] as? ViewController else {
                return HomeViewModel()
        }
        return viewControllerHome.homeViewModel
    }
    
    var preferencesData = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "More".localized
        tableView?.register(ProductSectionHeading.nib, forHeaderFooterViewReuseIdentifier: ProductSectionHeading.identifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        preferencesData = []
        
        if homeViewModel.allowedCurrencies.count > 1 {
            preferencesData.append(["Currency", "Currency".localized])
        }
        
        if homeViewModel.storeData.count > 0 {
            if !(homeViewModel.storeData.count == 1 && (homeViewModel.storeData.first?.stores.count ?? 0) <= 1) {
                preferencesData.append(["Language", "Language".localized])
            }
        }
        
        preferencesData.append(["Settings", "Settings".localized])
        print("viewDidLoad - \(type(of: self))")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        cmsData = homeViewModel.cmsData
        sectionCount = 4
        self.tableView.reloadData()
        print("view WillAppear - \(type(of: self))")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
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

extension MoreDataViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if section == 0 {
             return 7
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProductSectionHeading.identifier) as? ProductSectionHeading {
          /*  if section == 0 &&  homeViewModel.websiteData.count > 1 {
                headerView.titleLabel?.text = "Websites".localized.uppercased()
            } else  if section == 0 &&  homeViewModel.storeData.count < 2 {
                return nil
            } else if section == 1 {
                headerView.titleLabel?.text = "Preferences".localized.uppercased()
            } else if section == 2 {
                headerView.titleLabel?.text = "Others".localized.uppercased()
            } else {
                return nil
            }*/
            
            headerView.titleLabel?.text = "Preferences & Others"
            headerView.arrowLabel.isHidden = true
            headerView.setBackgroundViewColor(color: UIColor(named: "ShadedColor")!)
            return headerView
        }
        return nil
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 56
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.font = UIFont.myBoldSystemFont(ofSize: 17)
        cell.accessoryType = .disclosureIndicator
        switch indexPath.section {
        case 0:
            
            if indexPath.row == 0{
                cell.textLabel?.text = "Account".localized
            }else if indexPath.row == 1{
                
                let preference = preferencesData[1]
                if let language = Defaults.language {
                    if let index = homeViewModel.storeData.firstIndex(where: { $0.id == UrlParams.defaultWebsiteId }) {
                        let selectedLanguage = (homeViewModel.storeData[index].stores.filter({$0.code == language})).first?.name ?? ""
                        if selectedLanguage != "" {
                            cell.textLabel?.text = preference[1] + " - \(selectedLanguage)"
                        }
                    }
                }
                
            }else if indexPath.row == 2{
                
                let preference = preferencesData[0]
                if let currency = Defaults.currency {
                    let selectedCurrency = (homeViewModel.allowedCurrencies.filter({$0.code == currency})).first?.label ?? ""
                    if selectedCurrency != "" {
                        cell.textLabel?.text = preference[1] + " - \(selectedCurrency)"
                    }
                }
                
                
            }else if indexPath.row == 3{
                cell.textLabel?.text = preferencesData[2][1]
                
                
            }else if indexPath.row == 4 {
                cell.textLabel?.text = "Wishlist".localized
                
            }else if indexPath.row == 5 {
                cell.textLabel?.text = "Contact Us".localized
            }else if indexPath.row == 6 {
                cell.textLabel?.text = "Maintenance".localized//"Store Locator".localized
            }
            
        default:
            break
        }
        if Defaults.language == "ar" {
            cell.textLabel?.textAlignment = .right
        } else {
            cell.textLabel?.textAlignment = .left
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 && homeViewModel.websiteData.count < 2 {
            return 0
        }
        return 8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tabBarController?.tabBar.isHidden = true
        
        let viewController = LanguageCurrencyDataViewController.instantiate(fromAppStoryboard: .more)
        
        if indexPath.row == 0 {
            let viewController = ProfileViewController.instantiate(fromAppStoryboard: .main)
            self.navigationController?.pushViewController(viewController, animated: true)
        }else if indexPath.row == 1{
            let preference = preferencesData[1]
            if let index = homeViewModel.storeData.firstIndex(where: { $0.id == UrlParams.defaultWebsiteId }) {
                //viewController.languageData = homeViewModel.storeData[index].stores
                viewController.languageData = homeViewModel.storeData
                viewController.navTitle = "Languages".localized
                let nav = UINavigationController(rootViewController: viewController)
                //nav.navigationBar.tintColor = AppStaticColors.accentColor
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }else if indexPath.row == 2{
            viewController.allowedCurrencies = homeViewModel.allowedCurrencies
            viewController.navTitle = "Currencies".localized
            let nav = UINavigationController(rootViewController: viewController)
            //nav.navigationBar.tintColor = AppStaticColors.accentColor
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
            
        }else if indexPath.row == 3{
            let viewController = SettingsDataViewController.instantiate(fromAppStoryboard: .more)
            let nav = UINavigationController(rootViewController: viewController)
            //nav.navigationBar.tintColor = AppStaticColors.accentColor
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }else if indexPath.row == 4{
            let viewController = WishlistDataViewController.instantiate(fromAppStoryboard: .main)
            self.navigationController?.pushViewController(viewController, animated: true)
        }else if indexPath.row == 5{
            let viewController = ContactUsDataViewController.instantiate(fromAppStoryboard: .customer)
            self.navigationController?.pushViewController(viewController, animated: true)
        }else if indexPath.row == 6 {
            
//            let vc = R.StoryboardRef.Main.instantiateViewController(withIdentifier: R.ViewControllerIds.storeVc) as! StoreLocatorViewController
//            self.navigationController?.pushViewController(vc, animated: true)

            let vc = R.StoryboardRef.Main.instantiateViewController(withIdentifier: R.ViewControllerIds.maintenanceVc) as! MaintenanceViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
}
