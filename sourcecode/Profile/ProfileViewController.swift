//
//  ProfileViewController.swift
//  Mobikul Single App
//
//  Created by akash on 19/01/19.
//  Copyright © 2019 kunal. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var signoutBtn: UIButton!
    @IBOutlet weak var profileTableView: UITableView!
    
    let profileViewModal = ProfileViewModal()
    var isCutomPush = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title =  "Account".localized
        profileViewModal.delegate = self
        profileTableView.tableFooterView = UIView()
        profileTableView.register(ProfileCell.nib, forCellReuseIdentifier: ProfileCell.identifier)
        profileTableView.delegate = profileViewModal
        profileTableView.dataSource = profileViewModal
        self.signoutBtn.setTitle("Log Out".localized.uppercased(), for: .normal)
        self.signoutBtn.applyButtonBorder(colours: AppStaticColors.accentColor)
    }
    
    override func viewWillAppear(_ animated: Bool) {
         if !isCutomPush{
                  self.tabBarController?.tabBar.isHidden = false
             }else{
                  self.tabBarController?.tabBar.isHidden = false
            
             }
        self.profileViewModal.profileData.removeAll()
        if UserDefaults.fetch(key: Defaults.Key.customerToken.rawValue) != nil {
            self.signoutBtn.isHidden = false
            self.profileViewModal.getUserProfileData(isLoggedIn: true) { (data) in
                if data {
                    self.profileTableView.reloadData()
                }
            }
        } else {
            self.signoutBtn.isHidden = true
            self.profileViewModal.getUserProfileData(isLoggedIn: false) { (data) in
                if data {
                    self.profileTableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func signoutClicked(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = false
        let AC = UIAlertController(title: "Sign out".localized, message: "You will not be able to manage and track Orders".localized, preferredStyle: .alert)
        let yesBtn = UIAlertAction(title: "Sign out".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.logoutPerform()
        })
        let noBtn = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        
        AC.addAction(yesBtn)
        AC.addAction(noBtn)
        self.present(AC, animated: true, completion: {})
    }
    
    func logoutPerform() {
        profileViewModal.callingHttppApi { [weak self] success in
            guard let self = self else { return }
            if success {
                self.profileViewModal.profileData.removeAll()
                self.profileViewModal.getUserProfileData(isLoggedIn: false) { (data) in
                    if data {
                        //call deleteTokenFromDataBase
                        self.profileViewModal.callingDeleteTokenApi(completion: { [weak self] success in
                            guard let self = self else { return }
                            if success {
                                
                            }
                        })
                        self.signoutBtn.isHidden = true
                        self.profileTableView.reloadData()
                    }
                }
            }
        }
    }
}

extension ProfileViewController: PerformProfileActions {
    func performProfileActions(action: AllControllers, title: String) {
        self.tabBarController?.tabBar.isHidden = true
        switch action {
        case .signInController:
            let customerLoginVC = SocialLoginViewController.instantiate(fromAppStoryboard: .customer)
            self.navigationController?.pushViewController(customerLoginVC, animated: true)
        case .addressBookListViewController:
            let viewController = AddressBookListViewController.instantiate(fromAppStoryboard: .customer)
            self.navigationController?.pushViewController(viewController, animated: true)
        case .myOrders:
            let orderDetails = OrderListViewController.instantiate(fromAppStoryboard: .customer)
            self.navigationController?.pushViewController(orderDetails, animated: true)
        case .dashboardViewController:
            let viewController = DashboardDataViewController.instantiate(fromAppStoryboard: .customer)
            self.navigationController?.pushViewController(viewController, animated: true)
        case .downloadViewController:
            let viewController = DownloadableProductDataViewController.instantiate(fromAppStoryboard: .customer)
            self.navigationController?.pushViewController(viewController, animated: true)
        case .accountInformation:
            let viewController = AccountInformationViewController.instantiate(fromAppStoryboard: .customer)
            self.navigationController?.pushViewController(viewController, animated: true)
        case .compareListViewController:
            let viewController = CompareListViewController.instantiate(fromAppStoryboard: .customer)
            self.navigationController?.pushViewController(viewController, animated: true)
        case .productReviewList:
            let viewController = ProductReviewListViewController.instantiate(fromAppStoryboard: .customer)
            self.navigationController?.pushViewController(viewController, animated: true)
        case .contactUsController:
            let viewController = ContactUsDataViewController.instantiate(fromAppStoryboard: .customer)
            self.navigationController?.pushViewController(viewController, animated: true)
        case .orderReturn:
            let viewController = OrderAndReturnsDataViewController.instantiate(fromAppStoryboard: .more)
            self.navigationController?.pushViewController(viewController, animated: true)
        case .none: let a = 10
//            self.tabBarController?.tabBar.isHidden = false
//            let url = URL(string: "itms-apps://itunes.apple.com/us/app/apple-store/id1166583793?mt=8")!
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            //UIApplication.shared.openURL(url)
            //UIApplication.shared.openURL(NSURL(string: "itms://itunes.apple.com/de/app/x-gift/id839686104?mt=8&uo=4") as! URL)            
      
        default:
            break
        }
    }
}
