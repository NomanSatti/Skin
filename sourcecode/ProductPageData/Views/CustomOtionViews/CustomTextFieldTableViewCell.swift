//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: CustomTextFieldTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class CustomTextFieldTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var headinglabel: UILabel!
    var customDict = [String: Any]()
    var parentID = ""
    weak var delegate: GettingCustomData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
        // Initialization code
        self.textField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
    }
    
    override func layoutSubviews() {
        if let obj = self.viewContainingController as? ProductPageDataViewController, let viewModel = obj.viewModel {
            self.customDict = viewModel.customDict
        }
        if let val = customDict[parentID] as? String {
            textField.text = val
        }
    }
    
    @objc func textFieldDidChanged(_ textField: UITextField) {
        print(textField.text)
        print(customDict)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
extension CustomTextFieldTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let obj = self.viewContainingController as? ProductPageDataViewController, let viewModel = obj.viewModel {
            self.customDict = viewModel.customDict
        }
        customDict[parentID] = textField.text
        delegate?.gettingCustomData(data: customDict)
    }
}
