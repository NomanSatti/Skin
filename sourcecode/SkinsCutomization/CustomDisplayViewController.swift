//
//  CustomDisplayViewController.swift
//  sourcecode
//
//  Created by Work on 4/30/20.
//  Copyright © 2020 ranjit. All rights reserved.
//

import UIKit

import SwiftMessages
import SwiftyJSON
import Alamofire
import SnapKit




class CustomDisplayViewController: UIViewController {
    
    @IBOutlet weak var imgIphone: UIImageView!
    @IBOutlet weak var ImgDisplay: UIImageView!
    @IBOutlet weak var btnOrderNow: UIButton!
    
    
    
     var scrollView = UIScrollView()

       var captureView = UIView()
       
       var deviceImageUrl = ""
       var deviceSelected = ""
       
       var wallpaperImage = UIImage()
       var wallpaperImage2 = UIImage()
    
       var wallpaperDetails = JSON()
       var prdesignWallpaper: ProdesignWallpaperModel?
       
       var isCustomUpload = false
       
       var editedFinalImage: UIImage?
    
    
    override func viewDidLayoutSubviews() {
         self.ImgDisplay.image = self.wallpaperImage
    }
    
    fileprivate func setup() {
        self.editedFinalImage = self.wallpaperImage
        
        getCustomImageDetails {
            let priceText = self.wallpaperDetails["price"]
            let orderNow = NSLocalizedString("Add To Cart", comment: "")
            let currency = NSLocalizedString("SR", comment: "")
            self.btnOrderNow.setTitle("\(orderNow) @ \(priceText) \(currency)", for: .normal)
            self.imgIphone.af_setImage(withURL: URL.init(string: MEIDA_URL + self.deviceImageUrl)!) { (response) in
                NetworkManager.sharedInstance.dismissLoader()
            }
        }
     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.navigationController?.navigationBar.isHidden = false
        
        self.imgIphone.contentMode = .scaleAspectFit//.scaleToFill
        self.ImgDisplay.contentMode = .scaleAspectFit//.scaleToFill // AHTAZAZ ADDED
        
        setup()
   
        self.view.addSubview(btnOrderNow)
    
        btnOrderNow.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view.snp.leading).offset(20)
            make.trailing.equalTo(self.view.snp.trailing).offset(-20)
            make.bottom.equalTo(self.view.snp.bottom).offset(-30)
            make.height.equalTo(32)
        }
        
        
        self.view.addSubview(captureView)
        captureView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top)
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
            make.bottom.equalTo(self.btnOrderNow.snp.top).offset(-2)
        }
        
        self.ImgDisplay.image = self.wallpaperImage
        let guide = view.safeAreaLayoutGuide
        
        self.view.addSubview(scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(guide.snp.top).offset(10)
            make.bottom.equalTo(self.btnOrderNow.snp.top).offset(-10)
            make.width.equalTo(self.btnOrderNow.snp.width).offset(-90)//offset(-20)
            make.centerX.equalTo(self.btnOrderNow.snp.centerX)
            
        }
        
        scrollView.isScrollEnabled = true
        
//        self.scrollView.addSubview(self.ImgDisplay)
//        self.ImgDisplay.snp.makeConstraints { (make) in
//            make.top.equalTo(self.scrollView.snp.top)
//            make.width.equalTo(self.scrollView.snp.width)
//            make.centerX.equalTo(self.scrollView.snp.centerX)
//            make.bottom.equalTo(self.scrollView.snp.bottom)
//
//            make.height.equalTo(self.view.snp.height).multipliedBy(0.9)
//        }
        
        self.scrollView.addSubview(self.ImgDisplay)
        self.ImgDisplay.snp.makeConstraints { (make) in
            make.top.equalTo(self.scrollView.snp.top)
            make.leading.equalTo(self.scrollView.snp.leading)//.offset(100)
            make.trailing.equalTo(self.scrollView.snp.trailing)//.offset(100)
            make.bottom.equalTo(self.scrollView.snp.bottom)
            make.centerX.equalTo(self.scrollView.snp.centerX)//--
            make.height.equalTo(self.view.snp.height).multipliedBy(0.84)
        }
        
        
        self.view.addSubview(self.imgIphone)
        
        self.imgIphone.snp.makeConstraints { (make) in
            make.top.equalTo(guide.snp.top).offset(10)
            make.leading.equalTo(self.btnOrderNow.snp.leading)//.offset(15)
            make.trailing.equalTo(self.btnOrderNow.snp.trailing)//.offset(-15)
            make.bottom.equalTo(self.btnOrderNow.snp.top).offset(-10)
        }
        
        self.imgIphone.isUserInteractionEnabled = false
        
      
        
        //self.ImgDisplay.layer.masksToBounds = true
//        self.ImgDisplay.clipsToBounds = true
        self.scrollView.layer.masksToBounds = true
        
        //self.view.bringSubviewToFront(self.imgIphone)
        
    
       // Ahtazaz removed
