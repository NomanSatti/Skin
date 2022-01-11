//
//  ProdesignListingViewController.swift
//  Skins
//
//  Created by Work on 4/14/20.
//  Copyright © 2020 Work. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftMessages

class ProdesignListingViewController: BaseViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var categoryID: Int?
    var wallpapers = [ProdesignWallpaperModel]()
    var jsonWallpapers = [JSON]()
    var noOfItemToBeLoaded = 14
    var noOfItemsAlreadyLoaded = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        let imageView = UIImageView(image: #imageLiteral(resourceName: "nlogo (1)-1"))
                        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        self.setTitleView(imageView)
        self.collectionView.register(UINib(nibName: R.Nibs.CollectionViewCell, bundle: nil), forCellWithReuseIdentifier: R.CellIdentifiers.CollectionViewCell)
        
        if let _ =  self.categoryID {
            self.getProdesignListing()
        }
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self

    }
    
    private func loadMoreImages(){
         
          self.collectionView.reloadData()
      
      }
    
    private func getProdesignListing(){
              NetworkManager.sharedInstance.showLoader()
        let url: String = API_ROOT_DOMAIN + "rest/V1/wallpaper/get-images?type=prodesigned&category_id=\(self.categoryID!)"
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
                        if let items = data.array {
                            for item in items {
                                print(item)
                                if let wallpaper = try? JSONDecoder().decode(ProdesignWallpaperModel.self, from: item.rawData()){
                                    
                                    self.wallpapers.append(wallpaper)
                                    self.jsonWallpapers.append(item)
                                }
                            }
                            if self.jsonWallpapers.count < self.noOfItemToBeLoaded {
                                                   self.noOfItemToBeLoaded = self.jsonWallpapers.count
                                               }
                            self.collectionView.reloadData()
                        }
                      }
                  }
                  
              }
    }
    
    
 
}


extension ProdesignListingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print(wallpapers.count)
        return wallpapers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.Nibs.CollectionViewCell, for: indexPath) as! CollectionViewCell
             let cellItem = self.wallpapers[indexPath.row]
             
        cell.lblCategory.text = cellItem.prodesignWallpaperModelDescription
        //cell.imgCategory.af_setImage(withURL: URL.init(string: MEIDA_URL + cellItem.filePath)!)
      
        print(MEIDA_URL + cellItem.filePath)
        
             cell.imgCategory.af_setImage(withURL: URL.init(string: MEIDA_URL + cellItem.filePath)!) { (response) in
                       
                       self.noOfItemsAlreadyLoaded += 1
                       if self.noOfItemToBeLoaded == self.noOfItemsAlreadyLoaded {
                           NetworkManager.sharedInstance.dismissLoader()
                       }
                   }
             return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = R.StoryboardRef.Main.instantiateViewController(withIdentifier: R.ViewControllerIds.DisplayImageVC) as! DisplayImageViewController
        let menuItems = self.wallpapers[indexPath.row]
        let selectedCell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        
        if selectedCell.imgCategory.image != nil {
            vc.wallpaperImage = selectedCell.imgCategory.image!
            vc.wallpaperDetails = self.jsonWallpapers[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if noOfItemToBeLoaded >= self.noOfItemsAlreadyLoaded {
            
            NetworkManager.sharedInstance.showLoader()
            
            if (self.noOfItemToBeLoaded + 14) <= self.jsonWallpapers.count {
                self.noOfItemToBeLoaded += 14
                
            }else{
                self.noOfItemToBeLoaded = self.jsonWallpapers.count
            }
            self.loadMoreImages()
            
            
        }
    }
    
}


extension ProdesignListingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (self.view.width/2)-(2*10), height: 100)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}
