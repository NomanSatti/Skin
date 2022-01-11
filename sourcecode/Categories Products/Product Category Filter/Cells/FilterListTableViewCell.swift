//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: FilterListTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class FilterListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var selectedBtn: UIButton!
    
    var item: LayeredOption? {
        didSet {
            value.text = (item?.label)! + "(" + String(item!.count) + ")"
            //optional because value will always be there either true/ false
            if (item?.isSelected)! {
                selectedBtn.setImage(UIImage(named: "sharp-done-24px"), for: .normal)
            } else {
                selectedBtn.setImage(nil, for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // MARK: - IBAction
    @IBAction func selectedBtnClicked(_ sender: UIButton) {
        if (item?.isSelected)! {
            item?.isSelected = false
            selectedBtn.setImage(nil, for: .normal)
        } else {
            item?.isSelected = true
            selectedBtn.setImage(UIImage(named: "filter_selected"), for: .normal)
        }
    }    
}
