import UIKit
import Reusable
import MaterialComponents.MDCMultilineTextField
import MaterialComponents.MaterialTextFields_ColorThemer
import MaterialComponents.MaterialTextFields_TypographyThemer

class FormTextViewTableViewCell: UITableViewCell, FormConformity, NibReusable, UITextViewDelegate {
    
    @IBOutlet weak var textField: MDCMultilineTextField!
    @IBOutlet weak var hedingLabel: UILabel!
    var formItem: FormItem?
    var fieldController: MDCTextInputControllerBase!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //        textField.applyBorder(colours: UIColor().hexToColor(hexString: LIGHTGREY))
        textField.minimumLines = 0
        fieldController = MDCTextInputControllerOutlinedTextArea(textInput: textField)
        fieldController.activeColor = AppStaticColors.accentColor
        fieldController.floatingPlaceholderActiveColor = AppStaticColors.accentColor
        //        textField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left
        //        textField.delegate = self
        self.textField.textView?.delegate = self
        //        self.textField.textView.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.formItem?.valueCompletion?(textView.text)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension FormTextViewTableViewCell: FormUpdatable {
    func update(with formItem: FormItem) {
        self.formItem = formItem
        self.textField.placeholder = formItem.heading
        //        self.hedingLabel.text = formItem.heading
        //        self.textField.isSecureTextEntry = formItem.isSecure
        self.textField.text = self.formItem?.value as? String
        self.textField.accessibilityHint = self.formItem?.keyType
        
        //        self.textField.keyboardType = self.formItem?.uiProperties.keyboardType ?? .default
        self.textField.tintColor = self.formItem?.uiProperties.tintColor
    }
}
