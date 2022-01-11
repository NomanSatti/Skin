//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: ConfigurableProductTextCollectionViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class ConfigurableProductTextCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var btnLabel: UIButton!
    @IBOutlet weak var diagnalLine: DiagonalLine!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func btnClicked(_ sender: Any) {
    }
}
