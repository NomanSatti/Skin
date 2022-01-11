//
//  DeliveryboyRatingTableViewCell.swift
//  Mobikul Single App
//
//  Created by akash on 16/01/20.
//  Copyright © 2020 Webkul. All rights reserved.
//

import UIKit

class DeliveryboyRatingTableViewCell: UITableViewCell {

    @IBOutlet weak var writeReviewBtn: UIButton!
    
    var writeReview: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        writeReviewBtn.setTitle("Write a Review for Delivery Boy".localized.uppercased(), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func tapWriteReviewBtn(_ sender: Any) {
        self.writeReview?()
    }
    
}
