//
//  WebviewPaymentViewController.swift
//  Mobikul Single App
//
//  Created by akash on 03/10/19.
//  Copyright © 2019 Webkul. All rights reserved.
//

import UIKit
import WebKit

class WebviewPaymentViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    var paymentDetails: PaymentMethods?
    var callbackResult: ((_ incrementId: String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        print(paymentDetails as Any)
        if let url = URL(string: paymentDetails?.redirectUrl ?? "") {
            self.webView.load(URLRequest(url: url))
        } else {
            
        }
    }
    
    @IBAction func crossClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Loaded", webView.url as Any)
        if let details = self.paymentDetails, let urlString = webView.url?.absoluteString {
            var match: [String] = []
            match += details.successUrl?.filter{urlString.contains($0)} ?? []
            match += details.cancelUrl?.filter{urlString.contains($0)} ?? []
            match += details.failureUrl?.filter{urlString.contains($0)} ?? []
            let result = match.first ?? ""
            if details.successUrl?.contains(result) ?? false {
                let arr = (urlString.components(separatedBy: "/"))
                if let index = arr.firstIndex(of: "incrementId"), arr.count > index+1 {
                    print(arr[index+1])
                    self.callbackResult?(arr[index+1])
                    self.navigationController?.popViewController(animated: true)
                }
            } else if details.cancelUrl?.contains(result) ?? false {
                let arr = (urlString.components(separatedBy: "/"))
                if let index = arr.firstIndex(of: "incrementId"), arr.count > index+1 {
                    print(arr[index+1])
                    self.callbackResult?(arr[index+1])
                    self.navigationController?.popViewController(animated: true)
                }
            } else if details.failureUrl?.contains(result) ?? false {
                let arr = (urlString.components(separatedBy: "/"))
                if let index = arr.firstIndex(of: "incrementId"), arr.count > index+1 {
                    print(arr[index+1])
                    self.callbackResult?(arr[index+1])
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