//        self.ImgDisplay.contentMode = .scaleToFill//.scaleAspectFit
        
        
        //self.imgIphone.contentMode = .scaleToFill
        
     //   self.ImgDisplay.layer.masksToBounds = true
        self.scrollView.layer.masksToBounds = true
        
     
        
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 60.0 //3.5
        
        scrollView.delegate = self
        
        self.captureView.addSubview(scrollView)
        self.captureView.addSubview(self.imgIphone)
       
        self.captureView.bringSubviewToFront(self.imgIphone)
        self.view.bringSubviewToFront(self.imgIphone)
        
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        
        //self.scrollView.contentMode = .scaleAspectFit
        
      
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
          self.tabBarController?.tabBar.isHidden = true
        
    }
    
    
    
    private func getCustomImageDetails(completionHandler: @escaping () -> ()){
        
        NetworkManager.sharedInstance.showLoader()
        
        let url: String = API_ROOT_DOMAIN + "rest/V1/products/TestCustomUpload"
        var request = URLRequest(url:  NSURL(string: url)! as URL)
        
        request.httpMethod = "GET"
        
        request.setValue("Bearer \(ADMIN_TOKEN)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        Alamofire.request(request).responseJSON { (responseObject) -> Void in
            
            let json = JSON(responseObject.result.value)
            print(json)
            self.wallpaperDetails = json
            
            completionHandler()
           
            
        }
    }
    
    

    
    @IBAction func btnOrderNowClicked(_ sender: UIButton) {
        
     
        if let image = self.captureView.snapshot(){
            
            if let image2 = self.scrollView.snapshotVisibleArea{
                self.wallpaperImage = image
                self.wallpaperImage2 = image2
                self.addToCart()
            }
            
            
        }else{
             self.addToCart()
        }
        
    }
    
    
    private func addToCart(){
        
        let sku = self.wallpaperDetails["sku"].stringValue
        if UserDefaults.fetch(key: Defaults.Key.customerToken.rawValue) != nil{
            OrderProcessManager.getMyCartData { (json) in
                if let cartID = UserDefaults.standard.value(forKey: "cartID") as? Int {
                    
                          var parameters = [
                                  "cartItem" : [
                                      "sku": "TestCustomUpload",
                                      "qty": "1",
                                      "quote_id": cartID,
                                      "extensionAttributes":[
                                        "mobile": self.deviceSelected,
                                        "image": "data:image/png;base64," + self.wallpaperImage.toBase64()!,
                                        "second_image": "data:image/png;base64," + self.wallpaperImage2.toBase64()!
                                     ]
                                  ]
                              ] as! [String: Any]
                    
                        NetworkManager.sharedInstance.showLoader()
                    self.getNewAuthToken {
                        
                        let token = UserDefaults.standard.string(forKey: "USERTOKEN")
                             print(token)
                             let url: String = API_ROOT_DOMAIN + "rest/V1/carts/mine/items?"
                             var request = URLRequest(url:  NSURL(string: url)! as URL)
                             
                             // Your request method type Get or post etc according to your requirement
                             request.httpMethod = "POST"
                             
                             request.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
                             request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                             request.httpBody = try! JSONSerialization.data(withJSONObject: parameters )
                             
                        print(parameters)
                             
                            Alamofire.request(request).responseJSON { (responseObject) -> Void in
                                 
                                 print(responseObject)
                                
                                
                                  NetworkManager.sharedInstance.dismissLoader()
                                
                                 SwiftMessages.showToast(NSLocalizedString("Item successfully Added To Cart.", comment: ""))
                                 self.navigationController?.popToRootViewController(animated: true)
                                 
                             }
                    }
                    
                }
            }
            
        }else{
            
            let vc = ProfileViewController.instantiate(fromAppStoryboard: .main)
            vc.tabBarController?.tabBar.isHidden = true
            vc.isCutomPush = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func getNewAuthToken(completionHandler: @escaping ()->()){
        
        if UserDefaults.fetch(key: Defaults.Key.customerToken.rawValue) != nil{
            
            // let userName = Defaults.customerEmail
            //  let password = Defaults.c
            
            let url: String = API_ROOT_DOMAIN + "rest/V1/integration/customer/token"
            var request = URLRequest(url:  NSURL(string: url)! as URL)
            
            
            // Your request method type Get or post etc according to your requirement
            request.httpMethod = "POST"
            
            request.setValue("Bearer \(ADMIN_TOKEN)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let useremail = Defaults.customerEmail
            let password  = UserDefaults.standard.string(forKey: "loginUserPassword")
            let parameters = [
                "username": useremail,
                "password": password
            ]
            
            print(useremail! + password!)
            
            request.httpBody = try! JSONSerialization.data(withJSONObject: parameters )
            
            Alamofire.request(request).responseJSON { (response) -> Void in
                
                if let value = response.value, value is String {
                    let token = value as! String
                    print(token)
                    UserDefaults.standard.set(true, forKey: "isLogined")
                    UserDefaults.standard.set(token, forKey: "USERTOKEN")
                    completionHandler()
                }
                
            }
            
        }
    }
    
    
}

extension CustomDisplayViewController: UIScrollViewDelegate {
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.ImgDisplay
    }
    
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        if scrollView.zoomScale > scrollView.maximumZoomScale {
//            scrollView.zoomScale = scrollView.maximumZoomScale
//        } else if scrollView.zoomScale < scrollView.minimumZoomScale {
//            scrollView.zoomScale = scrollView.minimumZoomScale
//        }
//    }
}

extension UIView {
    func snapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
  
}

extension UIScrollView {

    var snapshotVisibleArea: UIImage? {
        UIGraphicsBeginImageContext(bounds.size)
        UIGraphicsGetCurrentContext()?.translateBy(x: -contentOffset.x, y: -contentOffset.y)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}


extension UIView {

    var safeAreaBottom: CGFloat {
         if #available(iOS 11, *) {
            if let window = UIApplication.shared.keyWindowInConnectedScenes {
                return window.safeAreaInsets.bottom
            }
         }
         return 0
    }

    var safeAreaTop: CGFloat {
         if #available(iOS 11, *) {
            if let window = UIApplication.shared.keyWindowInConnectedScenes {
                return window.safeAreaInsets.top
            }
         }
         return 0
    }
}


extension UIApplication {
    var keyWindowInConnectedScenes: UIWindow? {
        return windows.first(where: { $0.isKeyWindow })
    }
}
