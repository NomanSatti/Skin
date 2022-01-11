//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: BundleDropDownTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit
import ActionSheetPicker_3_0

class BundleDropDownTableViewCell: UITableViewCell {
    
    @IBOutlet weak var qtyHeight: NSLayoutConstraint!
    @IBOutlet weak var qtyView: UIView!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var headingLabel: UILabel!
    var optionValues = [OptionValues]()
    var row = 0
    var qtyEnable = true
    var bundleDict = [String: Any]()
    var bundleQtyDict = [String: Any]()
    var parentID = ""
    var customDict = [String: Any]()
    weak var customDelegate: GettingCustomData?
    weak var delegate: GettingBundleData?
    var selectedIndex: ((_ index: Int)-> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.isUserInteractionEnabled = true
        textField.delegate = self
        textField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapCountryView)))
        
    }
    
    @objc private func didTapCountryView() {
        
        let gg =  ActionSheetStringPicker(title: headingLabel.text ?? "", rows: optionValues.map { $0.title }, initialSelection: row, doneBlock: { _, indexes, _ in
            self.textField.text = self.optionValues[indexes].title
            self.qtyLabel.text =  self.optionValues[indexes].defaultQty
            self.row = indexes
            self.selectedIndex?(indexes)
            self.bundleDict[self.parentID] = self.optionValues[indexes].optionValueId
            self.customDict[self.parentID] = self.optionValues[indexes].optionValueId
            if  self.optionValues[indexes].isQtyUserDefined == "1" {
                self.qtyEnable = true
            } else {
                self.qtyEnable = false
            }
            self.customDelegate?.gettingCustomData(data: self.customDict)
            self.bundleQtyDict[self.optionValues[indexes].optionValueId] = self.qtyLabel.text
            self.delegate?.gettingBundleData(data: self.bundleDict, qtyDict: self.bundleQtyDict, selectedItem: self.row )
        }, cancel: { _ in
            
            return }, origin: self.textField)
        
        //            toolbar?.setCancelButton(UIBarButtonItem.init(title: "PICKER_Cancel".localized, style: .done, target: self, action: nil))
        gg?.setCancelButton(UIBarButtonItem.init(title: "Cancel".localized, style: .done, target: self, action: nil))
        gg?.setDoneButton(UIBarButtonItem.init(title: "Done".localized, style: .done, target: self, action: nil))
        gg?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]//this is actually the title of toolbar
        gg?.toolbarButtonsColor = UIColor.black
        
        gg?.show()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func minusClicked(_ sender: Any) {
        if qtyEnable {
            var val = Int(self.qtyLabel.text ?? "1") ?? 1
            if val > 1 {
                val -= 1
                self.qtyLabel.text = String(val)
            }
            bundleQtyDict[optionValues[row].optionValueId] = self.qtyLabel.text
            delegate?.gettingBundleData(data: bundleDict, qtyDict: bundleQtyDict, selectedItem: 0)
        }
    }
    
    @IBAction func plusClicked(_ sender: Any) {
        if qtyEnable {
            var val = Int(self.qtyLabel.text ?? "1") ?? 1
            val += 1
            self.qtyLabel.text = String(val)
            bundleQtyDict[optionValues[row].optionValueId] = self.qtyLabel.text
            delegate?.gettingBundleData(data: bundleDict, qtyDict: bundleQtyDict, selectedItem: 0)
        }
    }
}

extension BundleDropDownTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.endEditing(true)
    }
}
