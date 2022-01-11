//
/**
 Mobikul_Magento2V3_App
 @Category Webkul
 @author    Webkul
 Created by: rakesh on 01/09/18
 FileName: ProductTableViewCellLayout2.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license   https://store.webkul.com/license.html
 */

import UIKit

class ProductTableViewCellLayout3: UITableViewCell {
    
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    var carouselCollectionModel: Carousel?
    weak var delegate: MoveController?
    weak var obj: HomeViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewAllButton.setTitle("View All".localized.uppercased(), for: .normal)
        productCollectionView.register(ProductsCollectionViewCell.nib, forCellWithReuseIdentifier: ProductsCollectionViewCell.identifier)
        productCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        productCollectionView.register(ProductLandscapeCollectionViewCell.nib, forCellWithReuseIdentifier: ProductLandscapeCollectionViewCell.identifier)
        viewAllButton.backgroundColor = UIColor(red: 245 / 255.0, green: 245 / 255.0, blue: 245 / 255.0, alpha: 1 / 1.0)
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        productCollectionView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @IBAction func viewAllButtonAction(_ sender: Any) {
        delegate?.moveController(id: self.carouselCollectionModel?.id ?? "", name: self.carouselCollectionModel?.label ?? "", dict: [:], jsonData: JSON.null, type: "customCarousel", controller: AllControllers.productcategory)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension ProductTableViewCellLayout3: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let productList = carouselCollectionModel?.productList else { return 0 }
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsCollectionViewCell.identifier, for: indexPath) as? ProductsCollectionViewCell,
            let productList = carouselCollectionModel?.productList else { return UICollectionViewCell() }
        cell.productList = productList[indexPath.row]
        if productList[indexPath.row].isInWishlist ?? false {
            cell.wishListButton.setImage(UIImage(named: "ic_wishlist_fill"), for: .normal)
        } else {
            cell.wishListButton.setImage(UIImage(named: "ic_wishlist"), for: .normal)
        }
        cell.wishListButton.addTapGestureRecognizer {
            if Defaults.customerToken == nil {
                let customerLoginVC = SignInViewController.instantiate(fromAppStoryboard: .customer)
                let nav = UINavigationController(rootViewController: customerLoginVC)
                //nav.navigationBar.tintColor = AppStaticColors.accentColor
                nav.modalPresentationStyle = .fullScreen
                self.viewContainingController?.present(nav, animated: true, completion: nil)
            } else {
                if productList[indexPath.row].isInWishlist ?? false {
                    self.wishlistAction(productId: productList[indexPath.row].wishlistItemId, added: true, apiType: "delete", completion: { string in
                        productList[indexPath.row].addItemId(wishlistItemId: "")
                        productList[indexPath.row].wishlistStatus(isInWishlist: false)
                        cell.wishListButton.setImage(UIImage(named: "ic_wishlist"), for: .normal)
                    })
                } else {
                    self.wishlistAction(productId: productList[indexPath.row].entityId, added: false, apiType: "", completion: { string in
                        productList[indexPath.row].isInWishlist = true
                        productList[indexPath.row].wishlistStatus(isInWishlist: true)
                        productList[indexPath.row].addItemId(wishlistItemId: string)
                        cell.wishListButton.setImage(UIImage(named: "ic_wishlist_fill"), for: .normal)
                    })
                }
            }
        }
        cell.layoutSubviews()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2 - 0.5, height: collectionView.frame.size.width/2 + 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let productList = carouselCollectionModel?.productList {
            let viewController = ProductPageDataViewController.instantiate(fromAppStoryboard: .product)
            viewController.productId = productList[indexPath.row].entityId
            self.viewContainingController?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func wishlistAction(productId: String, added: Bool, apiType: String, completion: @escaping ( (String) -> Void )) {
        obj?.callingHttppApi(productId: productId, apiType: apiType, completion: {  success, jsonResponse in
            if success {
                completion(jsonResponse["itemId"].stringValue)
            }
        })
    }
}
