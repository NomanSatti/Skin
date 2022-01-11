//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: NewsLaterCheckTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class NewsLaterCheckTableViewCell: UITableViewCell {
    @IBOutlet weak var onOffSwitchBtn: UISwitch!
    @IBOutlet weak var newsLetterLbl: UILabel!
    @IBOutlet weak var newsLetterView: UIView!
    weak var delegate: NesLaterClick?
    override func awakeFromNib() {
        super.awakeFromNib()
        newsLetterLbl.text = "Receive Newsletters".localized
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func nesLatterBtncheckAct(_ sender: Any) {
        if onOffSwitchBtn.isOn {
            delegate?.newLetterCheck(check: true)
        } else {
            delegate?.newLetterCheck(check: false)
        }
        
    }
}
