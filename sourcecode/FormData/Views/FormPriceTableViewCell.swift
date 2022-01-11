import UIKit
import Reusable

class FormPriceTableViewCell: UITableViewCell, FormConformity, NibReusable {
    
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var headingLabel: UILabel!
    var formItem: FormItem?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left
        textField2.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left
        self.textField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        self.textField2.addTarget(self, action: #selector(textFieldDidChanged1(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChanged(_ textField: UITextField) {
        self.formItem?.valueCompletion?(textField.text)
    }
    
    @objc func textFieldDidChanged1(_ textField: UITextField) {
        self.formItem?.value2 = textField.text
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension FormPriceTableViewCell: FormUpdatable {
    func update(with formItem: FormItem) {
        self.formItem = formItem
        self.headingLabel.text = formItem.heading
        self.textField.isSecureTextEntry = formItem.isSecure
        self.textField.text = self.formItem?.value as? String
        self.textField2.text = self.formItem?.value2 as? String
        self.textField.accessibilityHint = self.formItem?.keyType
        if let image = formItem.image {
            self.textField.setLeftIcon(image)
        }
        self.textField.placeholder = self.formItem?.placeholder
        self.textField.keyboardType = .numberPad
        self.textField2.keyboardType = .numberPad
        self.textField.tintColor = self.formItem?.uiProperties.tintColor
    }
}
