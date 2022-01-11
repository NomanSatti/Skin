//
/**
 Mobikul_Magento2V3_App
 @Category Webkul
 @author    Webkul
 Created by: rakesh on 18/07/18
 FileName: ImageCarouselTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license   https://store.webkul.com/license.html
 */

import UIKit

@objc protocol ImageCarouselControllerHandlerDelegate: class {
    func imageCarouselProductClick(type: String, image: String, imageId: String, title: String)
}

class ImageCarouselTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleTextlabel: UILabel!
    @IBOutlet weak var imageCarouselCollectionView: UICollectionView!
    @IBOutlet weak var pageController: CHIPageControlFresno!
    
    weak var delegate: ImageCarouselControllerHandlerDelegate?
    var title: String!
    var imageCarouselCollectionModel = [Banners]()
    var timer: Timer?
    var item = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleTextlabel.textColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.86 / 1.0)
        imageCarouselCollectionView.register(UINib(nibName: "BannerImageCell", bundle: nil), forCellWithReuseIdentifier: "bannerImageCell")
        imageCarouselCollectionView.delegate = self
        imageCarouselCollectionView.dataSource = self
        imageCarouselCollectionView.reloadData()
        pageController.radius = 4
        pageController.tintColor = .white
        pageController.borderWidth = 1
        pageController.layer.borderColor = UIColor.white.cgColor
        pageController.currentPageTintColor = AppStaticColors.accentColor
        pageController.tintColor = AppStaticColors.accentColor
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (_) in
            if self.imageCarouselCollectionModel.count > 0 {
                if self.imageCarouselCollectionModel.count > self.item {
                    self.imageCarouselCollectionView.scrollToItem(at: IndexPath(item: self.item, section: 0), at: .left, animated: true)
                } else {
                    self.item = 0
                    self.imageCarouselCollectionView.scrollToItem(at: IndexPath(item: self.item, section: 0), at: .left, animated: true)
                }
                self.pageController?.set(progress: self.item, animated: true)
                self.item += 1
            }
        })
    }
    
    deinit {
        timer?.invalidate()
    }
    
    override func layoutSubviews() {
        
    }
}

extension ImageCarouselTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageController.numberOfPages = imageCarouselCollectionModel.count
        return imageCarouselCollectionModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerImageCell", for: indexPath) as? BannerImageCell {
            cell.item = imageCarouselCollectionModel[indexPath.row]
            cell.layoutIfNeeded()
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width-30, height: 2*AppDimensions.screenWidth/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageCarousel = self.imageCarouselCollectionModel[indexPath.row]
        if imageCarousel.bannerType == "category"{
            let nextController = CategoryProductsViewController.instantiate(fromAppStoryboard: .product)
            nextController.categoryId = imageCarousel.id
            nextController.categoryType = ""
            nextController.titleName = imageCarousel.categoryName
            self.viewContainingController?.navigationController?.pushViewController(nextController, animated: true)
        } else {
            let nextController = ProductPageDataViewController.instantiate(fromAppStoryboard: .product)
            nextController.productId = imageCarousel.id
            nextController.productName = imageCarousel.productName
            self.viewContainingController?.navigationController?.pushViewController(nextController, animated: true)
        }
    }
}
