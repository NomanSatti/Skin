//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: AddressTextTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class AddressTextTableViewCell: UITableViewCell {
    
    @IBOutlet weak var removeWidth: NSLayoutConstraint!
    @IBOutlet weak var addressDataLbl: UILabel!
    weak var delegate: RemoveAddressAction?
    var typeOfSection: Int!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var removeBtnAct: UIButton!
    @IBOutlet weak var upperLineView: UIView!
    @IBOutlet weak var lowerLineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if Defaults.language == "ar" {
            editBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        }
        editBtn.setTitle("edit".localized, for: .normal)
        removeBtnAct.setTitle("Remove".localized, for: .normal)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var itemShiiping: AddressData! {
        didSet {
            //addressDataLbl.text = (itemShiiping.shippingAddress ?? "").html2String
            addressDataLbl.text = (itemShiiping.shippingAddress ?? "").replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
        }
    }
    var itemBiling: AddressData! {
        didSet {
            //addressDataLbl.text = (itemBiling.billingAddress ?? "").html2String
            addressDataLbl.text = (itemBiling.billingAddress ?? "").replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
        }
    }
    var itemOther: OtherAddressData! {
        didSet {
            //addressDataLbl.text = (itemOther.address ?? "").html2String
            addressDataLbl.text = (itemOther.address ?? "").replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
        }
    }
    
    @IBAction func removeAddressAct(_ sender: Any) {
        if typeOfSection == 0 {
            delegate?.removeAddress(addressId: itemShiiping.shippingId ?? "")
        } else if typeOfSection == 1 {
            delegate?.removeAddress(addressId: itemBiling.billingId ?? "")
        } else {
            delegate?.removeAddress(addressId: itemOther.id ?? "")
        }
    }
    
}
