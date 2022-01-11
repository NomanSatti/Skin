//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: DownloadProductListTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class DownloadProductListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var statusWidth: NSLayoutConstraint!
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var downloadBtn: UIButton!
    @IBOutlet weak var remainingLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        downloadBtn.applyBorder(colours: UIColor(named: "LabelColor")!)
        downloadBtn.setTitle("Download".localized.uppercased(), for: .normal)
        
        if Defaults.language == "ar" {
            downloadBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        }
        arrow.image = arrow.image?.flipImage()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func downloadClicked(_ sender: Any) {
    }
    
    var item: DownloadsList! {
        didSet {
            orderIdLabel.text = "#" + item.incrementId
            remainingLabel.text = "Remaining Downloads".localized + " - " + item.remainingDownloads
            dateLabel.text = item.date
            statusLabel.text = item.status
            statusWidth.constant = (statusLabel.text?.widthOfString(usingFont: UIFont.boldSystemFont(ofSize: 14)))! + 20
            statusLabel.backgroundColor = UIColor().hexToColor(hexString: item.statusColorCode)
            productNameLabel.text = item.proName
        }
    }
    
}
