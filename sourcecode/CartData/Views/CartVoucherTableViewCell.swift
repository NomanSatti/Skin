//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: CartVoucherTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit
import MaterialComponents.MaterialTextFields_ColorThemer
import MaterialComponents.MaterialTextFields_TypographyThemer

class CartVoucherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var applyDiscountCodeLbl: UILabel!
    @IBOutlet weak var arrowBtn: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var textField: MDCTextField!
    weak var delegate: HeaderViewDelegate?
    var discountController: MDCTextInputControllerOutlined!
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDiscountCodeLbl.text = "Apply Discount Code".localized
        discountController = MDCTextInputControllerOutlined(textInput: textField)
        discountController.activeColor = AppStaticColors.accentColor
        discountController.floatingPlaceholderActiveColor = AppStaticColors.accentColor
        discountController.roundedCorners = UIRectCorner(rawValue: 0)
        discountController.placeholderText = "Enter Discount Code".localized
        topView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
    }
    
    @objc private func didTapHeader() {
        delegate?.toggleSection(view: self, section: 1)
    }
    
    @IBAction func applyclicked(_ sender: Any) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

protocol HeaderViewDelegate: class {
    func toggleSection(view: UITableViewCell, section: Int)
}
