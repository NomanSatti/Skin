//
/**
 Mobikul_Magento2V3_App
 @Category Webkul
 @author    Webkul
 Created by: rakesh on 01/09/18
 FileName: SignInPopOverViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license   https://store.webkul.com/license.html
 */

import UIKit

class SignInPopOverViewController: UIViewController {
    @IBOutlet weak var popOverTableView: UITableView!
    
    var logoutData: NSMutableArray = ["searchterms".localized, "comparelist".localized, "contactus".localized, "cmspages".localized]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.popOverTableView.register(ProfileCell.nib, forCellReuseIdentifier: ProfileCell.identifier)
        self.popOverTableView.delegate = self
        self.popOverTableView.dataSource = self
        self.popOverTableView.reloadData()
        self.popOverTableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func crossButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SignInPopOverViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logoutData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.identifier) as? ProfileCell else { return UITableViewCell() }
        if let sectionContents = logoutData[indexPath.row] as? String {
            cell.name.text = sectionContents
        }
        if indexPath.row == 0 {
            cell.profileImage.image = UIImage(named: "ic_searchterms")!
        } else if indexPath.row == 1 {
            cell.profileImage.image = UIImage(named: "ic_profilecompare")!
        } else if indexPath.row == 2 {
            cell.profileImage.image = UIImage(named: "ic_contactus")!
        } else if indexPath.row == 3 {
            cell.profileImage.image = UIImage(named: "ic_accountinfo")!
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
