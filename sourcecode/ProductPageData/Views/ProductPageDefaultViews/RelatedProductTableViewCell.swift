//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: RelatedProductTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit
import Alamofire

class RelatedProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewAllBtn: UIButton!
    @IBOutlet weak var headingLabelClicked: UILabel!
    var relatedList = [RelatedProductList]()
    weak var obj: ProductPageViewModal?
    var tappedWishListIndex: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(ProductsCollectionViewCell.nib, forCellWithReuseIdentifier: ProductsCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        viewAllBtn.setTitle("View All".localized.uppercased(), for: .normal)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func viewAllClicked(_ sender: Any) {
    }
}

extension RelatedProductTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return relatedList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsCollectionViewCell.identifier, for: indexPath) as? ProductsCollectionViewCell {
            cell.relatedProduct = relatedList[indexPath.row] as RelatedProductList
            cell.wishListButton.addTapGestureRecognizer {
                self.tappedWishListIndex = indexPath.row
                if Defaults.customerToken == nil {
                    let customerLoginVC = SignInViewController.instantiate(fromAppStoryboard: .customer)
                    let nav = UINavigationController(rootViewController: customerLoginVC)
                    //nav.navigationBar.tintColor = AppStaticColors.accentColor
                    nav.modalPresentationStyle = .fullScreen
                    self.viewContainingController?.present(nav, animated: true, completion: nil)
                } else {
                    if self.relatedList[indexPath.row].isInWishlist ?? false {
                        self.obj?.itemId = self.relatedList[indexPath.row].wishlistItemId
                        self.obj?.whichApiCall = .removeWishlist
                        self.wishlistAction(productId: self.relatedList[indexPath.row].wishlistItemId, added: true, apiType: "delete", completion: { string in
                            
                            self.relatedList[indexPath.row].addItemId(wishlistItemId: "")
                            self.relatedList[indexPath.row].wishlistStatus(isInWishlist: false)
                            cell.wishListButton.setImage(UIImage(named: "ic_wishlist"), for: .normal)
                        })
                    } else {
                        self.obj?.wishlistProductId = self.relatedList[indexPath.row].entityId
                        self.obj?.whichApiCall = .addToWishlist
                        self.wishlistAction(productId: self.relatedList[indexPath.row].entityId, added: false, apiType: "", completion: { string in
                            
                            self.relatedList[indexPath.row].isInWishlist = true
                            self.relatedList[indexPath.row].wishlistStatus(isInWishlist: true)
                            self.relatedList[indexPath.row].addItemId(wishlistItemId: self.obj?.itemId ?? "")
                            cell.wishListButton.setImage(UIImage(named: "ic_wishlist_fill"), for: .normal)
                        })
                    }
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func wishlistAction(productId: String, added: Bool, apiType: String, completion: @escaping ( (Bool) -> Void )) {
        
        if let obj = self.obj {
            obj.callingHttppApi { (success) in
                print(success)
                completion(success)
            }
        } else {
            if added {
                callingHttppApi(apiName: .removeFromWishList) { (data) in
                    print(data)
                }
            } else {
                callingHttppApi(apiName: .addToWishlist) { (data) in
                    print(data)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2.5, height: collectionView.frame.size.height - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = ProductPageDataViewController.instantiate(fromAppStoryboard: .product)
        viewController.productId = relatedList[indexPath.row].entityId
        self.viewContainingController?.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension RelatedProductTableViewCell {
    
    func callingHttppApi(apiName: WhichApiCall, completion: @escaping (Bool) -> Void) {
        var verbs: HTTPMethod = .get
        var requstParams = [String: Any]()
        requstParams["storeId"] = Defaults.storeId
        requstParams["width"] = UrlParams.width
        requstParams["quoteId"] = Defaults.quoteId
        requstParams["customerToken"] = Defaults.customerToken
        requstParams["productId"] = self.relatedList[self.tappedWishListIndex].entityId
        switch apiName {
        case .addToWishlist:
            NetworkManager.sharedInstance.showLoader()
            verbs = .post
        case .removeFromWishList:
            NetworkManager.sharedInstance.showLoader()
            requstParams["itemId"] = self.relatedList[self.tappedWishListIndex].wishlistItemId
            verbs = .delete
        default:
            break
        }
        
        
        requstParams["eTag"] = DBManager.sharedInstance.geteTagFromDataBase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "productPageData"))
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: verbs, apiname: apiName, currentView: UIViewController()) { [weak self] success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            if success == 1 {
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                if jsonResponse["success"].boolValue == true {
                    if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]) {
                        DBManager.sharedInstance.storeDataToDataBase(data: data, eTag: jsonResponse["eTag"].stringValue, hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "productPageData"))
                    }
                    self?.doFurtherProcessingWithResult(apiName: apiName, data: jsonResponse) { success in
                        completion(success)
                    }
                } else {
                    if jsonResponse["message"].stringValue.removeWhiteSpace.count > 0 {
                        ShowNotificationMessages.sharedInstance.warningView(message: jsonResponse["message"].stringValue)
                    } else {
                        ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
                    }
                }
            } else if success == 2 {   // Retry in case of error
                NetworkManager.sharedInstance.dismissLoader()
                self?.callingHttppApi(apiName: apiName) {success in
                    completion(success)
                }
            } else if success == 3 {   // No Changes
                let jsonResponse =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "productPageData"))
                self?.doFurtherProcessingWithResult(apiName: apiName, data: jsonResponse) { success in
                    completion(success)
                }
                
            }
        }
    }
    
    func doFurtherProcessingWithResult(apiName: WhichApiCall,data: JSON, completion: (Bool) -> Void) {
        switch apiName {
        case .addToWishlist:
            print(data)
            if data["success"].boolValue {
                let message = data["message"].stringValue.count > 0 ?  data["message"].stringValue : "Product added to wishlist".localized
                ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: message )
                self.relatedList[self.tappedWishListIndex].wishlistItemId = data["itemId"].stringValue
                self.relatedList[self.tappedWishListIndex].isInWishlist = true
                self.collectionView.reloadData()
            } else {
                ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
            }
        case .removeFromWishList:
            print(data)
            if data["success"].boolValue {
                let message = data["message"].stringValue.count > 0 ?  data["message"].stringValue : "Product deleted from wishlist".localized
                ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: message )
                self.relatedList[self.tappedWishListIndex].wishlistItemId = ""
                self.relatedList[self.tappedWishListIndex].isInWishlist = false
                self.collectionView.reloadData()
            } else {
                ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
            }
        default:
            break
        }
        
        completion(true)
    }
}
