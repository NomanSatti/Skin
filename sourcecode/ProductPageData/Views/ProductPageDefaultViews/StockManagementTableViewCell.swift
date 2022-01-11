//
//  StockManagementTableViewCell.swift
//  Mobikul Single App
//
//  Created by akash on 20/12/19.
//  Copyright © 2019 Webkul. All rights reserved.
//

import UIKit

class StockManagementTableViewCell: UITableViewCell {

    @IBOutlet weak var stockLbl: UILabel!
    @IBOutlet weak var notifyPriceBtn: UIButton!
    @IBOutlet weak var notifyStockBtn: UIButton!
    
    var notifyPrice: (() -> ())?
    var notifyStock: (() -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.notifyPriceBtn.setTitle("Notify me when price drops".localized, for: .normal)
        self.notifyStockBtn.setTitle("Notify me when this product is in stock".localized, for: .normal)
        self.notifyPriceBtn.applyButtonBorder(colours: .black)
        self.notifyStockBtn.applyButtonBorder(colours: .black)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func tapNotifyPriceBtn(_ sender: Any) {
        self.notifyPrice?()
    }
    
    @IBAction func tapNotifyStockBtn(_ sender: Any) {
        self.notifyStock?()
    }
    
}
