@objc protocol bannerViewControllerHandlerDelegate: class {
    func bannerProductClick(type: String, image: String, id: String, title: String)
}

import UIKit
import SnapKit


class BannerTableViewCell: UITableViewCell {
    weak var delegate: bannerViewControllerHandlerDelegate?
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    var bannerCollectionModel = [BannerImages]()
    @IBOutlet weak var bannerCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var textTitleLabel: UILabel!
    
    var index: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bannerCollectionViewHeight.constant = AppDimensions.screenWidth/2
        bannerCollectionView.register(UINib(nibName: "BannerImageCell", bundle: nil), forCellWithReuseIdentifier: "bannerImageCell")
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension BannerTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return bannerCollectionModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: BannerImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerImageCell", for: indexPath) as? BannerImageCell {
            cell.bannerItem = bannerCollectionModel[indexPath.row]
            cell.layoutIfNeeded()
            return cell
        } else {
            return UICollectionViewCell()
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: collectionView.frame.size.width, height: 2*AppDimensions.screenWidth/3 - 16)
        return CGSize(width: collectionView.frame.size.width, height: 2*AppDimensions.screenWidth/3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
        return UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0) // top, left, bottom, right
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
            //            delegate?.bannerProductClick(type: bannerCollectionModel[indexPath.row].bannerType!, image: bannerCollectionModel[indexPath.row].url!, id: id, title: bannerCollectionModel[indexPath.row].productName!)
        }
        
    }
    
}


// Customization


class AdvertisementTableViewCell: UITableViewCell {
   // weak var delegate: bannerViewControllerHandlerDelegate?
    
    lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    lazy var adsCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        return view
    }()
    
    var adsCollectionModel = [AdsImage]()
    
    
    lazy var textTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var homeViewController: ViewController?
    
    var index: Int = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        self.addSubview(adsCollectionView)
        
        self.adsCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(5)
            make.leading.equalTo(self.snp.leading).offset(5)
            make.trailing.equalTo(self.snp.trailing).offset(-5)
            make.bottom.equalTo(self.snp.bottom).offset(-5)
        }
        
       // adsCollectionView.frame =  CGRect(x: self.x, y: self.y, width: self.width, height: self.height)
        adsCollectionView.register(AdsImageCell.self, forCellWithReuseIdentifier: "adsImageCell")
        adsCollectionView.delegate = self
        adsCollectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    


            
    
}

extension AdvertisementTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print(self.adsCollectionModel.count)
        
        
        return self.adsCollectionModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "adsImageCell", for: indexPath) as! AdsImageCell
        cell.adItem = self.adsCollectionModel[indexPath.row]
        cell.layoutIfNeeded()
        return cell
    }
    
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            //return CGSize(width: collectionView.frame.size.width, height: 2*AppDimensions.screenWidth/3 - 16)
            return CGSize(width: collectionView.frame.size.width, height: 2*AppDimensions.screenWidth/3)
        }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
        return UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0) // top, left, bottom, right
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.homeViewController?.showActionSheetForImageInput { [unowned self](imageSource) in
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            
            switch imageSource {
            case .camera:
                imagePicker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera:.photoLibrary;
                
            case .imageLibrary:
                imagePicker.sourceType = .photoLibrary;
            }
            
            self.homeViewController?.present(imagePicker, animated: true, completion: nil)
        }
    }
    
}

extension AdvertisementTableViewCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        
        if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            
            
            self.homeViewController?.dismiss(animated: false) {
                DispatchQueue.main.async {
                    let vc = CustomWallpaperViewController()
                    vc.selectedImage = pickedImage
                    self.homeViewController?.navigationController?.pushViewController(vc, animated: false)
                    
                    
                }
            }
            
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.homeViewController?.navigationController?.popToRootViewController(animated: true)
    }
}
        
        
        
        // Helper function inserted by Swift 4.2 migrator.
        fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
            return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
        }

        // Helper function inserted by Swift 4.2 migrator.
        fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
            return input.rawValue
        }
