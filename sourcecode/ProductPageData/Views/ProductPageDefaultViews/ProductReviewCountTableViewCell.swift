//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: ProductReviewCountTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class ProductReviewCountTableViewCell: UITableViewCell {
    
    @IBOutlet weak var reviewWidth: NSLayoutConstraint!
    @IBOutlet weak var addReviewBtn: UIButton!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var ratingValue: UILabel!
    var id = ""
    var name = ""
    var imageData = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        addReviewBtn.setTitle("Add your review".localized.uppercased(), for: .normal)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func addReviewClicked(_ sender: Any) {
        let viewController = AddReviewDataViewController.instantiate(fromAppStoryboard: .customer)
        viewController.id = id
        viewController.name = name
        viewController.imageUrl = imageData
        let nav = UINavigationController(rootViewController: viewController)
        //nav.navigationBar.tintColor = AppStaticColors.accentColor
        nav.modalPresentationStyle = .fullScreen
        self.viewContainingController?.present(nav, animated: true, completion: nil)
    }
}
