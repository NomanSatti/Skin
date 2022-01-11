//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: ClearSearchHistoryTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class ClearSearchHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var changeSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func switchAction(_ sender: UISwitch) {
        if sender.isOn {
            Defaults.searchEnable = "1"
        } else {
            Defaults.searchEnable = "0"
        }
    }
}
