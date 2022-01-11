//
//  CollectionViewCell.swift
//  CaseWallpaper
//
//  Created by Noman on 9/30/18.
//  Copyright © 2018 Noman. All rights reserved.
//

import UIKit
import SnapKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var imgCategory: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imgCategory.contentMode = .scaleAspectFill
        
        self.imgCategory.layer.masksToBounds = true
        self.imgCategory.layer.cornerRadius = 10.0
        
       /* if CurrentUser.sharedInstance.appFlowType == .preDesign {
            self.imgCategory.contentMode = .scaleAspectFit
        } else {
            self.imgCategory.contentMode = .scaleAspectFill
        }*/
    }

}


class SocialCollectionViewCell: UICollectionViewCell{
    
    
    lazy var iconImageView: UIImageView = {
       let view = UIImageView()
        view.image = #imageLiteral(resourceName: "placeholder")
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.white
        return view
    }()
    
    
    override init(frame: CGRect) {
           super.init(frame: frame)

            self.addSubview(iconImageView)
                  
                  self.iconImageView.snp.makeConstraints { (make) in
                      make.top.equalTo(self.snp.top)
                      make.leading.equalTo(self.snp.leading)
                      make.bottom.equalTo(self.snp.bottom)
                      make.trailing.equalTo(self.snp.trailing)
                  }
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       
    }
    
    
    
}
