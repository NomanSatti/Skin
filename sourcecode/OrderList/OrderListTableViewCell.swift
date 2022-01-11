//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: OrderListTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class OrderListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var statusWidth: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var orderProductImage: UIImageView!
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var statusData: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var detailBtn: UIButton!
    @IBOutlet weak var reOrderBtn: UIButton!
    @IBOutlet weak var reviewBtn: UIButton!
    
    weak  var delegate: moveToControlller?
    override func awakeFromNib() {
        super.awakeFromNib()
        statusData.textAlignment = .center
        detailBtn.setTitle("DETAILS".localized, for: .normal)
        reOrderBtn.setTitle("REORDER".localized, for: .normal)
        reviewBtn.setTitle("REVIEW".localized, for: .normal)
        
        if Defaults.language == "ar" {
            detailBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            reOrderBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            reviewBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        } else {
            
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func detailTapAct(_ sender: UIButton) {
        delegate?.moveController(id: "", name: "", dict: [:], jsonData: JSON.null, index: sender.tag, controller: .orderDetailsDataViewController)
    }
    
    @IBAction func reOrderAct(_ sender: UIButton) {
        delegate?.moveController(id: "", name: "", dict: [:], jsonData: JSON.null, index: sender.tag, controller: .reOrder)
    }
    
    @IBAction func reviewAct(_ sender: UIButton) {
        delegate?.moveController(id: "", name: "", dict: [:], jsonData: JSON.null, index: sender.tag, controller: .orderReview)
    }
    
    var item: OrderListDataStruct! {
        didSet {
            self.orderProductImage.setImage(fromURL: item.itemImageUrl)
            if item.canReorder ?? false {
                reOrderBtn.isHidden = false
            } else {
                reOrderBtn.isHidden = true
            }
            statusData.textColor = UIColor.white
            //
            orderId.text = "#" + (item.orderId ?? "")
            statusData.text = item.orderStatus
            
            statusWidth.constant = (statusData.text?.widthOfString(usingFont: UIFont.boldSystemFont(ofSize: 14)))! + 20
            statusData.backgroundColor = UIColor().hexToColor(hexString: item.statusColorCode)
            
            orderDate.text = item.orderDate ?? ""
            orderPrice.text = item.orderPrice ?? ""
        }
    }
}
