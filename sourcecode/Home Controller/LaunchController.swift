//
//  LaunchController.swift
//  Odoo iOS
//
//  Created by bhavuk.chawla on 16/12/17.
//  Copyright © 2017 Bhavuk. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import Lottie

class LaunchController: UIViewController {
    
    @IBOutlet weak var actIndicater: UIActivityIndicatorView!
    @IBOutlet var topView: UIView!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var centerViewX: NSLayoutConstraint!
   // @IBOutlet weak var bottomLabel2: UILabel!
   // @IBOutlet weak var bottomContraint: NSLayoutConstraint!
   // @IBOutlet weak var bottomLabel: UILabel!
   // @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var appIcon: UIImageView!
    
    private var loattieAnimation: AnimationView?
    lazy var multipiler: CGFloat = 0.3
    lazy var animationEnded = false
    lazy var requestCompleted = false
    lazy var homeJsonData: JSON = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for views in self.view.subviews {
            views.semanticContentAttribute = .forceLeftToRight
        }
        actIndicater.isHidden = true
        //appName.text = applicationNameSmall//
     //  bottomLabel2.text = String.init(format: "%@", "firstText".localized)
            //   bottomLabel.text = String.init(format: "%@", "companyName".localized)
       /* if AppModules.isLottieEnable {
            self.loattieAnimation = AnimationView(name: "splashScreen2")
            self.loattieAnimation?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            self.loattieAnimation?.contentMode = .scaleAspectFill
            self.loattieAnimation?.frame = self.view.bounds
            self.view.addSubview(self.loattieAnimation!)
            self.loattieAnimation?.loopMode = .playOnce
            self.playLoattieAnimation()
        }*/
         self.loadHomeDta()
    }
    
    func playLoattieAnimation() {
        self.loattieAnimation?.play(completion: { (_) in
            self.loadHomeDta()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
      /*  if !AppModules.isLottieEnable {
            self.animation(viewAnimation: appIcon)
        }*/
    }
    
    private func animation(viewAnimation: UIView) {
       // xvar fontSize = appName.text?.widthOfString(usingFont: UIFont.systemFont(ofSize: 47)) ?? 0
      //  fontSize = fontSize < (animationView.frame.width-106) ? fontSize:(animationView.frame.width-106)
      //  appName.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0.2, options: [.beginFromCurrentState, .curveLinear], animations: {
           // self.centerViewX.constant = ((fontSize)/2 + 45)
            self.view.layoutIfNeeded()
        }, completion: { (_) in
            //self.bottomLabel2.isHidden = false//
          //  self.bottomLabel.isHidden = false
        //    self.bottomContraint.constant = 16
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            }) { (_) in
                self.loadHomeDta()
            }
        })
    }
    
    func loadHomeDta() {
        if LaunchHome.needAppRefresh {
            LaunchHome.needAppRefresh = false
            self.callingHttppApi()
        } else {
            let etag = DBManager.sharedInstance.geteTagFromDataBase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "homedata"))
            if etag != "" {
                LaunchHome.needAppRefresh = true
                self.homeJsonData = DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "homedata"))
                self.requestCompleted = true
            } else {
                if let path = Bundle.main.path(forResource: homeDataFileName, ofType: "geojson") {
                    do {
                        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                        if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                            print(JSON(jsonResult))
                            LaunchHome.needAppRefresh = true
                            self.homeJsonData = JSON(jsonResult)
                            self.requestCompleted = true
                        } else {
                            LaunchHome.needAppRefresh = false
                            self.callingHttppApi()
                        }
                    } catch {
                        LaunchHome.needAppRefresh = false
                        self.callingHttppApi()
                    }
                } else {
                    LaunchHome.needAppRefresh = false
                    self.callingHttppApi()
                }
            }
        }
        self.animationEnded = true
        self.launchHomePage()
    }
    
    func startFlashingView() {
        self.view.backgroundColor = AppStaticColors.accentColor
        UIView.animate(withDuration: 0.45, delay: 0.0, options: [.curveEaseInOut, .repeat, .autoreverse, .allowUserInteraction], animations: {
            self.view.backgroundColor = UIColor().hexToColor(hexString: "2c2d2d") // UIColor.darkGray
        }) { finished in
            // Do nothing
        }
    }
    
    func stopFlashingView() {
        UIView.animate(withDuration: 0.45, delay: 0.0, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
            self.view.backgroundColor = AppStaticColors.accentColor
        }) { finished in
            // Do nothing
        }
    }
    
    func getLaunchImageName() -> String? {
        // Get All PNG Images from the App Bundle
        let allPngImageNames = Bundle.main.paths(forResourcesOfType: "png", inDirectory: nil)
        // The Launch Images have a naming convention and it has a prefix 'LaunchImage'
        let expression = "SELF contains '\("LaunchImage")'"
        // Filter the Array to get the Images with the prefix 'LaunchImage'
        let res = (allPngImageNames as NSArray).filtered(using: NSPredicate(format: expression))
        var launchImageName: String = ""
        // Now you have to find the image for the Current Device and Orientation
        for launchImage in res {
            do {
                if let img = UIImage(named: (launchImage as? String ?? "")) {
                    // Has image same scale and dimensions as our current device's screen?
                    if img.scale == UIScreen.main.scale && (img.size.equalTo(UIScreen.main.bounds.size)) {
                        // The image with the Current Screen Resolution
                        launchImageName = launchImage as? String ?? ""
                        // You can store this image name somewhere, I have stored it in UserDefaults to use in the app anywhere
                        UserDefaults.standard.set(launchImageName, forKey: "launchImageName")
                        break
                    }
                }
            }
        }
        return launchImageName
    }
    
    func launchHomePage() {
        if requestCompleted && animationEnded {
            actIndicater.stopAnimating()
            self.performSegue(withIdentifier: "moveToHome", sender: self)
        } else if animationEnded {
            actIndicater.isHidden = false
            actIndicater.startAnimating()
        }
    }
    
    func callingHttppApi() {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = false
            var requstParams = [String: Any]()
            NetworkManager.sharedInstance.dismissLoader()
            requstParams["storeId"] = Defaults.storeId
            requstParams["customerToken"] = Defaults.customerToken
            requstParams["quoteId"] = Defaults.quoteId
            requstParams["currency"] = Defaults.currency
            requstParams["websiteId"] = UrlParams.defaultWebsiteId
            requstParams["width"] = UrlParams.width
            requstParams["eTag"] = DBManager.sharedInstance.geteTagFromDataBase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "homedata"))
            NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .get, apiname: .loadHome, currentView: self) {success, responseObject in
                if success == 1 {
                    self.view.isUserInteractionEnabled = true
                    let jsonResponse = JSON(responseObject as? NSDictionary ?? [:])
                    if jsonResponse["success"].boolValue == true {
                        if jsonResponse["storeId"] != JSON.null {
                            let storeId: String = String(format: "%@", jsonResponse["storeId"].stringValue)
                            if storeId != "0"{
                                Defaults.storeId = storeId
                            }
                        }
                        if jsonResponse["defaultCurrency"] != JSON.null {
                            if Defaults.currency == nil {
                                Defaults.currency = jsonResponse["defaultCurrency"].stringValue
                            }
                        }
                        let dict =  JSON(responseObject as? NSDictionary ?? [:])
                        // store the data to data base
                        if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]) {
                            DBManager.sharedInstance.storeDataToDataBase(data: data, eTag: dict["eTag"].stringValue, hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "homedata"))
                        }
                        self.homeJsonData = dict
                        self.processDataForHomeController()
                    } else {
                        self.showErrorSnackBar(msg: "somethingWentWrong".localized)
                    }
                } else if success == 2 {   // Retry in case of error
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                } else if success == 3 {   // No Changes
                    let data =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "homedata"))
                    print(data)
                    self.homeJsonData = data
                    self.processDataForHomeController()
                }
            }
        }
    }
    
    func processDataForHomeController() {
        self.requestCompleted = true
        self.launchHomePage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moveToHome",
            let tabbar = segue.destination as? UITabBarController,
            let navCont = tabbar.viewControllers?[0] as? UINavigationController ,
            let viewController = navCont.topViewController as? ViewController {
            print(viewController)
            viewController.homeJsonData = self.homeJsonData
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    /*
        // MARK: - Navigation
     
        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        }
        */
    
}
