//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: RecentHorizontalTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */


import UIKit

class RecentHorizontalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    var products = [Productcollection]()
    weak var delegate: MoveController?
    weak var obj: HomeViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewAllButton.setTitle("View All".uppercased().localized, for: .normal)
        productCollectionView.register(ProductsCollectionViewCell.nib, forCellWithReuseIdentifier: ProductsCollectionViewCell.identifier)
        productCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        productCollectionView.register(ProductLandscapeCollectionViewCell.nib, forCellWithReuseIdentifier: ProductLandscapeCollectionViewCell.identifier)
        viewAllButton.backgroundColor = UIColor(red: 245 / 255.0, green: 245 / 255.0, blue: 245 / 255.0, alpha: 1 / 1.0)
        viewAllButton.isHidden = true
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        productCollectionView.reloadData()
        titleNameLabel.text = "Recent Viewed Products".localized.uppercased()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func viewAllButtonAction(_ sender: Any) {
        //        delegate?.moveController(id: self.carouselCollectionModel?.id ?? "", name: self.carouselCollectionModel?.label ?? "", dict: [:], jsonData: JSON.null, type: "customCarousel", controller: AllControllers.productcategory)
    }
    
}

extension RecentHorizontalTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsCollectionViewCell.identifier, for: indexPath) as? ProductsCollectionViewCell else { return UICollectionViewCell() }
        let productList = products
        cell.products = productList[indexPath.row]
        cell.wishListButton.isHidden = true
        cell.layoutSubviews()
        return cell        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2 - 0.5, height: collectionView.frame.size.width/2 + 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = ProductPageDataViewController.instantiate(fromAppStoryboard: .product)
        viewController.productId = products[indexPath.row].productID
        viewController.productName = products[indexPath.row].name
        self.viewContainingController?.navigationController?.pushViewController(viewController, animated: true)
    }
}
