//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: LoadExtraWebViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit
import WebKit

class LoadExtraWebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    var url: URL!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.configuration.allowsInlineMediaPlayback = true
        webView.configuration.allowsPictureInPictureMediaPlayback = true
        //        let webConfiguration = WKWebViewConfiguration()
        //        webConfiguration.allowsInlineMediaPlayback = true
        //        webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        //        
        //        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        print(url)
        webView.loadFileURL(url, allowingReadAccessTo: url)
        //        webView.load(URLRequest(url: url))
        // Do any additional setup after loading the view.
    }
    
    @IBAction func crossClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
