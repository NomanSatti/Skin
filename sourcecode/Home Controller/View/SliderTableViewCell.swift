//
//  SliderTableViewCell.swift
//  Mobikul Single App
//
//  Created by akash on 04/01/20.
//  Copyright © 2020 Webkul. All rights reserved.
//

import UIKit

class SliderTableViewCell: UITableViewCell {

    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var pageController: CHIPageControlFresno!
    
    var bannerCollectionModel = [BannerImages]()
    var timer: Timer?
    var item = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        sliderCollectionView.register(cellType: SliderImageCollectionViewCell.self)
        sliderCollectionView.delegate = self
        sliderCollectionView.dataSource = self
        pageController.radius = 4
        pageController.tintColor = .white
        pageController.borderWidth = 1
        pageController.layer.borderColor = UIColor.white.cgColor
        pageController.currentPageTintColor = AppStaticColors.accentColor
        pageController.tintColor = AppStaticColors.accentColor
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (_) in
            if self.bannerCollectionModel.count > 0 {
                if self.bannerCollectionModel.count > self.item {
                    self.sliderCollectionView.scrollToItem(at: IndexPath(item: self.item, section: 0), at: .centeredHorizontally, animated: true)
                } else {
                    self.item = 0
                    self.sliderCollectionView.scrollToItem(at: IndexPath(item: self.item, section: 0), at: .centeredHorizontally, animated: true)
                }
                self.item += 1
            }
        })
    }

    deinit {
        timer?.invalidate()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension SliderTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageController.numberOfPages = bannerCollectionModel.count
        return bannerCollectionModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderImageCollectionViewCell", for: indexPath) as? SliderImageCollectionViewCell {
            cell.sliderImg.setImage(fromURL: bannerCollectionModel[indexPath.row].url, dominantColor: bannerCollectionModel[indexPath.row].dominantColor)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: AppDimensions.screenWidth, height: 2*AppDimensions.screenWidth/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if bannerCollectionModel[indexPath.row].bannerType == "category"{
            let nextController = CategoryProductsViewController.instantiate(fromAppStoryboard: .product)
            nextController.categoryId = bannerCollectionModel[indexPath.row].id
            nextController.titleName = bannerCollectionModel[indexPath.row].categoryName
            nextController.categoryType = ""
            nextController.titleName = bannerCollectionModel[indexPath.row].categoryName
            self.viewContainingController?.navigationController?.pushViewController(nextController, animated: true)
        } else {
            let nextController = ProductPageDataViewController.instantiate(fromAppStoryboard: .product)
            nextController.productId = bannerCollectionModel[indexPath.row].id
            nextController.productName = bannerCollectionModel[indexPath.row].productName
            self.viewContainingController?.navigationController?.pushViewController(nextController, animated: true)
        }
        
    }
    
}

extension SliderTableViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageController?.set(progress: Int(scrollView.contentOffset.x / AppDimensions.screenWidth), animated: true)
    }
}
