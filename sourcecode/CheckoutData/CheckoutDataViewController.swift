//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: CheckoutDataViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class CheckoutDataViewController: UIViewController {
    
    weak var checkoutOrderReviewObject: CheckoutOrderReviewViewController?
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    
    var paymentId: String!
    var shippingParams = [String: Any]()
    var shippingId: String!
    var isVirtual: Bool! = false
    var incrementId = ""
    
    @IBOutlet weak var checkoutScrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.image = backBtn.image?.withRenderingMode(.alwaysTemplate).flipImage()
        backBtn.tintColor = AppStaticColors.itemTintColor
        if UIDevice().hasNotch {
            containerViewHeight.constant = AppDimensions.screenHeight - 122
        } else {
            containerViewHeight.constant = AppDimensions.screenHeight - 64
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.checkoutScrollView.contentSize = CGSize(width: 2*AppDimensions.screenWidth, height: self.view.frame.height)
        self.checkoutScrollView.isPagingEnabled = true
        self.checkoutScrollView.isScrollEnabled = false
        if isVirtual {
            self.checkoutScrollView.contentOffset = CGPoint(x: AppDimensions.screenWidth, y: self.checkoutScrollView.contentOffset.y)
            self.navigationItem.title = "Review and Payment".localized
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.destination)
        if let destinationVC = segue.destination as? CheckoutAddressAndShippingViewController {
            destinationVC.view.frame = self.view.frame
            destinationVC.view.layoutIfNeeded()
            self.navigationItem.title = "Shipping".localized
            if !isVirtual {
                destinationVC.hitRequest()
            } else {
                self.navigationItem.title = ""
            }
            destinationVC.completionBlock = { [weak self] (shippingId, shippingDict, address) in
                guard let self = self else { return }
                self.navigationItem.title = "Review and Payment".localized
                self.shippingId = shippingId
                self.checkoutScrollView.contentOffset = CGPoint(x: AppDimensions.screenWidth, y: self.checkoutScrollView.contentOffset.y)
                if let checkoutOrderReviewObject = self.checkoutOrderReviewObject {
                    checkoutOrderReviewObject.shippingId = shippingId
                    checkoutOrderReviewObject.address = address
                    self.shippingParams = shippingDict
                    checkoutOrderReviewObject.callRequest()
                }
            }
        }
        
        if let destinationVC = segue.destination as? CheckoutOrderReviewViewController {
            destinationVC.isVirtual = self.isVirtual
            
            checkoutOrderReviewObject = destinationVC
            if isVirtual {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.checkoutOrderReviewObject?.callRequest()
                }
            }
            destinationVC.completionBlock = { [weak self] (paymentDetails, billingAvailable, billingDict)  in
                guard let self = self else { return }
                print(paymentDetails)
                if paymentDetails.webview {
                    let viewController = WebviewPaymentViewController.instantiate(fromAppStoryboard: .checkout)
                    viewController.paymentDetails = paymentDetails
                    self.navigationController?.pushViewController(viewController, animated: true)
                } else if paymentDetails.code == "mppayumoney" {
                    self.paymentId = paymentDetails.code
                    if billingAvailable {
                        self.shippingParams = billingDict
                    }
                    self.callingHttppApi() { success in
                        if success {
                            let viewController = WebviewPaymentViewController.instantiate(fromAppStoryboard: .checkout)
                            var details = paymentDetails
                            //edit payment details
                            details.redirectUrl = "\(baseDomain)/mobikulhttp/checkout/payuredirect/?storeId=\(Defaults.storeId)&customerToken=\(Defaults.customerToken ?? "")&quoteId=\(Defaults.quoteId)&paymentMethod=\(paymentDetails.code ?? "")"
                            //assigned new payment details
                            viewController.paymentDetails = details
                            viewController.paymentDetails?.successUrl = ["success","checkout/onepage/success"]
                            viewController.paymentDetails?.cancelUrl = ["failure","checkout/onepage/failure"]
                            viewController.paymentDetails?.failureUrl = ["checkout/cart", "checkout/#payment", "status=cancel"]
                            viewController.callbackResult = { incrementId in
                                self.incrementId = incrementId
                                self.paymentId = paymentDetails.code
                                if billingAvailable {
                                    self.shippingParams = billingDict
                                }
                                self.callRequest()
                            }
                            self.navigationController?.pushViewController(viewController, animated: true)
                        }
                    }
                } else {
                    self.paymentId = paymentDetails.code
                    if billingAvailable {
                        self.shippingParams = billingDict
                    }
                    self.callRequest()
                }
            }
        }
    }
    @IBAction func backClicked(_ sender: Any) {
        if self.checkoutScrollView.contentOffset.x == AppDimensions.screenWidth && !isVirtual {
            self.checkoutScrollView.contentOffset = CGPoint(x: 0, y: self.checkoutScrollView.contentOffset.y)
            self.navigationItem.title = "Shipping".localized
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func callRequest() {
        self.callingHttppApi { [weak self] success in
            guard let self = self else { return }
            if success {
            } else {
                
            }
        }
    }
}

extension CheckoutDataViewController {
    func callingHttppApi(completion: @escaping (Bool) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        requstParams["storeId"] = Defaults.storeId
        requstParams["width"] = UrlParams.width
        requstParams["quoteId"] = Defaults.quoteId
        if Defaults.customerToken != nil {
            requstParams["method"] = "customer"
        } else {
            requstParams["method"] = "guest"
        }
        if paymentId == "mppayumoney" {
            requstParams["isPayUPayment"] = "1"
            requstParams["incrementId"] = self.incrementId
        }
        requstParams["websiteId"] = UrlParams.defaultWebsiteId
        requstParams["paymentMethod"] = paymentId
        requstParams["shippingMethod"] = shippingId
        requstParams["billingData"] = shippingParams.convertDictionaryToString()
        requstParams["customerToken"] = Defaults.customerToken
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .post, apiname: .placeOrder, currentView: UIViewController()) { [weak self] success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            if success == 1 {                
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                print(jsonResponse)
                if jsonResponse["success"].boolValue == true {
                    Defaults.quoteId = ""
                    if self?.paymentId == "mppayumoney" && self?.incrementId == "" {
                        completion(true)
                    } else {
                        self?.doFurtherProcessingWithResult(data: jsonResponse) { success in
                            completion(success)
                        }
                    }
                } else {
                    if jsonResponse["message"].stringValue.removeWhiteSpace.count > 0 {
                        ShowNotificationMessages.sharedInstance.warningView(message: jsonResponse["message"].stringValue)
                    } else {
                        ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
                    }
                }
            } else if success == 2 {   // Retry in case of error
                NetworkManager.sharedInstance.dismissLoader()
                self?.callingHttppApi {success in
                    completion(success)
                }
            }
        }
    }
    
    func doFurtherProcessingWithResult(data: JSON, completion: (Bool) -> Void) {
        let viewController = OrderPlaceViewController.instantiate(fromAppStoryboard: .checkout)
        viewController.orderId = data["incrementId"].stringValue
        if data["showCreateAccountLink"].boolValue {
            viewController.email = data["email"].stringValue
            if data["customerDetails"] != JSON.null {
                viewController.customerDetails = AccountInformationModel(json: data["customerDetails"])
            }
        }
        viewController.callBack = { [weak self] () in
            self?.dismiss(animated: true, completion: nil)
        }
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
        completion(true)
    }
}
