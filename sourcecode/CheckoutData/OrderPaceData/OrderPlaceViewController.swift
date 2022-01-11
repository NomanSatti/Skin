//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: OrderPlaceViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit
import Lottie
import Alamofire

class OrderPlaceViewController: UIViewController {
    
    
    @IBOutlet weak var guestBtn: UIButton!
    @IBOutlet weak var guestLabel: UILabel!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var continuShopping: UIButton!
    @IBOutlet weak var detailText: UILabel!
    @IBOutlet weak var thanksLabel: UILabel!
    private var loattieAnimation: AnimationView?
    @IBOutlet weak var checkBox: UIView!
    var orderId: String!
    var email: String!
    var customerDetails: AccountInformationModel!
    var callBack: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Defaults.customerToken == nil, let email = email {
            emailView.isHidden = false
            guestLabel.text = "You can track your order status by creating an account with this email".localized + ": " + email
            guestBtn.setTitle("Create Account".localized, for: .normal)
        } else {
            emailView.isHidden = true
        }
        //        OperationQueue.main.addOperation() {
        self.loattieAnimation = AnimationView(name: "data")
        self.loattieAnimation!.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.loattieAnimation!.contentMode = .scaleAspectFill
        self.loattieAnimation!.frame = self.placeImage.bounds
        self.placeImage.addSubview(self.loattieAnimation!)
        loattieAnimation!.loopMode = .playOnce
        self.playLoattieAnimation()
        
        //        }
        Defaults.cartBadge = "0"
        
        //        checkBox.setOn(false, animated: true)
        //        checkBox.animationDuration = 1
        //        checkBox.onAnimationType = .stroke
        thanksLabel.text = "Thanks for Purchase".localized
        let orderNum = "Your order number is".localized + ": \(orderId ?? "") "
        let confimation = "We'll email you an order confirmation with details and tracking info".localized + "."
        detailText.text = orderNum + confimation
        //detailText.text = "Your order number is".localized + ": " + orderId + " " + "We'll email you an order confirmation with details and tracking info" + "."
        continuShopping.setTitle("Continue Shopping".localized, for: .normal)
        detailText.addTapGestureRecognizer {
            let viewController = OrderDetailsDataViewController.instantiate(fromAppStoryboard: .customer)
            viewController.orderId = self.orderId
            let nav = UINavigationController(rootViewController: viewController)
            //nav.navigationBar.tintColor = AppStaticColors.accentColor
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    func playLoattieAnimation() {
        self.loattieAnimation?.play(completion: { (_) in
            self.loattieAnimation?.loopMode = .playOnce
        })
    }
    
    @IBAction func continueShoppingBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.callBack?()
        })
    }
    
    override func viewWillLayoutSubviews() {
        //        detailText.halfTextWithColorChange(fullText: detailText.text!, changeText: orderId, color: UIColor.blue)
    }
    
    override func viewDidLayoutSubviews() {
        detailText.halfTextWithColorChange(fullText: detailText.text!, changeText: orderId, color: UIColor.blue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //         DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        //            self.checkBox.setOn(true, animated: true)
        //         }
    }
    
    @IBAction func createAccountClicked(_ sender: Any) {
        //        self.callingHttppApi(orderId: orderId)
        let viewController = CreateAnAccountViewController.instantiate(fromAppStoryboard: .customer)
        viewController.customerDetails = customerDetails
        viewController.callback =  { [weak self] () in
            self?.dismiss(animated: true, completion: {
                self?.callBack?()
            })
        }
        let nav = UINavigationController(rootViewController: viewController)
        //nav.navigationBar.tintColor = AppStaticColors.accentColor
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    func callingHttppApi(orderId: String) {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        let apiName: WhichApiCall = .accountcreate
        let verbs: HTTPMethod = .post
        requstParams["orderId"] = orderId
        requstParams["storeId"] = Defaults.storeId
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: verbs, apiname: apiName, currentView: UIViewController()) { [weak self] success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            guard let self = self else { return }
            let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
            if success == 1 {
                if jsonResponse["success"].boolValue {
                    self.guestBtn.isHidden = true
                    self.guestLabel.text = jsonResponse["message"].stringValue
                } else {
                    ShowNotificationMessages.sharedInstance.warningView(message: jsonResponse["message"].stringValue)
                }
            } else {
                ShowNotificationMessages.sharedInstance.warningView(message: jsonResponse["message"].stringValue)
            }
        }
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
