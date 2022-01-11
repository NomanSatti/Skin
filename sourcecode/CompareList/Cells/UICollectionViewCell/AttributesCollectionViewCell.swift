//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: AttributesCollectionViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class AttributesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var attributeVal: UILabel!
    
    var val: String? {
        didSet {
            attributeVal.text = val?.html2String
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
