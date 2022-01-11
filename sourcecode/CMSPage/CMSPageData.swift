//
//  CMSPageData.swift
//  Ajmal
//
//  Created by Webkul on 05/05/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class CMSPageData: UIViewController, UIWebViewDelegate {
    
    public var cmsId: String!
    public var cmsName: String!
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        webView.stringByEvaluatingJavaScript(from: "document.body.style.webkitTouchCallout='none';")
        self.navigationController?.isNavigationBarHidden = false
        webView.delegate = self
        self.callingHttppApi()
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.isNavigationBarHidden = false
    }
    
    func callingHttppApi() {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        requstParams["id"] = cmsId
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .get, apiname: .cmsData, currentView: self) {success, responseObject in
            if success == 1 {
                print("sss", JSON(responseObject as? NSDictionary ?? [:]))
                self.doFurtherProcessingWithResult(data: JSON(responseObject as? NSDictionary ?? [:]))
                
            } else if success == 2 {
                self.callingHttppApi()
            }
        }
    }
    
    func doFurtherProcessingWithResult(data: JSON) {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            NetworkManager.sharedInstance.dismissLoader()
            
            if let heading = data["title"].string {
                self.navigationController?.navigationBar.topItem?.title = heading
            }
            
            var HTMLString = String()
            let htmlContent =
            """
            <!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">
            <html lang=\"en\">
            <head>
            <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">
            <link rel=\"stylesheet\" type=\"text/css\" href=\"\(baseDomain)/pub/static/version1501785931/frontend/Magento/luma/en_US/css/styles-l.css\" media=\"all\">
            <link rel=\"stylesheet\" type=\"text/css\" href=\"\(baseDomain)/pub/static/version1501785931/frontend/Magento/luma/en_US/css/styles-m.css\" media=\"all\">
            <link rel=\"stylesheet\" type=\"text/css\" href=\"\(baseDomain)/pub/media/styles.css\" media=\"all\">
            </head>
            <body data-container="body" class="cms-privacy-policy-cookie-restriction-mode cms-page-view" style="padding:5px;">
            <div class="page-wrapper">
            <main id="maincontent" class="page-main">
            <div class="columns">
            <div class="column main">
            
            \(data["content"].stringValue)
            </div>
            </div>
            </main>
            </div>
            </body>
            
            </html>
            """
            
            if Defaults.language == "ar" {
                HTMLString = "<span dir=\"rtl\">\(htmlContent)</span></p>"
            } else {
                HTMLString = "<span dir=\"ltr\">\(htmlContent)</span></p>"
            }
            
            self.webView.loadHTMLString(HTMLString, baseURL: nil)
        }
        
    }
    func webView(_ inWeb: UIWebView, shouldStartLoadWith inRequest: URLRequest, inType: UIWebView.NavigationType) -> Bool {
        if inType == .linkClicked {
            if let url = inRequest.url {
                UIApplication.shared.openURL(url)
            }
            return false
        }
        return true
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        if navigationType == .linkClicked {
            if let url = request.url {
                UIApplication.shared.openURL(url)
            }
            return false
        }
        return true
    }
    
}
