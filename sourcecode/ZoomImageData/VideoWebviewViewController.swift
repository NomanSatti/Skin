//
//  VideoWebviewViewController.swift
//  Mobikul Single App
//
//  Created by akash on 02/05/19.
//  Copyright © 2019 Webkul. All rights reserved.
//

import UIKit
import WebKit

class VideoWebviewViewController: UIViewController, WKNavigationDelegate {
    
    var webView : WKWebView!
    var videoURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let myBlog = "https://iosdevcenters.blogspot.com/"
        if let url = URL(string: videoURL) {
        //    let request = URLRequest(url: url)
            
            
            let configuration = WKWebViewConfiguration()
            configuration.allowsInlineMediaPlayback = true
            configuration.mediaTypesRequiringUserActionForPlayback = []
            webView = WKWebView(frame: self.view.frame, configuration: configuration)
         //   webView = WKWebView(frame: self.view.frame)
           // webView.configuration.mediaTypesRequiringUserActionForPlayback = []
            webView.navigationDelegate = self
           // webView.load(request)
        
            self.view.addSubview(webView)
            
            self.view.sendSubviewToBack(webView)
            
            //self.webView.backgroundColor = UIColor.red
        }
    }
    
    override func viewDidLayoutSubviews() {
          webView.loadHTMLString(embedVideoHtml, baseURL: nil)
    }
    
    
    @IBAction func barButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        NetworkManager.sharedInstance.showLoader()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        NetworkManager.sharedInstance.dismissLoader()
    }
    
    lazy var embedVideoHtml:String  = {
          return """
          <!DOCTYPE html>
          <html>
          <body>
          <!-- 1. The <iframe> (and video player) will replace this <div> tag. -->
          <div id="player"></div>

          <script>
          var tag = document.createElement('script');

          tag.src = "https://www.youtube.com/iframe_api";
          var firstScriptTag = document.getElementsByTagName('script')[0];
          firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

          var player;
          function onYouTubeIframeAPIReady() {
          player = new YT.Player('player', {
          playerVars: { 'autoplay': 1, 'controls': 0, 'playsinline': 0 },
          height: '\(0)',
          width: '\(0)',
          videoId: '\(videoURL.lastPathComponent)',
          events: {
          'onReady': onPlayerReady
          }
          });
          }

          function onPlayerReady(event) {
          event.target.playVideo();
          }
          </script>
          </body>
          </html>
          """
      }()

    
}
