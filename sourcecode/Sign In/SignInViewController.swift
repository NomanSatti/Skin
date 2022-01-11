//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: SignInViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 */

import UIKit
import MaterialComponents.MaterialTextFields_ColorThemer
import MaterialComponents.MaterialTextFields_TypographyThemer
import Alamofire

class SignInViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    var emailController: MDCTextInputControllerOutlined!
    var passwordController: MDCTextInputControllerOutlined!
    @IBOutlet weak var emailTextField: MDCTextField!
    @IBOutlet weak var passwordTextField: MDCTextField!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    var userEmail: String = ""
    let button = UIButton(type: .custom)
    var viewModel = SignInViewModel()
    weak var delegate: LoginPop?
    var parentController = ""
    var email: String?
    var signInHandler: (() -> ())?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.text = ""
        passwordTextField.text = ""
       
        forgotPasswordBtn.titleLabel?.textColor = UIColor.lightGray
        self.navigationItem.title = "Sign In with Email".localized
        signInButton.setTitle("Sign In".localized.uppercased(), for: .normal)
        createAccountButton.setTitle("Create an Account".localized.uppercased(), for: .normal)
        forgotPasswordBtn.setTitle("Forgot password?".localized, for: .normal)
        DispatchQueue.main.async {
            self.emailController = MDCTextInputControllerOutlined(textInput: self.emailTextField)
            self.passwordController = MDCTextInputControllerOutlined(textInput: self.passwordTextField)
            let allTextFieldController: [MDCTextInputControllerOutlined] = [self.emailController, self.passwordController]
            for textFieldController in allTextFieldController {
                textFieldController.activeColor = AppStaticColors.accentColor
                textFieldController.floatingPlaceholderActiveColor = AppStaticColors.accentColor
            }
            self.emailController.placeholderText = "Email Address".localized
            self.passwordController.placeholderText = "Password".localized
        }
        // MARK: - code for hide show btn
        button.setImage(UIImage(named: "closePassword"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(passwordTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.revealPassword), for: .touchUpInside)

        passwordTextField.rightView = button
        passwordTextField.rightViewMode = .always
        if let email = email {
            emailTextField.text = email
            passwordTextField.text = ""
        }
        if #available(iOS 12.0, *) {
            emailTextField.textContentType = .username
            passwordTextField.textContentType = .password
        }

        if Defaults.language == "ar" {
            emailTextField.semanticContentAttribute = .forceRightToLeft
            passwordTextField.semanticContentAttribute = .forceRightToLeft
            emailTextField.textAlignment = .right
            passwordTextField.textAlignment = .right
        } else {
            emailTextField.semanticContentAttribute = .forceLeftToRight
            passwordTextField.semanticContentAttribute = .forceLeftToRight
            emailTextField.textAlignment = .left
            passwordTextField.textAlignment = .left
        }
    }
    // MARK: - revel password func
    @objc func revealPassword(_ sender: Any) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        if passwordTextField.isSecureTextEntry {
            button.setImage(UIImage(named: "closePassword"), for: .normal)
        } else {
            button.setImage(UIImage(named: "seePassword"), for: .normal)
        }
    }
    
    // MARK: - forget password
    @IBAction func forgotPasswordAction(_ sender: Any) {
        let AC = UIAlertController(title: "enteremail".localized, message: "", preferredStyle: .alert)
        AC.addTextField { (textField) in
            textField.placeholder = "enteremail".localized
            textField.text = self.emailTextField.text
        }
        let okBtn = UIAlertAction(title: "ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            let textField = AC.textFields![0]
            guard let emailId = textField.text, emailId.count>1 else {
                self.showWarningSnackBar(msg: "pleasefillemailid".localized)
                return
            }
            if !NetworkManager.sharedInstance.checkValidEmail(data: emailId) {
                self.showWarningSnackBar(msg: "pleaseentervalidemail".localized)
                return
            }
            var dict = [String: Any]()
            dict["username"] = emailId
            self.callRequest(dict: dict, apiCall: .forgetPassword)
        })
        let noBtn = UIAlertAction(title: "cancel".localized, style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(okBtn)
        AC.addAction(noBtn)
        self.present(AC, animated: true, completion: {  })
    }
    
    // MARK: - sign act
    @IBAction func signInAction(_ sender: Any) {
        guard let emailId = emailTextField.text, emailId.count != 0 else {
            self.showWarningSnackBar(msg: "enteremail".localized)
            emailTextField.shake()
            return
        }
        
        if !NetworkManager.sharedInstance.checkValidEmail(data: emailId) {
            self.showWarningSnackBar(msg: "pleaseentervalidemail".localized)
            emailTextField.shake()
            return
        }
        
        guard let password = passwordTextField.text, password.count != 0 else {
            self.showWarningSnackBar(msg: "enterpassword".localized)
            passwordTextField.shake()
            return
        }
        var dict = [String: Any]()
        dict["username"] = self.emailTextField.text ?? ""
        dict["password"] = self.passwordTextField.text ?? ""
        dict["token"] = Defaults.deviceToken
        UserDefaults.standard.set(self.passwordTextField.text, forKey: "loginUserPassword")
        callRequest(dict: dict, apiCall: .login)
    }
    // MARK: - Api act
    func callRequest(dict: [String: Any], apiCall: WhichApiCall) {
        viewModel.callingHttppApi(dict: dict, apiCall: apiCall) { [weak self] success in
            NetworkManager.sharedInstance.dismissLoader()
            guard self != nil else { return }
            if success {
                if apiCall == .login {
                    UserDefaults.standard.set(self?.passwordTextField.text, forKey: "loginUserPassword")
                    ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: "Login Successfully".localized)
                    self?.dismiss(animated: true, completion: {
                        if let signInHandler = self?.signInHandler {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHomeApiData"), object: nil)
                            signInHandler()
                        } else {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHome"), object: nil)
                        }
                        self?.delegate?.loginPop()
                        //LaunchHome.shared.launchHome()
                    })
                }
            } else {
            }
        }
    }
    
    // MARK: - close btn act
    @IBAction func closeAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAnAccountAct(_ sender: Any) {
        if parentController == "signUp" {
            self.navigationController?.popViewController(animated: true)
        } else {
            let customerCreateAccountVC = CreateAnAccountViewController.instantiate(fromAppStoryboard: .customer)
            customerCreateAccountVC.parentController = "signIn"
            customerCreateAccountVC.delegate = delegate
            self.navigationController?.pushViewController(customerCreateAccountVC, animated: true)
        }
        
        //        self.present(nav, animated: true, completion: nil)
        //        let nav = UINavigationController(rootViewController: customerCreateAccountVC)
        //        self.present(nav, animated: true, completion: nil)
    }
}
