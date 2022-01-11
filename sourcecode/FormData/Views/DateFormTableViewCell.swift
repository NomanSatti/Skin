import UIKit
import Reusable
import ActionSheetPicker_3_0
import MaterialComponents

class DateFormTableViewCell: UITableViewCell, FormConformity, NibReusable {
    
    @IBOutlet weak var textField: MDCTextField!
    var fieldController: MDCTextInputControllerOutlined!
    var tableView: UITableView?
    var formItem: FormItem?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.isUserInteractionEnabled = true
        textField.delegate = self
        fieldController = MDCTextInputControllerOutlined(textInput: textField)
        fieldController.activeColor = AppStaticColors.accentColor
        fieldController.floatingPlaceholderActiveColor = AppStaticColors.accentColor
        textField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapCountryView)))
        
    }
    
    @objc func textFieldDidChanged(_ textField: UITextField) {
        self.formItem?.valueCompletion?(textField.text)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc private func didTapCountryView() {
        let datePicker = ActionSheetDatePicker(title: "Select Date".localized, datePickerMode: UIDatePicker.Mode.date, selectedDate: Date(), target: self, action: #selector(self.datePicked(_:)), origin: self.textField)
        //datePicker?.maximumDate = Date()
        datePicker?.maximumDate = formItem?.maxDate
        datePicker?.minimumDate = formItem?.minDate
        datePicker?.toolbarButtonsColor = UIColor.black
        UIBarButtonItem.appearance().tintColor = UIColor.black
        
        datePicker?.show()
        
    }
    @objc func datePicked(_ obj: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = formItem?.keyType2
        if let formItem = formItem {
            self.textField.text =  dateFormatter.string(from: obj)
            formItem.value =  dateFormatter.string(from: obj)
        }
        
        //        UIDatePickerMode.setTitle(obj.description, for: UIControlState())
    }
}

extension DateFormTableViewCell: UITextFieldDelegate {
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

extension DateFormTableViewCell: FormUpdatable {
    func update(with formItem: FormItem) {
        self.formItem = formItem
        //self.hedingLabel.text = formItem.heading
        self.textField.isSecureTextEntry = formItem.isSecure
        if let val = self.formItem?.value as? String {
            self.textField.text = val
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.none
            dateFormatter.dateStyle = DateFormatter.Style.short
            dateFormatter.dateFormat = formItem.keyType2
            self.textField.text = dateFormatter.string(from: Date())
            formItem.value = dateFormatter.string(from: Date())
            
        }
        //        self.textField.text =
        self.textField.accessibilityHint = self.formItem?.keyType
        if let image = formItem.image {
            self.textField.setLeftIcon(image)
        }
        //        if let image = formItem.rightIcon {
        //            self.textField.setRightIcon(image)
        //        }
        
        //        if let image = formItem.image2 {
        //            self.stateTextField.setLeftIcon(image)
        //        }
        ////        if let image = formItem.rightIcon {
        ////            self.stateTextField.setRightIcon(image)
        ////        }
        //        self.stateHeadingLabel.text = self.formItem?.placeholder2
        //        self.stateTextField.placeholder =  self.formItem?.placeholder2
        self.textField.placeholder = self.formItem?.placeholder
        self.textField.keyboardType = self.formItem?.uiProperties.keyboardType ?? .default
        self.textField.tintColor = self.formItem?.uiProperties.tintColor
    }
}
