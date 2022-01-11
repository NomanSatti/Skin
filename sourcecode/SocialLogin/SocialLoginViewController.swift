//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: SocialLoginViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

import Firebase

class SocialLoginViewController: UIViewController {
    
    // MARK: - outlates
    var movetoSignal = ""
    @IBOutlet weak var appNameLogo: UIImageView!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var signOrRegisterLbl: UILabel!
    
    @IBOutlet weak var signWithEmailView: UIView!
    @IBOutlet weak var signWithEmailBtn: UIButton!
    @IBOutlet weak var createAccountView: UIView!
    @IBOutlet weak var createAccountBtn: UIButton!
   
    
    var viewModel: SocialLoginviewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Sign In or Register".localized
        signOrRegisterLbl.text = "Sign In or Register".localized.uppercased()
        appName.text = socialLoginApplicationName.localized
        signWithEmailBtn.setTitle("Sign In with Email".localized.uppercased(), for: .normal)
        createAccountBtn.setTitle("Create an Account".localized.uppercased(), for: .normal)
      
        viewModel = SocialLoginviewModel()
        
    }
    
    func callRequest(dict: [String: Any]) {
        viewModel?.callingHttppApi(dict: dict) { [weak self] success in
            NetworkManager.sharedInstance.dismissLoader()
            guard self != nil else { return }
            if success {
                if self?.movetoSignal == "cart"{
                    self?.performSegue(withIdentifier: "checkout", sender: self)
                }
                self?.tabBarController?.tabBar.isHidden = false
                self?.navigationController?.popViewController(animated: true)
            } else {
            }
        }
    }
    

    
    
    // MARK: - twitter click
    
    
    @IBAction func backAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signInWithEmail(_ sender: Any) {
        let customerLoginVC = SignInViewController.instantiate(fromAppStoryboard: .customer)
        customerLoginVC.delegate = self
        let nav = UINavigationController(rootViewController: customerLoginVC)
        nav.modalPresentationStyle = .fullScreen
        //nav.navigationBar.tintColor = AppStaticColors.accentColor
        self.present(nav, animated: true, completion: nil)
    }
    
    //CreateAnAccountViewController
    @IBAction func createAnAccountAct(_ sender: Any) {
        let customerCreateAccountVC = CreateAnAccountViewController.instantiate(fromAppStoryboard: .customer)
        customerCreateAccountVC.delegate = self
        let nav = UINavigationController(rootViewController: customerCreateAccountVC)
        nav.modalPresentationStyle = .fullScreen
        //nav.navigationBar.tintColor = AppStaticColors.accentColor
        self.present(nav, animated: true, completion: nil)
    }
}



protocol LoginPop: NSObjectProtocol {
    func loginPop()
}

extension SocialLoginViewController: LoginPop {
    func loginPop() {
        self.navigationController?.popViewController(animated: true)
    }
}

