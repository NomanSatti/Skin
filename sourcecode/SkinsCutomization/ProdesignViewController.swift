//
//  ProdesignViewController.swift
//  Skins
//
//  Created by Work on 2/16/20.
//  Copyright © 2020 Work. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON


class ProdesignViewController: BaseViewController {
    
    
    @IBOutlet weak var cartBtn: BadgeBarButtonItem!
    @IBOutlet weak var categoryView: UIView!
    
    @IBOutlet weak var uploadButton: UIButton!
    
    var noOfItemToBeLoaded = 14
    var noOfItemsAlreadyLoaded = 0
    
    var categoryInt: Int = 0
    var categoryData: JSON = JSON()
    var categoryObject: JSON!
    
    
    
    
    lazy var prodesignCategoryCollectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        return flowLayout
    }()
    
    lazy var prodesignCategoryCollectionView: UICollectionView = {
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.prodesignCategoryCollectionViewFlowLayout)
        
        return view
        
    }()
    
    override func viewWillAppear(_ animated: Bool) {
          self.tabBarController?.tabBar.isHidden = false
        cartBtn.badgeNumber = Int(Defaults.cartBadge) ?? 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
          self.tabBarController?.tabBar.isHidden = false
    }
    
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
       
       
       
    
    
    private func loadMoreImages(){
        
        self.prodesignCategoryCollectionView.reloadData()
        
    }
    
    override func viewDidLoad() {
        
        
         self.view.addSubview(categoryView)
         self.categoryView.backgroundColor = UIColor.black
         self.categoryView.snp.makeConstraints { (make) in
             make.top.equalTo(self.uploadButton.snp.bottom).offset(10)
             make.leading.equalTo(self.uploadButton.snp.leading)
             make.trailing.equalTo(self.uploadButton.snp.trailing)
             make.bottom.equalTo(self.view.snp.bottom).offset(-self.view.safeAreaInsets.bottom)
         }
         
         self.categoryView.addSubview(self.prodesignCategoryCollectionView)
         
         self.prodesignCategoryCollectionView.snp.makeConstraints { (make) in
             make.top.equalTo(self.categoryView.snp.top)
             make.leading.equalTo(self.categoryView.snp.leading)
             make.trailing.equalTo(self.categoryView.snp.trailing)
             make.bottom.equalTo(self.categoryView.snp.bottom)
         }
         
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "nlogo (1)-1"))
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        self.setTitleView(imageView, showBackButton: false)
        
        self.prodesignCategoryCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        // self.showRightNavigationBarButtonsWithImage(["cart_icon","search", "account"])
        
        self.uploadButton.layer.masksToBounds = true
        self.uploadButton.layer.cornerRadius = 10.0
        
        //self.baseDelegate = self
        
        prodesignCategoryCollectionView.dataSource = self
        prodesignCategoryCollectionView.delegate = self
        
        // API CALLING
        
        self.getAllWallpaperCategories()
        
        
    }
    
    
    /*func rightPrimaryNavigationBarButtonClicked(_ sender: UIButton) {
     
     if UserDefaults.standard.bool(forKey: "isLogined"){
     
     let vc = R.StoryboardRef.Main.instantiateViewController(withIdentifier: R.ViewControllerIds.MyProfileVC) as! MyProfileViewController
     self.navigationController?.pushViewController(vc, animated: true)
     } else {
     let vc = R.StoryboardRef.Main.instantiateViewController(withIdentifier: R.ViewControllerIds.LoginVC) as! LogInViewController
     self.navigationController?.pushViewController(vc, animated: true)
     }
     }
     
     func rightSecondaryNavigationBarButtonClicked(_ sender: UIButton) {
     let vc = R.StoryboardRef.Main.instantiateViewController(withIdentifier: R.ViewControllerIds.SearchVC) as! SearchViewController
     self.navigationController?.pushViewController(vc, animated: true)
     }
     
     func rightThirdNavigationBarButtonClicked(_ sender: UIButton) {
     
     let vc = R.StoryboardRef.Main.instantiateViewController(withIdentifier: R.ViewControllerIds.cartVC) as! CartViewController
     self.navigationController?.pushViewController(vc, animated: true)
     
     }*/
    
}





extension ProdesignViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (self.categoryView.width/2)-(2*10), height: 74)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
    }
}


extension ProdesignViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        print(self.categoryData.count)
        return self.categoryData.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        let menuItem = self.categoryData[indexPath.row]
        
        cell.lblCategory.text = menuItem["name"].stringValue
        
        if let menuItemImage = menuItem["image"].string {
            // cell.imgCategory.af_setImage(withURL: URL.init(string: MEIDA_URL + menuItemImage)!)
            cell.imgCategory.af_setImage(withURL: URL.init(string: MEIDA_URL + menuItemImage)!) { (response) in
                
                self.noOfItemsAlreadyLoaded += 1
                if self.noOfItemToBeLoaded == self.noOfItemsAlreadyLoaded {
                    
                    NetworkManager.sharedInstance.dismissLoader()
                    
                }
            }
            print(MEIDA_URL + menuItemImage)
        }
        
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = R.StoryboardRef.Main.instantiateViewController(withIdentifier: R.ViewControllerIds.prodesignSubVC) as! ProdesignSubCategoryViewController
        
        if let _ = self.categoryData.array{
            let items = self.categoryData.arrayValue
            let selectedItem = items[indexPath.row]
            let sub = selectedItem["sub"]
            vc.subCategories = sub
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        //let sub = self.categoryData
        
        
    }
    
    
}


extension ProdesignViewController {
    
    private func getAllWallpaperCategories(){
        NetworkManager.sharedInstance.showLoader()
        let url: String = API_ROOT_DOMAIN + "rest/V1/wallpaper/get-predesigned-categories"
        var request = URLRequest(url:  NSURL(string: url)! as URL)
        
        // Your request method type Get or post etc according to your requirement
        request.httpMethod = "GET"
        
        request.setValue("Bearer \(ADMIN_TOKEN)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        Alamofire.request(request).responseJSON { (responseObject) -> Void in
            
            if let data =  responseObject.result.value {
                print(JSON(data))
                if let json = JSON(data).array?.first{
                    let response = json["response"]
                    let data = response["data"]
                    self.categoryData = data
                    if self.categoryData.count < self.noOfItemToBeLoaded {
                        self.noOfItemToBeLoaded = self.categoryData.count
                    }
                    print(response["data"].count)
                    self.prodesignCategoryCollectionView.reloadData()
                }
            }
            
        }
        
        
        
    }
    
}


extension ProdesignViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
