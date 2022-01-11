//
//  CategoryHeaderCollectionReusableView.swift
//  Mobikul Single App
//
//  Created by akash on 11/02/19.
//  Copyright © 2019 kunal. All rights reserved.
//

import UIKit

class CategoryHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var sortFilterGridListView: SortFilterGridListView!
    var categories = [String]()
    var dominantColor: String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        self.categoryCollectionView.register(CategoryBannerCollectionViewCell.nib, forCellWithReuseIdentifier: CategoryBannerCollectionViewCell.identifier)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
    }
}

extension CategoryHeaderCollectionReusableView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryBannerCollectionViewCell.identifier, for: indexPath) as? CategoryBannerCollectionViewCell {
            cell.bannerImageView.setImage(fromURL: self.categories[indexPath.row],dominantColor: dominantColor)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.categoryCollectionView.frame.width, height: 2*self.categoryCollectionView.frame.width/3)
    }
}
