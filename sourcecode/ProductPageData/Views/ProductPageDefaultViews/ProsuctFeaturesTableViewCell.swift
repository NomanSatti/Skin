//
/**
Mobikul Single App
@Category Webkul
@author Webkul <support@webkul.com>
FileName: ProsuctFeaturesTableViewCell.swift
Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
@license https://store.webkul.com/license.html ASL Licence
@link https://store.webkul.com/license.html

*/

import UIKit

class ProsuctFeaturesTableViewCell: UITableViewCell {

    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var heading: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    var item: AdditionalInformation! {
        didSet {
            heading.text = item.label
            value.text = item.value
        }
    }
}
