//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: PasswordTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit
import MaterialComponents

class PasswordTableViewCell: UITableViewCell {
    
    @IBOutlet weak var passwordText: MDCTextField!
    @IBOutlet weak var confirmPasswordTxtfld: MDCTextField!
    @IBOutlet weak var lengthView: UIView!
    @IBOutlet weak var minimumLengthLabel: UILabel!
    @IBOutlet weak var minimumCharacterIndicationview: UIView!
    @IBOutlet weak var minimumCharaterLbl: UILabel!
    var passwordController: MDCTextInputControllerOutlined!
    var confirmPasswordController: MDCTextInputControllerOutlined!
    
    @IBOutlet weak var yOfLengthLbl: NSLayoutConstraint!
    @IBOutlet weak var heightOfLengthLbl: NSLayoutConstraint!
    @IBOutlet weak var heightOfMinimumCharLbl: NSLayoutConstraint!
    weak  var delegate: PasswordCharacter?
    let button = UIButton(type: .custom)
    let confirmButton = UIButton(type: .custom)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        minimumLengthLabel.text = "Minimum length of this field must be equal or greater than 8 symbols. Leading and trailing spaces will be ignored.".localized
        heightOfMinimumCharLbl.constant = 0
        minimumCharacterIndicationview.isHidden = true
        minimumCharaterLbl.text = ""
        passwordText.delegate = self
        confirmPasswordTxtfld.delegate = self
        lengthView.cornerRadii(radii: 5.0)
        minimumCharacterIndicationview.cornerRadii(radii: 5.0)
        passwordController = MDCTextInputControllerOutlined(textInput: passwordText)
        confirmPasswordController = MDCTextInputControllerOutlined(textInput: confirmPasswordTxtfld)
        let allTextFieldController: [MDCTextInputControllerOutlined] = [passwordController, confirmPasswordController]
        
        for textFieldController in allTextFieldController {
            textFieldController.activeColor = AppStaticColors.accentColor
            textFieldController.floatingPlaceholderActiveColor = AppStaticColors.accentColor
        }
        passwordController.placeholderText = "Password".localized
        confirmPasswordController.placeholderText = "Confirm Password *".localized
        // MARK: - code for hide show btn
        
        button.setImage(UIImage(named: "closePassword"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(passwordText.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.revealPassword), for: .touchUpInside)
        passwordText.rightView = button
        passwordText.rightViewMode = .always
        
        confirmButton.setImage(UIImage(named: "closePassword"), for: .normal)
        confirmButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        confirmButton.frame = CGRect(x: CGFloat(confirmPasswordTxtfld.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        confirmButton.addTarget(self, action: #selector(self.revealPassword), for: .touchUpInside)
        confirmPasswordTxtfld.rightView = confirmButton
        confirmPasswordTxtfld.rightViewMode = .always
    }
    // MARK: - revel password func
    @objc func revealPassword(_ sender: Any) {
        
        if sender as? UIButton == confirmButton {
            confirmPasswordTxtfld.isSecureTextEntry = !confirmPasswordTxtfld.isSecureTextEntry
            if confirmPasswordTxtfld.isSecureTextEntry {
                confirmButton.setImage(UIImage(named: "closePassword"), for: .normal)
            } else {
                confirmButton.setImage(UIImage(named: "seePassword"), for: .normal)
            }
        } else {
            
            passwordText.isSecureTextEntry = !passwordText.isSecureTextEntry
            if passwordText.isSecureTextEntry {
                button.setImage(UIImage(named: "closePassword"), for: .normal)
            } else {
                button.setImage(UIImage(named: "seePassword"), for: .normal)
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension PasswordTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.passwordText {
            let newText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
            if newText.count>=8 {
                if newText.isValidPassword() {
                    minimumCharaterLbl.text = ""
                    minimumLengthLabel.text = "Minimum length of this field must be equal or greater than 8 symbols. Leading and trailing spaces will be ignored.".localized
                    minimumLengthLabel.textColor = UIColor.green
                    lengthView.isHidden = false
                    lengthView.backgroundColor = UIColor.green
                    heightOfLengthLbl.constant = 45
                    heightOfMinimumCharLbl.constant = 0
                    yOfLengthLbl.constant = 16
                    minimumCharacterIndicationview.isHidden = true
                    if newText.count == 8 {
                        delegate?.passwordUpdate(data: newText, confirmPassword: self.confirmPasswordTxtfld.text ?? "")
                    }
                } else {
                    if (minimumCharaterLbl.text ?? "").isEmpty {
                        minimumCharaterLbl.text = "Minimum of different classes of characters in password is 3. Classes of characters: Lower Case, Upper Case, Digits, Special Characters.".localized
                        minimumCharacterIndicationview.isHidden = false
                        heightOfMinimumCharLbl.constant = 45
                        minimumLengthLabel.text = ""
                        lengthView.isHidden = true
                        heightOfLengthLbl.constant = 0
                        yOfLengthLbl.constant = 0
                        
                        delegate?.passwordUpdate(data: newText, confirmPassword: self.confirmPasswordTxtfld.text ?? "")
                    }
                }
            } else {
                if (minimumLengthLabel.text ?? "").isEmpty {
                    minimumLengthLabel.text = "Minimum length of this field must be equal or greater than 8 symbols. Leading and trailing spaces will be ignored.".localized
                    lengthView.isHidden = false
                    minimumLengthLabel.textColor = UIColor.gray
                    lengthView.backgroundColor = UIColor.gray
                    heightOfLengthLbl.constant = 45
                    heightOfMinimumCharLbl.constant = 0
                    yOfLengthLbl.constant = 16
                    minimumCharaterLbl.text = ""
                    minimumCharacterIndicationview.isHidden = true
                    delegate?.passwordUpdate(data: newText, confirmPassword: self.confirmPasswordTxtfld.text ?? "")
                } else if  newText.count < 8 {
                    if lengthView.backgroundColor != UIColor.gray {
                        minimumLengthLabel.text = "Minimum length of this field must be equal or greater than 8 symbols. Leading and trailing spaces will be ignored.".localized
                        lengthView.isHidden = false
                        minimumLengthLabel.textColor = UIColor.gray
                        lengthView.backgroundColor = UIColor.gray
                        heightOfLengthLbl.constant = 45
                        heightOfMinimumCharLbl.constant = 0
                        yOfLengthLbl.constant = 16
                        minimumCharaterLbl.text = ""
                        minimumCharacterIndicationview.isHidden = true
                        delegate?.passwordUpdate(data: newText, confirmPassword: self.confirmPasswordTxtfld.text ?? "")
                    }
                }
            }
        }
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        if  Int(textField.text ?? "1") != nil {
        //            delegate?.passwordUpdate(data: textField.text ?? "")
        //        }
        delegate?.passwordUpdate(data: self.passwordText.text ?? "", confirmPassword: self.confirmPasswordTxtfld.text ?? "")
    }
}
