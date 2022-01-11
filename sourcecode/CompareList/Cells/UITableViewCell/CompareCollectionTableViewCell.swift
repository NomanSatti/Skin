//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: CompareCollectionTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class CompareCollectionTableViewCell: UITableViewCell {
    
    weak var obj: CompareListViewModel?
    @IBOutlet weak var compareCollView: UICollectionView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    var isProduct = false
    var storedOffsets = [Int: CGFloat]()
    var sectionIndex: Int!
    var compareListDataModel: CompareListDataModel!
    weak var delegate: MoveController?
    
    var productData: [CompareProductList]! {
        didSet {
            setCollectionViewDataSourceDelegate(self, forRow: compareCollView.tag)
            collectionViewOffset = storedOffsets[compareCollView.tag] ?? 0
        }
    }
    var attributeData = [CompareAttributeValueList]()
    
    var collectionViewOffset: CGFloat {
        set { compareCollView.contentOffset.x = newValue }
        get { return compareCollView.contentOffset.x }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        compareCollView.delegate = self
        compareCollView.dataSource = self
        compareCollView.register(ProductCollectionViewCell.nib, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        compareCollView.register(AttributesCollectionViewCell.nib, forCellWithReuseIdentifier: AttributesCollectionViewCell.identifier)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

extension CompareCollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isProduct {
            return (productData?.count)!
        } else {
            return (attributeData[sectionIndex].value?.count)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isProduct {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell {
                cell.removeBtn.tag = indexPath.row
                cell.wishlistBtn.tag = indexPath.row
                cell.productData = productData?[indexPath.row]
                cell.wishlistBtn.addTapGestureRecognizer {
                    if Defaults.customerToken == nil {
                        let customerLoginVC = SignInViewController.instantiate(fromAppStoryboard: .customer)
                        let nav = UINavigationController(rootViewController: customerLoginVC)
                        //nav.navigationBar.tintColor = AppStaticColors.accentColor
                        nav.modalPresentationStyle = .fullScreen
                        self.viewContainingController?.present(nav, animated: true, completion: nil)
                    } else {
                        if self.productData[indexPath.row].isInWishlist ?? false {
                            self.obj?.wishlistItemId = self.productData[indexPath.row].wishlistItemId
                            self.obj?.apiToCall = .removeFromWishlist
                            self.wishlistAction(productId: self.productData[indexPath.row].wishlistItemId, added: true, apiType: "delete", completion: { string in
                                self.productData[indexPath.row].addItemId(wishlistItemId: "")
                                self.productData[indexPath.row].wishlistStatus(isInWishlist: false)
                                cell.wishlistBtn.setImage(UIImage(named: "ic_wishlist"), for: .normal)
                            })
                        } else {
                            self.obj?.productId = self.productData[indexPath.row].entityId
                            self.obj?.apiToCall = .addToWishlist
                            self.wishlistAction(productId: self.productData[indexPath.row].entityId, added: false, apiType: "", completion: { string in
                                self.productData[indexPath.row].isInWishlist = true
                                self.productData[indexPath.row].wishlistStatus(isInWishlist: true)
                                self.productData[indexPath.row].addItemId(wishlistItemId: string)
                                cell.wishlistBtn.setImage(UIImage(named: "ic_wishlist_fill"), for: .normal)
                            })
                        }
                    }
                }
                cell.delegate = self
                return cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttributesCollectionViewCell.identifier, for: indexPath) as? AttributesCollectionViewCell {
                if (attributeData[sectionIndex].value?.count)! > indexPath.row {
                    cell.val = attributeData[sectionIndex].value?[indexPath.row]
                } else {
                    cell.val = ""
                }
                
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isProduct, let productData = productData {
            let nextController = ProductPageDataViewController.instantiate(fromAppStoryboard: .product)
            nextController.productId = productData[indexPath.row].entityId
            nextController.productName = productData[indexPath.row].name
            self.viewContainingController?.navigationController?.pushViewController(nextController, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width/2 - 20, height: 315)
    }
    
    func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        compareCollView.delegate = dataSourceDelegate
        compareCollView.dataSource = dataSourceDelegate
        compareCollView.setContentOffset(compareCollView.contentOffset, animated: false) // Stops collection view if it was scrolling.
        compareCollView.reloadData()
    }
    
    func wishlistAction(productId: String, added: Bool, apiType: String, completion: @escaping ( (String) -> Void )) {
        obj?.callingHttppApi { (success, jsonResponse) in
            print(success)
            if success {
                ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: jsonResponse["message"].stringValue)
                completion(jsonResponse["itemId"].stringValue)
            } else {
                ShowNotificationMessages.sharedInstance.warningView(message: jsonResponse["message"].stringValue)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if compareListDataModel != nil {
            for i in 0..<(compareListDataModel.attributeValueList?.count)! + 1 {
                if let mainView = scrollView.superview?.superview?.superview as? UITableView {
                    let collView = mainView.viewWithTag((i + 1) * 100) as? UICollectionView
                    if collView != nil {
                        if scrollView.contentOffset.y == 0 {
                            collView!.contentOffset = scrollView.contentOffset
                        }
                    }
                }
            }
        }
    }
}

extension CompareCollectionTableViewCell: MoveController {
    func moveController(id: String, name: String, dict: [String: Any], jsonData: JSON, type: String, controller: AllControllers) {
        delegate?.moveController(id: id, name: name, dict: dict, jsonData: jsonData, type: type, controller: controller)
    }
}
