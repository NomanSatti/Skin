//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: SettingsDataViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class SettingsDataViewController: UIViewController {
    
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Settings".localized
        tableView?.register(ProductSectionHeading.nib, forHeaderFooterViewReuseIdentifier: ProductSectionHeading.identifier)
        tableView.register(cellType: ChangeStatusIndicatorTableViewCell.self)
        tableView.register(cellType: ClearSearchHistoryTableViewCell.self)
        settingsBtn.setTitle("Manage in Device's Settings".localized, for: .normal)
        settingsBtn.applyBorder(colours: AppStaticColors.accentColor)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        
        if let  appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String {
            appVersionLabel.text = "App Version".localized + " " + appVersion
        } else {
            appVersionLabel.text = ""
        }
        
        //dateLabel.text = "Last Updated - 2019-02-25 17:54:35".localized
        dateLabel.text = ""
    }
    
    @IBAction func crossClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func settingsClicked(_ sender: Any) {
        let alertController = UIAlertController (title: "Title", message: "Go to Settings?", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString)  else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
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

extension SettingsDataViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell: ChangeStatusIndicatorTableViewCell = tableView.dequeueReusableCell(with: ChangeStatusIndicatorTableViewCell.self, for: indexPath) {
                cell.descLabel.text = "Receive Notifications".localized
                cell.selectionStyle = .none
                
                return cell
            }
        } else {
            if let cell: ClearSearchHistoryTableViewCell = tableView.dequeueReusableCell(with: ClearSearchHistoryTableViewCell.self, for: indexPath) {
                if Defaults.searchEnable == "1" {
                    cell.changeSwitch.isOn = true
                } else {
                    cell.changeSwitch.isOn = false
                }
                cell.descLabel.text = "Track and Show in Recent History".localized
                cell.subLabel.text = "Clear Search History".localized
                cell.subLabel.addTapGestureRecognizer {
                    if let database = DBManager.sharedInstance.database {
                        try? SearchModel.self.deleteAll(in: database)
                    }
                }
                cell.selectionStyle = .none
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProductSectionHeading.identifier) as? ProductSectionHeading {
            if section == 0 {
                headerView.titleLabel?.text = "Notifications".localized
            } else {
                headerView.titleLabel?.text = "Search History".localized
            }
            
            headerView.arrowLabel.isHidden = true
            headerView.setBackgroundViewColor(color: AppStaticColors.shadedColor!)
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 56
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
}
