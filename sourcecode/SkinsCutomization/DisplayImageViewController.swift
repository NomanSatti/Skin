//
//  DisplayImageViewController.swift
//  Skins
//
//  Created by Work on 3/20/20.
//  Copyright © 2020 Work. All rights reserved.
//

import UIKit
import SwiftMessages
import SwiftyJSON
import Alamofire


class DisplayImageViewController: UIViewController {
    
    @IBOutlet weak var imgIphone: UIImageView!
    @IBOutlet weak var ImgDisplay: UIImageView!
    @IBOutlet weak var btnOrderNow: UIButton!
    @IBOutlet weak var sgmSkinCase: UISegmentedControl!
    
    
    var wallpaperImage = UIImage()
    var wallpaperDetails = JSON()
    var prdesignWallpaper: ProdesignWallpaperModel?
    
    var wallpaperImages = [UIImage]()
    var loadedWallpapers = [JSON]()
    var swipeGesture  = UISwipeGestureRecognizer()
    
    var isCustomUpload = false
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addSwipeGestureToWallpapers()
        self.imgIphone.isHidden = true
        btnOrderNow.setTitle(NSLocalizedString("Download", comment: ""), for: .normal)
        self.ImgDisplay.image = wallpaperImage
        print(wallpaperDetails)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
          self.tabBarController?.tabBar.isHidden = true
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
          self.tabBarController?.tabBar.isHidden = true
        
    }
    
 
    
    @IBAction func valueDidChange(_ segment: UISegmentedControl) {
        
        
        switch sgmSkinCase.selectedSegmentIndex {
        case 0:
            btnOrderNow.setTitle(NSLocalizedString("Download", comment: ""), for: .normal)
            self.btnOrderNow.tag = 100
            self.imgIphone.isHidden = true
        default:
            let priceText = wallpaperDetails["price"]
            let orderNow = NSLocalizedString("Add To Cart", comment: "")
            let currency = NSLocalizedString("SR", comment: "")
            btnOrderNow.setTitle("\(orderNow) @ \(priceText) \(currency)", for: .normal)
            self.btnOrderNow.tag = 101
            self.imgIphone.isHidden = false //CurrentUser.sharedInstance.appFlowType == .preDesign
        }
    }
    
    @IBAction func btnOrderNowClicked(_ sender: UIButton) {
        
        if sender.tag == 101 {
            self.addToCart()
        } else {
            
            self.imageDownload()
        }
    }
    
    
    func updatePrice(){
        
        if btnOrderNow.titleLabel!.text != "Download" {
            let priceText = wallpaperDetails["price"]
            let orderNow = NSLocalizedString("Add To Cart", comment: "")
            let currency = NSLocalizedString("SR", comment: "")
            btnOrderNow.setTitle("\(orderNow) @ \(priceText) \(currency)", for: .normal)
        }
        
        
    }
    
    private func addToCart(){
        
        let sku = self.wallpaperDetails["sku"].stringValue
        if UserDefaults.fetch(key: Defaults.Key.customerToken.rawValue) != nil{
            OrderProcessManager.getMyCartData { (json) in
                if let cartID = UserDefaults.standard.value(forKey: "cartID") as? Int {
                    
                    let parameters = [
                        "sku": sku,
                        "qty": "1",
                        "quote_id": cartID
                        ] as! [String: Any]
                    
                    if !self.isCustomUpload{
                        let vc = R.StoryboardRef.Main.instantiateViewController(withIdentifier: R.ViewControllerIds.deviceVC) as! SelectDeviceViewController
                        vc.parameters = parameters
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        let vc = R.StoryboardRef.Main.instantiateViewController(withIdentifier: R.ViewControllerIds.deviceVC) as! SelectDeviceViewController
                        vc.parameters = parameters
                        vc.customImage = self.wallpaperImage
                        self.navigationController?.pushViewController(vc, animated: true)
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
    
    private func imageDownload(){
        
        UIImageWriteToSavedPhotosAlbum(self.wallpaperImage, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(image: UIImage!, didFinishSavingWithError error: NSError!, contextInfo: AnyObject!) {
        if (error != nil) {
            SwiftMessages.showToast(error.localizedDescription, type: .error)
        } else {
            SwiftMessages.showToast(NSLocalizedString("Image successfully saved in your photos.", comment: ""))
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}


extension DisplayImageViewController {
    
    func addSwipeGestureToWallpapers(){
        
        let directions: [UISwipeGestureRecognizer.Direction] = [.right, .left]

        for direction in directions {
            swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipwView(_:)))
            self.ImgDisplay.addGestureRecognizer(swipeGesture)
            swipeGesture.direction = direction
            self.ImgDisplay.isUserInteractionEnabled = true
            self.ImgDisplay.isMultipleTouchEnabled = true
        }
    }
    
    @objc func swipwView(_ sender : UISwipeGestureRecognizer){
        UIView.animate(withDuration: 1.0) {
            if sender.direction == .right {
                if (self.selectedIndex + 1) <= (self.loadedWallpapers.count - 1) {
                     self.selectedIndex += 1
                }
               
                self.ImgDisplay.image = self.wallpaperImages[self.selectedIndex]
                self.wallpaperDetails = self.loadedWallpapers[self.selectedIndex]
                self.updatePrice()
            }else if sender.direction == .left{
                
                if (self.selectedIndex - 1) >= 0 {
                      self.selectedIndex -= 1
                }
                
                  self.ImgDisplay.image = self.wallpaperImages[self.selectedIndex]
                  self.wallpaperDetails = self.loadedWallpapers[self.selectedIndex]
                self.updatePrice()
            }
           // self.imageView.layoutIfNeeded()
            //self.imageView.setNeedsDisplay()
        }
    }
    
}
