//
/**
 Mobikul_Magento2V3_App
 @Category Webkul
 @author    Webkul
 Created by: rakesh on 21/07/18
 FileName: ProductTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license   https://store.webkul.com/license.html
 */

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionViewheight: NSLayoutConstraint!
    
    var carouselCollectionModel: Carousel?
    weak var obj: HomeViewModel?
    weak var delegate: MoveController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.86 / 1.0)
        viewAllButton.setTitle("View All".localized.uppercased(), for: .normal)
        viewAllButton.layer.borderWidth = 3.0
        viewAllButton.layer.borderColor = UIColor.black.cgColor
        viewAllButton.setTitleColor(UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 1 / 1.0), for: .normal)
        productCollectionView.register(ProductsCollectionViewCell.nib, forCellWithReuseIdentifier: ProductsCollectionViewCell.identifier)
        productCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionViewheight.constant = 10
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        productCollectionView.reloadData()
    }
    
    @IBAction func viewAllButtonAction(_ sender: Any) {
        delegate?.moveController(id: self.carouselCollectionModel?.id ?? "", name: self.carouselCollectionModel?.label ?? "", dict: [:], jsonData: JSON.null, type: "customCarousel", controller: AllControllers.productcategory)
    }
    
}

extension ProductTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let productList = carouselCollectionModel?.productList else { return 0 }
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsCollectionViewCell.identifier, for: indexPath) as? ProductsCollectionViewCell,
            let productList = carouselCollectionModel?.productList {
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
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2, height: collectionView.frame.size.width/2 + 100)
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
