//
//  ProdesignSubCategoryViewController.swift
//  Skins
//
//  Created by Work on 4/14/20.
//  Copyright © 2020 Work. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


class ProdesignSubCategoryViewController: BaseViewController {

    var subCategories = JSON()
    var subCategoryItem = [ProdesignSubCategoryModel]()
    var noOfItemToBeLoaded = 14
       var noOfItemsAlreadyLoaded = 0
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private func loadMoreImages(){
        
         self.collectionView.reloadData()
     
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.sharedInstance.showLoader()
        self.tabBarController?.tabBar.isHidden = true
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "nlogo (1)-1"))
                        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        self.setTitleView(imageView)
        self.collectionView.register(UINib(nibName: R.Nibs.CollectionViewCell, bundle: nil), forCellWithReuseIdentifier: R.CellIdentifiers.CollectionViewCell)
        
        if let _ = self.subCategories.array {
            
            for item in self.subCategories.arrayValue{
                if let sub = try? JSONDecoder().decode(ProdesignSubCategoryModel.self, from: item.rawData()){
                    self.subCategoryItem.append(sub)
                    print(sub.categoryID)
                   
                    print(sub.id)
                }
                
            }
            if self.subCategoryItem.count < self.noOfItemToBeLoaded {
                                 self.noOfItemToBeLoaded = self.subCategoryItem.count
                             }
            
            
        }

}
    

}


extension ProdesignSubCategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if noOfItemToBeLoaded >= self.noOfItemsAlreadyLoaded {
                       
                 NetworkManager.sharedInstance.showLoader()
                       
                 if (self.noOfItemToBeLoaded + 14) <= self.subCategoryItem.count {
                     self.noOfItemToBeLoaded += 14
                   
                 }else{
                     self.noOfItemToBeLoaded = self.subCategoryItem.count
                 }
                  self.loadMoreImages()
                 
                      
             }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.Nibs.CollectionViewCell, for: indexPath) as! CollectionViewCell
        let cellItem = self.subCategoryItem[indexPath.row]
        
        cell.lblCategory.text = cellItem.name
       // cell.imgCategory.af_setImage(withURL: URL.init(string: MEIDA_URL + cellItem.image)!)
        cell.imgCategory.af_setImage(withURL: URL.init(string: MEIDA_URL + cellItem.image)!) { (response) in
                    
                    self.noOfItemsAlreadyLoaded += 1
                    if self.noOfItemToBeLoaded == self.noOfItemsAlreadyLoaded {
                        
                        NetworkManager.sharedInstance.dismissLoader()
                        
                    }
                }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.subCategoryItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = R.StoryboardRef.Main.instantiateViewController(withIdentifier: R.ViewControllerIds.prodesignListingVC) as! ProdesignListingViewController
        vc.categoryID = Int(self.subCategoryItem[indexPath.row].id)!
       self.navigationController?.pushViewController(vc, animated: true)
               
    }
    
    
}

extension ProdesignSubCategoryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (self.view.width/2)-(2*10), height: 100)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}
