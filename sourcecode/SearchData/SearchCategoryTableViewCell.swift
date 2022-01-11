//
//  SearchCategoryTableViewCell.swift
//  Mobikul Single App
//
//  Created by akash on 08/02/19.
//  Copyright © 2019 kunal. All rights reserved.
//

import UIKit

class SearchCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    var categories = [Categories]()
    weak var delegate: SeachProtocols?
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryCollectionView.register(cellType: SearchCategoryCollectionViewCell.self)
        self.categoryCollectionView.delegate = self
        self.categoryCollectionView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension SearchCategoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return  self.configureCategoryCell(collectionView: collectionView, indexPath: indexPath)
    }
    
    func configureCategoryCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(with: SearchCategoryCollectionViewCell.self, for: indexPath) {
            cell.nameLbl.text = String.init(format: "%@", categories[indexPath.row].name)
            cell.nameLbl.backgroundColor = UIColor.black
            cell.nameLbl.textColor = UIColor.white
            cell.nameLbl.layer.cornerRadius = 22
            cell.nameLbl.layer.masksToBounds = true
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 100
        if width < (String.init(format: "%@", categories[indexPath.row].name)).widthOfString(usingFont: UIFont.boldSystemFont(ofSize: 17)) + 30 {
            width = (String.init(format: "%@", categories[indexPath.row].name)).widthOfString(usingFont: UIFont.boldSystemFont(ofSize: 17)) + 30
        }
        return CGSize(width: width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if categories[indexPath.row].hasChildren {
            delegate?.productFromSubCategory(id: categories[indexPath.row].id, name: categories[indexPath.row].name)
        } else {
            delegate?.productListFromCategory(id: categories[indexPath.row].id, name: categories[indexPath.row].name)
        }
    }
}
