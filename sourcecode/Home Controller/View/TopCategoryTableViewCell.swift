import UIKit

@objc protocol featureViewControllerHandlerDelegate: class {
    func featureProductClick(name: String, ID: String)
}

class TopCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var titleHeight: NSLayoutConstraint!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    var featureCategoryCollectionModel = [FeaturedCategories]()
    
    weak var delegate: MoveController?
    var themeCode = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryCollectionView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "categorycell")
        categoryCollectionView.register(cellType: CategoryTheme1CollectionViewCell.self)
    }
    
    override func layoutSubviews() {
        if self.themeCode == 1 {
            self.titleLbl.text = "Shop by Categories".localized.uppercased()
            self.titleHeight.constant = 40
        } else {
            self.titleLbl.text = ""
            self.titleHeight.constant = 0
        }
        if featureCategoryCollectionModel.count == 0 {
            collectionViewHeight.constant = 0
        } else {
            categoryCollectionView.delegate = self
            categoryCollectionView.dataSource = self
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
extension TopCategoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return featureCategoryCollectionModel.count
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.themeCode == 1 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryTheme1CollectionViewCell", for: indexPath) as? CategoryTheme1CollectionViewCell {
//                cell.imageView.layer.cornerRadius = cell.imageView.frame.width/2
//                cell.imageView.layer.masksToBounds = true
                cell.imageView.setImage(fromURL: featureCategoryCollectionModel[indexPath.row].url, dominantColor: featureCategoryCollectionModel[indexPath.row].dominantColor)
                cell.imageView.contentMode = .scaleAspectFit
                cell.labelName.text = featureCategoryCollectionModel[indexPath.row].categoryName
//                self.collectionViewHeight.constant = 600 //self.categoryCollectionView.contentSize.height
                return cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categorycell", for: indexPath) as? CategoryCell {
                cell.imageView.setImage(fromURL: featureCategoryCollectionModel[indexPath.row].url, dominantColor: featureCategoryCollectionModel[indexPath.row].dominantColor)
                cell.imageView.contentMode = .scaleAspectFit
                cell.labelName.text = featureCategoryCollectionModel[indexPath.row].categoryName
//                self.collectionViewHeight.constant = 600//self.categoryCollectionView.contentSize.height
                return cell
            }
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            return CGSize(width: collectionView.frame.width/2 - 25, height: collectionView.frame.width/2 - 20)

        }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if self.themeCode == 1 {
//            return CGSize(width: 80, height: 100)
//        }
//        return CGSize(width: 180, height: 200)
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("ddd", indexPath.row)
        let featureCategoryCollectionModel = self.featureCategoryCollectionModel[indexPath.row]
        delegate?.moveController(id: featureCategoryCollectionModel.categoryId!, name: featureCategoryCollectionModel.categoryName!, dict: [:], jsonData: JSON.null, type: "category", controller: AllControllers.productcategory)
    }
    
}
