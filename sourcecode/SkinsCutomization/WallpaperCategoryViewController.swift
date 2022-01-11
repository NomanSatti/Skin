//
//  ViewController.swift
//  Skins
//
//  Created by Work on 2/16/20.
//  Copyright © 2020 Work. All rights reserved.
//

import UIKit
import Alamofire
//import SwiftMessages
import SnapKit
//import SwiftyJSON


class WallpaperCategoryViewController: BaseViewController {


    @IBOutlet weak var cartBtn: BadgeBarButtonItem!
    @IBOutlet weak var uploadButton: UIButton!
    
    @IBOutlet weak var categoryView: UIView!
    
    
    var categoryInt: Int = 0
    var categoryData: JSON = JSON()
    var categoryObject: JSON!
    var noOfItemToBeLoaded = 14
    var noOfItemsAlreadyLoaded = 0
    var adsImage: AdsImage?
    
    
    private func loadMoreImages(){
       
        self.wallpaperCategoryCollectionView.reloadData()
    
    }
    
    func setupAdvertisementBanner(completionHandler: @escaping () -> ()){
      
        let url: String = API_ROOT_DOMAIN + "rest/V1/get-advertisements"
              var request = URLRequest(url:  NSURL(string: url)! as URL)

              // Your request method type Get or post etc according to your requirement
              request.httpMethod = "GET"

              request.setValue("Bearer \(ADMIN_TOKEN)", forHTTPHeaderField: "Authorization")
              request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        
              Alamofire.request(request).responseJSON { (responseObject) -> Void in
                
                let json = JSON(responseObject.result.value)
               
                print(json)
                
                
                if let first = json.arrayValue.first{
                    
                    let response = first["response"]
                    
                    let data = response["data"]
                    
                    if let ads = data["advertisement"].array {
                        if let first = ads.first {
                            if let new = try? JSONDecoder().decode(AdsImage.self, from: first.rawData()){
                                self.adsImage = new
                            }
                        }
                        completionHandler()
                    }
                }
    
            }
            
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        cartBtn.badgeNumber = Int(Defaults.cartBadge) ?? 0
        
        OrderProcessManager.getMyCartData { (json) in
            
            if json != nil{
                if json!["items"].arrayValue.count > 0 {
                    self.cartBtn.badgeNumber = json!["items"].arrayValue.count
                }
            }else{
                self.cartBtn.badgeNumber = Int(Defaults.cartBadge) ?? 0
            }
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
          self.tabBarController?.tabBar.isHidden = false
    }
    
    lazy var wallpaperCategoryCollectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        return flowLayout
    }()
    
    lazy var wallpaperCategoryCollectionView: UICollectionView = {
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.wallpaperCategoryCollectionViewFlowLayout)
        return view
        
    }()
    
    
    
    @IBAction func uploadButtonPressed(_ sender: UIButton) {
        
        self.showActionSheetForImageInput { [unowned self](imageSource) in
                       
                       let imagePicker = UIImagePickerController()
                       imagePicker.delegate = self
                       
                       switch imageSource {
                       case .camera:
                           imagePicker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera:.photoLibrary;
                           
                       case .imageLibrary:
                           imagePicker.sourceType = .photoLibrary;
                       }
                       
                       self.present(imagePicker, animated: true, completion: nil)
                   }
               
        
        
        
    }
    
    
    
    
    @IBAction func searchClicked(_ sender: UIBarButtonItem) {
        self.tabBarController?.tabBar.isHidden = true
        let viewController = SearchDataViewController.instantiate(fromAppStoryboard: .search)
        //viewController.modalPresentationStyle = .overCurrentContext
       // viewController.categories = self.homeViewModel.categories
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func notificationClicked(_ sender: UIBarButtonItem) {
        self.tabBarController?.tabBar.isHidden = true
        let viewController = NotificationDataViewController.instantiate(fromAppStoryboard: .main)
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    @IBAction func cartClicked(_ sender: UIBarButtonItem) {
        let viewController = CartDataViewController.instantiate(fromAppStoryboard: .product)
        let nav = UINavigationController(rootViewController: viewController)
        //nav.navigationBar.tintColor = AppStaticColors.accentColor
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    
    
    

    override func viewDidLoad() {
        
        self.setupAdvertisementBanner {
            if let url = URL(string: MEIDA_URL + self.adsImage!.banner){
                self.uploadButton?.af_setImage(for: .normal, url: url)
            }
            
        }
        
        self.view.addSubview(categoryView)
        self.categoryView.backgroundColor = UIColor.black
        self.categoryView.snp.makeConstraints { (make) in
            make.top.equalTo(self.uploadButton.snp.bottom).offset(10)
            make.leading.equalTo(self.uploadButton.snp.leading)
            make.trailing.equalTo(self.uploadButton.snp.trailing)
            make.bottom.equalTo(self.view.snp.bottom).offset(-self.view.safeAreaInsets.bottom)
        }
        
        self.categoryView.addSubview(self.wallpaperCategoryCollectionView)
        
        self.wallpaperCategoryCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.categoryView.snp.top)
            make.leading.equalTo(self.categoryView.snp.leading)
            make.trailing.equalTo(self.categoryView.snp.trailing)
            make.bottom.equalTo(self.categoryView.snp.bottom)
        }
        
        
        self.tabBarController?.tabBar.isHidden = false
        
       let imageView = UIImageView(image: #imageLiteral(resourceName: "nlogo (1)-1"))
              imageView.contentMode = UIView.ContentMode.scaleAspectFit
        self.setTitleView(imageView, showBackButton: false)
              
              self.wallpaperCategoryCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
            // self.showRightNavigationBarButtonsWithImage(["cart_icon","search", "account"])
              
              self.uploadButton.layer.masksToBounds = true
              self.uploadButton.layer.cornerRadius = 10.0
              
             // self.baseDelegate = self
        
        wallpaperCategoryCollectionView.dataSource = self
        wallpaperCategoryCollectionView.delegate = self
        
        // API CALLING
        
        self.getAllWallpaperCategories()

    }
}



extension WallpaperCategoryViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if noOfItemToBeLoaded >= self.noOfItemsAlreadyLoaded {
                       
                 NetworkManager.sharedInstance.showLoader()
                       
                 if (self.noOfItemToBeLoaded + 14) <= self.categoryData.count {
                     self.noOfItemToBeLoaded += 14
                   
                 }else{
                     self.noOfItemToBeLoaded = self.categoryData.count
                 }
                  self.loadMoreImages()
                   NetworkManager.sharedInstance.dismissLoader()
        
             }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = R.StoryboardRef.Main.instantiateViewController(withIdentifier: R.ViewControllerIds.AllWallpapersVC) as! AllWallpapersViewController
        vc.selectedCategory = self.categoryData[indexPath.row]
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension WallpaperCategoryViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (self.categoryView.width/2)-(2*10), height: 74)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
    }
}


