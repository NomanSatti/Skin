//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: AddressBookListViewModel.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit

class AddressBookListViewModel: NSObject {
    
    @IBOutlet weak var addressListTableView: UITableView!
    var addressDaatArray = [AddressData]()
    var index = 0
    var addressCount: Int!
    weak var delegate: RemoveAddressAction?
    
    func getValue(data: JSON, competion:((_ data: Bool) -> Void)) {
        if let data = AddressBookModel(data: data) {
            addressCount = data.addressCount
            addressDaatArray = data.addressDaatArray
            competion(true)
        } else {
            addressCount = 0
            competion(false)
        }
    }
}

extension AddressBookListViewModel: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if addressDaatArray.count > 0 {
            if addressDaatArray[index].otherAddressDataArray.count > 0 {
                return 3
            } else {
                return 2
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 && addressDaatArray[index].otherAddressDataArray.count > 0 {
            return addressDaatArray[index].otherAddressDataArray.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTextTableViewCell", for: indexPath)as? AddressTextTableViewCell {
                cell.delegate = self
                cell.removeBtnAct.isHidden = true
                cell.editBtn.isHidden = true
                cell.upperLineView.isHidden = true
                cell.lowerLineView.isHidden = true
                cell.typeOfSection = indexPath.section
                cell.itemShiiping = addressDaatArray[indexPath.row]
                cell.editBtn.addTapGestureRecognizer {
                    self.delegate?.editAddress(addressId: self.addressDaatArray[self.index].shippingId ?? "")
                }
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .none
                return cell
            }
        } else if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTextTableViewCell", for: indexPath)as? AddressTextTableViewCell {
                cell.delegate = self
                cell.typeOfSection = indexPath.section
                cell.itemBiling = addressDaatArray[indexPath.row]
                cell.removeBtnAct.isHidden = true
                cell.editBtn.isHidden = true
                cell.upperLineView.isHidden = true
                cell.lowerLineView.isHidden = true
                cell.editBtn.addTapGestureRecognizer {
                    self.delegate?.editAddress(addressId: self.addressDaatArray[self.index].billingId ?? "")
                }
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .none
                return cell
            }
        } else {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTextTableViewCell", for: indexPath)as? AddressTextTableViewCell {
                
                cell.delegate = self
                cell.typeOfSection = indexPath.section
                cell.itemOther = addressDaatArray[index].otherAddressDataArray[indexPath.row]
                cell.removeBtnAct.tag = indexPath.row
                cell.removeBtnAct.isHidden = false
                cell.editBtn.isHidden = false
                cell.upperLineView.isHidden = false
                cell.lowerLineView.isHidden = false
                cell.editBtn.addTapGestureRecognizer {
                    self.delegate?.editAddress(addressId: self.addressDaatArray[self.index].otherAddressDataArray[indexPath.row].id ?? "")
                }
                cell.accessoryType = .none
                cell.selectionStyle = .none
                return cell
            }
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.delegate?.editAddress(addressId: self.addressDaatArray[self.index].shippingId ?? "")
        } else if indexPath.section == 1 {
            self.delegate?.editAddress(addressId: self.addressDaatArray[self.index].billingId ?? "")
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            if let  footerView = (Bundle.main.loadNibNamed("HeaderTitleView", owner: self, options: nil)?[0] as? HeaderTitleView) {
                footerView.headingLbl.text = "DEFAULT SHIPPING ADDRESS".localized
                footerView.headingLbl.textColor = UIColor.black
                return footerView
            }
            
        } else if section == 1 {
            if let footerView = (Bundle.main.loadNibNamed("HeaderTitleView", owner: self, options: nil)?[0] as? HeaderTitleView) {
                footerView.headingLbl.text = "DEFAULT BILLING ADDRESSES".localized
                footerView.headingLbl.textColor = UIColor.black
                return footerView
            }
        } else {
            if let footerView = (Bundle.main.loadNibNamed("HeaderTitleView", owner: self, options: nil)?[0] as? HeaderTitleView) {
                footerView.headingLbl.text = "OTHER ADDRESSES".localized
                footerView.headingLbl.textColor = UIColor.black
                return footerView
            }
        }
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
}

extension AddressBookListViewModel: RemoveAddressAction {
    func removeAddress(addressId: String) {
        delegate?.removeAddress(addressId: addressId)
    }
    func editAddress(addressId: String) {
        delegate?.editAddress(addressId: addressId)
    }
}
