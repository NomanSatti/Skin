//
//  AddressFieldTableViewCell.swift
//  MobikulOpencartMp
//
//  Created by bhavuk.chawla on 05/11/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import UIKit
import Reusable
import MaterialComponents.MaterialTextFields_ColorThemer
import MaterialComponents.MaterialTextFields_TypographyThemer

class AddressFieldTableViewCell: UITableViewCell, FormConformity, NibReusable, UITextFieldDelegate {
    
    @IBOutlet weak var textField: MDCTextField!
    //    @IBOutlet weak var hedingLabel: UILabel!
    var fieldController: MDCTextInputControllerOutlined!
    var formItem: FormItem?
    let button = UIButton(type: .custom)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        fieldController = MDCTextInputControllerOutlined(textInput: textField)
        fieldController.activeColor = AppStaticColors.accentColor
        fieldController.floatingPlaceholderActiveColor = AppStaticColors.accentColor
        textField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left
        self.textField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChanged(_ textField: UITextField) {
        self.formItem?.valueCompletion?(textField.text)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        if let formItem = formItem, formItem.keyType == "email" {
            return true
        } else {
            return allowedCharacters.isSuperset(of: characterSet)
        }
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.formItem?.valueCompleted?(textField.text)
    }
}

extension AddressFieldTableViewCell: FormUpdatable {
    func update(with formItem: FormItem) {
        self.formItem = formItem
        if formItem.keyType == "email" {
            formItem.emailType = true
        }
        if formItem.uiProperties.keyboardType == .numberPad || formItem.uiProperties.keyboardType == .phonePad || formItem.keyType == "email" {
            self.textField.delegate = self
        } else {
            self.textField.delegate = nil
        }
        self.textField.isUserInteractionEnabled = formItem.isEditable
        //        self.hedingLabel.text = formItem.heading
        self.textField.isSecureTextEntry = formItem.isSecure
        if formItem.isSecure {
            self.textField.textContentType = UITextContentType(rawValue: "")
            button.setImage(UIImage(named: "closePassword"), for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
            button.frame = CGRect(x: CGFloat(self.textField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
            button.addTarget(self, action: #selector(self.revealPassword), for: .touchUpInside)
            self.textField.rightView = button
            self.textField.rightViewMode = .always
        }
        self.textField.text = self.formItem?.value as? String
        self.textField.accessibilityHint = self.formItem?.keyType
        if let image = formItem.image {
            self.textField.setLeftIcon(image)
        }
        self.textField.placeholder = self.formItem?.placeholder
        self.textField.keyboardType = self.formItem?.uiProperties.keyboardType ?? .default
        self.textField.tintColor = self.formItem?.uiProperties.tintColor
    }
    
    @objc func revealPassword(_ sender: Any) {
        self.textField.isSecureTextEntry = !self.textField.isSecureTextEntry
        if self.textField.isSecureTextEntry {
            button.setImage(UIImage(named: "closePassword"), for: .normal)
        } else {
            button.setImage(UIImage(named: "seePassword"), for: .normal)
        }
    }
}

extension UITextField {
    
    /// set icon of 20x20 with left padding of 8px
    func setLeftIcon(_ icon: UIImage) {
        
        let padding = 8
        let size = 16
        
        let outerView = UIView(frame: CGRect(x: 8, y: 0, width: size+padding + 16, height: size) )
        let iconView  = UIImageView(frame: CGRect(x: padding + 8, y: 0, width: size, height: size))
        iconView.image = icon
        outerView.addSubview(iconView)
        
        leftView = outerView
        leftViewMode = .always
        
    }
}