extension WallpaperCategoryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.noOfItemToBeLoaded //self.categoryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        let menuItem = self.categoryData[indexPath.row]
        
        print(menuItem)
        
        
        
        cell.lblCategory.text = menuItem["name"].stringValue
        
        if let menuItemImage = menuItem["compressed_file"].string {
           
            print(MEIDA_URL + menuItemImage)
            
            
            
            
        cell.imgCategory.af_setImage(withURL: URL.init(string: MEIDA_URL + menuItemImage)!) { (response) in
                     
                     self.noOfItemsAlreadyLoaded += 1
                     if self.noOfItemToBeLoaded == self.noOfItemsAlreadyLoaded {
                         
                         NetworkManager.sharedInstance.dismissLoader()
                         
                     }
                 }
        }
        return cell
    }
    
    
}


extension WallpaperCategoryViewController {
    
    private func getAllWallpaperCategories(){
        NetworkManager.sharedInstance.showLoader()
        let url: String = API_ROOT_DOMAIN + "rest/V1/wallpaper/get-categories?"
          var request = URLRequest(url:  NSURL(string: url)! as URL)

          // Your request method type Get or post etc according to your requirement
          request.httpMethod = "GET"

          request.setValue("Bearer \(ADMIN_TOKEN)", forHTTPHeaderField: "Authorization")
          request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    
          Alamofire.request(request).responseJSON { (responseObject) -> Void in

            if let data =  responseObject.result.value {
                if let json = JSON(data).array?.first{
                    let response = json["response"]
                    self.categoryData = response["data"]
                    if self.categoryData.count < 10 {
                        self.noOfItemToBeLoaded = self.categoryData.count
                    }
                    print(response["data"].count)
                    self.wallpaperCategoryCollectionView.reloadData()
                      NetworkManager.sharedInstance.dismissLoader()
                }
            }
            
        }
        
        
       
    }
    
}
    
    
    
    
    
    extension WallpaperCategoryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    // Local variable inserted by Swift 4.2 migrator.
    let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

            
            if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
                
                
                dismiss(animated: false) {
                    DispatchQueue.main.async {
                        let vc = CustomWallpaperViewController()
                        vc.selectedImage = pickedImage
                        self.navigationController?.pushViewController(vc, animated: false)
                        
                        
                    }
                }
                
                
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            
            dismiss(animated: true, completion: nil)
        }
    }
            
            
            
            // Helper function inserted by Swift 4.2 migrator.
            fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
                return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
            }

            // Helper function inserted by Swift 4.2 migrator.
            fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
                return input.rawValue
            }

extension UIView {
    
    var width:      CGFloat { return self.frame.size.width }
    var height:     CGFloat { return self.frame.size.height }
    var size:       CGSize  { return self.frame.size}
}


