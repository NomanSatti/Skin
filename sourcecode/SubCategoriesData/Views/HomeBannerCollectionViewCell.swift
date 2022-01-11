//
//  HomeBannerCollectionViewCell.swift
//  Odoo application
//
//  Created by vipin sahu on 8/31/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class HomeBannerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bannerImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var item: BannerImage? {
        didSet {
            guard let item = item else {
                return
            }
            bannerImage.contentMode = .scaleAspectFit
            bannerImage.setImage(fromURL: item.url, dominantColor: item.dominantColor)
            
        }
    }
}
