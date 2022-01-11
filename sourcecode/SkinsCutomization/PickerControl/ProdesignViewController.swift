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


class ProdesignViewController: BaseViewController, BaseViewControllerDelegate {

    
    @IBOutlet weak var categoryView: UIView!
    
    @IBOutlet weak var uploadButton: UIButton!
    
    
    
   var categoryInt: Int = 0
        var categoryData: JSON = JSON()
        var categoryObject: JSON!
        
        
        
        
        lazy var prodesignCategoryCollectionViewFlowLayout: UICollectionViewFlowLayout = {
            let flowLayout = UICollectionViewFlowLayout()
            return flowLayout
        }()
        
        lazy var prodesignCategoryCollectionView: UICollectionView = {
            
            let view = UICollectionView(frame: self.categoryView.bounds, collectionViewLayout: self.prodesignCategoryCollectionViewFlowLayout)

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
    
    
    
        override func viewDidLoad() {
            
            
            self.categoryView.addSubview(self.prodesignCategoryCollectionView)
            
            let imageView = UIImageView(image: #imageLiteral(resourceName: "nlogo (1)-1"))
            imageView.contentMode = UIView.ContentMode.scaleAspectFit
            self.setTitleView(imageView, showBackButton: false)
            
            self.prodesignCategoryCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
            self.showRightNavigationBarButtonsWithImage(["cart_icon","search", "account"])
            
            self.uploadButton.layer.masksToBounds = true
            self.uploadButton.layer.cornerRadius = 10.0
            
            self.baseDelegate = self
            
            prodesignCategoryCollectionView.dataSource = self
            prodesignCategoryCollectionView.delegate = self
            
            // API CALLING
            
            self.getAllWallpaperCategories()
            
            
    }
    
    
       func rightPrimaryNavigationBarButtonClicked(_ sender: UIButton) {
           
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
           
       }
    
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
            
            
            
            return self.categoryData.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            
            let menuItem = self.categoryData[indexPath.row]
            
            cell.lblCategory.text = menuItem["name"].stringValue
            
            if let menuItemImage = menuItem["image"].string {
                cell.imgCategory.af_setImage(withURL: URL.init(string: MEIDA_URL + menuItemImage)!)
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
            
           // CurrentUser.sharedInstance.imageToUpload = pickedImage
            
            dismiss(animated: true, completion: nil)
            
         //   let data = GetIMageResponse.Response.ResponseData(fromDictionary: [:])
         //   data.image = pickedImage.jpegData(compressionQuality: 1.0)
      //      let vc = R.StoryboardRef.Main.instantiateViewController(withIdentifier: R.ViewControllerIds.CustomOrderVC) as! CustomOrderViewController
                //vc.imageData = data
           // self.navigationController?.pushViewController(vc, animated: true)
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
