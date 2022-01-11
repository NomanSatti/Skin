//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: SingleDropDownTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

//
//  FormDropDownTableViewCell.swift
//  MobikulOpencartMp
//
//  Created by bhavuk.chawla on 05/11/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import UIKit
import Reusable
import ActionSheetPicker_3_0
import MaterialComponents.MaterialTextFields_ColorThemer
import MaterialComponents.MaterialTextFields_TypographyThemer

class SingleDropDownTableViewCell: UITableViewCell, FormConformity, NibReusable {
    
    @IBOutlet weak var textField: MDCTextField!
    
    var fieldController: MDCTextInputControllerOutlined!
    var tableView: UITableView?
    var formItem: FormItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.fieldController = MDCTextInputControllerOutlined(textInput: self.textField)
        self.fieldController.activeColor = AppStaticColors.accentColor
        self.fieldController.floatingPlaceholderActiveColor = AppStaticColors.accentColor
        self.textField.isUserInteractionEnabled = true
        self.textField.delegate = self
        self.textField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapCountryView)))
        
        textField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left
        
        if Defaults.language == "ar" {
            self.textField.semanticContentAttribute = .forceRightToLeft
            self.textField.textAlignment = .right
        } else {
            self.textField.semanticContentAttribute = .forceLeftToRight
            self.textField.textAlignment = .left
        }
    }
    
    @objc func textFieldDidChanged(_ textField: UITextField) {
        self.formItem?.valueCompletion?(textField.text)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc private func didTapCountryView() {
        
        if let formItem = formItem {
            if let val = formItem.prifixData as? [String] {
                var rowValue = 0
                if  let val1 = self.formItem?.value as? String,
                    let index = val.firstIndex(where: {$0 == val1 }) {
                    rowValue = index
                }
                UIBarButtonItem.appearance().tintColor = UIColor.black
                //            ActionSheetStringPicker(
                
                let gg =  ActionSheetStringPicker(title: formItem.placeholder, rows: val, initialSelection: rowValue, doneBlock: { _, indexes, _ in
                    self.textField.text = val[indexes]
                    formItem.value = val[indexes]
                    self.formItem?.valueCompletion?(self.textField.text)
                    self.tableView?.reloadData()
                    
                }, cancel: { _ in
                    
                    return }, origin: self.textField)
                
                //            toolbar?.setCancelButton(UIBarButtonItem.init(title: "PICKER_Cancel".localized, style: .done, target: self, action: nil))
                gg?.setCancelButton(UIBarButtonItem.init(title: "Cancel".localized, style: .done, target: self, action: nil))
                gg?.setDoneButton(UIBarButtonItem.init(title: "Done".localized, style: .done, target: self, action: nil))
                gg?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]//this is actually the title of toolbar
                gg?.toolbarButtonsColor = UIColor.blue
                
                gg?.show()
            }
            //            }
        }
    }
}

extension SingleDropDownTableViewCell: UITextFieldDelegate {
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

extension SingleDropDownTableViewCell: FormUpdatable {
    func update(with formItem: FormItem) {
        self.formItem = formItem
        self.textField.isSecureTextEntry = formItem.isSecure
        
        if let val = self.formItem?.value as? String, let prifixData = formItem.prifixData as? [String] , let index = prifixData.firstIndex(where: {$0 == val }) {
            self.textField.text =  prifixData[index]
        }
        //        self.textField.text =
        self.textField.accessibilityHint = self.formItem?.keyType
        
        if let image = formItem.rightIcon {
            self.textField.setRightIcon(image)
        }
        self.textField.placeholder = self.formItem?.placeholder
        self.textField.keyboardType = self.formItem?.uiProperties.keyboardType ?? .default
        self.textField.tintColor = self.formItem?.uiProperties.tintColor
    }
}
