import UIKit
import Alamofire
import AlamofireImage
import SnapKit

class BannerImageCell: UICollectionViewCell {
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bannerImageView?.clipsToBounds = true
    }
    
    var item: Banners! {
        didSet {
            self.bannerImageView.setImage(fromURL: item.url, dominantColor: item.dominantColor)
            if item.title != "" {
                self.nameLbl.isHidden = false
                self.nameLbl.text = item.title
            } else {
                self.nameLbl.isHidden = true
            }
        }
    }
    
    var bannerItem: BannerImages! {
        didSet {
            self.bannerImageView.setImage(fromURL: bannerItem.url, dominantColor: bannerItem.dominantColor)
            if bannerItem.title != "" {
                self.nameLbl.isHidden = false
                self.nameLbl.text = bannerItem.title
            } else {
                self.nameLbl.isHidden = true
            }
        }
    }
}


class AdsImageCell: UICollectionViewCell {
    
    lazy var adsImageView: UIImageView = {
       let view = UIImageView()
        view.contentMode = .scaleAspectFit
       view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    lazy var nameLbl: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(adsImageView)
        
        self.adsImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        adsImageView.clipsToBounds = true
    }
    
    var item: Ads! {
        didSet {
            guard let url = URL(string: item.url) else {return}
            self.adsImageView.af_setImage(withURL: url)
            if item.title != "" {
                self.nameLbl.isHidden = false
                self.nameLbl.text = item.title
            } else {
                self.nameLbl.isHidden = true
            }
        }
    }
    
    var adItem: AdsImage! {
        didSet {
            
            guard let url = URL(string: MEIDA_URL + adItem.banner) else {return}
                      self.adsImageView.af_setImage(withURL: url)
            //self.bannerImageView.setImage(fromURL: bannerItem.url, dominantColor: bannerItem.dominantColor)
            if adItem.name != "" {
                self.nameLbl.isHidden = false
                self.nameLbl.text = adItem.name
            } else {
                self.nameLbl.isHidden = true
            }
        }
    }
}
