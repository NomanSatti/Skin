//
//  AllWallpapersViewController.swift
//  Skins
//
//  Created by Work on 3/19/20.
//  Copyright © 2020 Work. All rights reserved.
//

import UIKit
import SwiftMessages
import SwiftyJSON
import Alamofire


let API_ROOT_DOMAIN = "https://skin.com.sa/"
let ADMIN_TOKEN = "b6xvn6198k6j1k4hb4r4z75s6tlsab9u"
let MEIDA_URL = "https://skin.com.sa/pub/media/"
let CART_MEDIA_URL = "https://skin.com.sa/pub/media/catalog/product/"

class AllWallpapersViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedCategory: JSON = JSON()
    var allWallpapers: [JSON] = []
//    var noOfItemToBeLoaded = 15
//    var noOfItemsAlreadyLoaded = 0
    var wallpaperImages = [UIImage]()
    var loadedWallpapers = [JSON]()
    
    // Ahtazaz
    var isLoading = false
    var pageNo = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.tabBarController?.tabBar.isHidden = true
        super.viewDidLoad()

               let imageView = UIImageView(image: #imageLiteral(resourceName: "Artboard"))
               imageView.contentMode = UIView.ContentMode.scaleAspectFit
               self.setTitleView(imageView)
               self.collectionView.register(UINib(nibName: R.Nibs.CollectionViewCell, bundle: nil), forCellWithReuseIdentifier: R.CellIdentifiers.CollectionViewCell)
               
              // self.showRightNavigationBarButtonsWithImage(["cart_icon","search", "account"])
             //  self.baseDelegate = self
        //getAllWallpapers()
        getWallpapersByPagination()
    }
 
    
    private func loadMoreImages(){
       
        self.collectionView.reloadData()
    
    }
    
    private func getWallpapersByPagination() {
        
        isLoading = true
        NetworkManager.sharedInstance.showLoader()
        let id = self.selectedCategory["id"]
        pageNo = pageNo + 1
        let url: String = API_ROOT_DOMAIN + "rest/V1/wallpaper/get-images?category_id=\(id)&order_direction=DESC&paginate=true&limit=15&offset=\(pageNo)"
        var request = URLRequest(url:  NSURL(string: url)! as URL)
        
        
        request.httpMethod = "GET"
        
        request.setValue("Bearer \(ADMIN_TOKEN)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        Alamofire.request(request).responseJSON { (responseObject) -> Void in
            
            if let data =  responseObject.result.value {
                
                if let json = JSON(data).array?.first{
                    
                    let response = json["response"]
                    
                    if let items = response["data"].array {
                        for item in items {
                            self.allWallpapers.append(item)
                        }
                    }
                    
                    self.collectionView.reloadData()
                    NetworkManager.sharedInstance.dismissLoader()
                    self.isLoading = false
                } else{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.isLoading = false
                }
            }
            
        }
    }
    
//    private func getAllWallpapers(){
//
//        NetworkManager.sharedInstance.showLoader()
//        let id = self.selectedCategory["id"]
//
//        let url: String = API_ROOT_DOMAIN + "rest/V1/wallpaper/get-images?category_id=\(id)"
//        var request = URLRequest(url:  NSURL(string: url)! as URL)
//
//
//        request.httpMethod = "GET"
//
//        request.setValue("Bearer \(ADMIN_TOKEN)", forHTTPHeaderField: "Authorization")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//
//        Alamofire.request(request).responseJSON { (responseObject) -> Void in
//
//
//
//            if let data =  responseObject.result.value {
//                //print(data)
//                if let json = JSON(data).array?.first{
//
//                    let response = json["response"]
//                    print(response)
//                    self.allWallpapers = response["data"]
//                    if self.allWallpapers.count < self.noOfItemToBeLoaded {
//                        self.noOfItemToBeLoaded = self.allWallpapers.count
//                    }
//                    print(response["data"].count)
//                    self.collectionView.reloadData()
//                      NetworkManager.sharedInstance.dismissLoader()
//                }else{
//                    NetworkManager.sharedInstance.dismissLoader()
//                }
//            }
//            if self.allWallpapers.count == 0 {
//
//                 NetworkManager.sharedInstance.dismissLoader()
//            }
//
//
//        }
//    }
    
}

extension AllWallpapersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.allWallpapers.count //self.allWallpapers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.Nibs.CollectionViewCell, for: indexPath) as! CollectionViewCell
        let cellItem = self.allWallpapers[indexPath.row]
        //compressed_file
        //print(cellItem)
        
        cell.lblCategory.text = cellItem["description"].string
        
        cell.imgCategory.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        cell.imgCategory.kf.setImage(with: URL.init(string: MEIDA_URL + cellItem["compressed_file"].string!))
        
//        //NetworkManager.sharedInstance.showLoader()
//        if let menuItemImage = cellItem["compressed_file"].string {
//            print(MEIDA_URL + menuItemImage)
//
//
//
//            cell.imgCategory.af_setImage(withURL: URL.init(string: MEIDA_URL + menuItemImage)!) { (response) in
//
//                self.noOfItemsAlreadyLoaded += 1
//         //       self.wallpaperImages.append(cell.imgCategory.image!)
//                self.loadedWallpapers.append(self.allWallpapers[indexPath.row])
//                if self.noOfItemToBeLoaded == self.noOfItemsAlreadyLoaded {
//
//                    NetworkManager.sharedInstance.dismissLoader()
//
//                }
//            }
//        }
        
     
        return cell
    }
    

    
    
}


extension AllWallpapersViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = R.StoryboardRef.Main.instantiateViewController(withIdentifier: R.ViewControllerIds.DisplayImageVC) as! DisplayImageViewController
        let menuItems = self.allWallpapers[indexPath.row]
        let selectedCell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        
        if selectedCell.imgCategory.image != nil {
            
            vc.wallpaperImage = selectedCell.imgCategory.image!
            vc.wallpaperDetails = menuItems
            vc.loadedWallpapers = self.loadedWallpapers
            vc.wallpaperImages = self.wallpaperImages
            vc.selectedIndex = indexPath.row
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastData = self.allWallpapers.count - 1
        if !isLoading && indexPath.row == lastData && self.allWallpapers.count == (pageNo * 15) {
//            self.loadData()
            print("Next page + 1====\(pageNo)")
            getWallpapersByPagination()
        }
    }
    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if noOfItemToBeLoaded >= self.noOfItemsAlreadyLoaded {
//
//                 NetworkManager.sharedInstance.showLoader()
//
//                 if (self.noOfItemToBeLoaded + 14) <= self.allWallpapers.count {
//                     self.noOfItemToBeLoaded += 14
//
//                 }else{
//                     self.noOfItemToBeLoaded = self.allWallpapers.count
//                 }
//                  self.loadMoreImages()
//                   NetworkManager.sharedInstance.dismissLoader()
//
//             }
//    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}


extension AllWallpapersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (self.view.width/2)-(2*10), height: 100)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}


/*
extension AllWallpapersViewController: BaseViewControllerDelegate {
    
    func rightPrimaryNavigationBarButtonClicked(_ sender: UIButton) {
        
        
        
        
            if UserDefaults.fetch(key: Defaults.Key.customerToken.rawValue) != nil {

          }
    
    func rightSecondaryNavigationBarButtonClicked(_ sender: UIButton) {
        
        
        
        //let vc = R.StoryboardRef.Main.instantiateViewController(withIdentifier: R.ViewControllerIds.SearchVC) as! SearchViewController
        //self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func rightThirdNavigationBarButtonClicked(_ sender: UIButton) {
        print("hello")
    }
    
}*/
