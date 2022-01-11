//
/**
* Webkul Software.
* @package  Mobikul Single App
* @Category Webkul
* @author Webkul <support@webkul.com>
* FileName: FormTextViewDescriptionTableViewCell.swift
* @Copyright (c) 2010-2019 Webkul Software Private Limited (https://webkul.com)
* @license https://store.webkul.com/license.html ASL Licence
* @link https://store.webkul.com/license.html

*/


import UIKit
import Reusable
import RichEditorView

class FormTextViewDescriptionTableViewCell: UITableViewCell, FormConformity, NibReusable, UITextViewDelegate {

    @IBOutlet weak var descriptionView: RichEditorView!
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var mainView: UIView!
    var row = 0
    var formItem: FormItem?
    var callBack: (()->Void)?
    lazy var toolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.descriptionView.frame.width, height: 44))
        toolbar.options = RichEditorDefaultOption.all
        return toolbar
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        descriptionView.delegate = self
        descriptionView.inputAccessoryView = toolbar
        heading.text = "Description".localized
        toolbar.delegate = self
        toolbar.editor = descriptionView
        self.heading.textColor = UIColor.gray
        let item = RichEditorOptionItem(image: nil, title: "Clear") { toolbar in
            toolbar.editor?.html = ""
        }
        let doneItem = RichEditorOptionItem(image: nil, title: "Done") { toolbar in
            self.descriptionView.resignFirstResponder()
            self.descriptionView.inputAccessoryView?.isHidden = true
            self.heading.textColor = UIColor.darkGray
        }
        var options = toolbar.options
        options.append(item)
        options.append(doneItem)
        toolbar.options = options
        self.mainView.addTapGestureRecognizer {
            self.descriptionView.inputAccessoryView?.isHidden = false
            self.heading.textColor = UIColor.black
            self.toolbar.editor?.focus()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension FormTextViewDescriptionTableViewCell: RichEditorDelegate {
    
    func richEditor(_ editor: RichEditorView, contentDidChange content: String) {
        if content.isEmpty {
            //htmlView.text = "HTML Preview"
        } else {
            self.formItem?.valueCompletion?(content)
        }
    }
    
}
extension FormTextViewDescriptionTableViewCell: RichEditorToolbarDelegate {
    
    fileprivate func randomColor() -> UIColor {
        let colors: [UIColor] = [
            .red,
            .orange,
            .yellow,
            .green,
            .blue,
            .purple
        ]
        
        let color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        return color
    }
    func richEditorTookFocus(_ editor: RichEditorView) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5){
            self.descriptionView.inputAccessoryView?.isHidden = false
            self.heading.textColor = UIColor.black
            editor.becomeFirstResponder()
            editor.focus()
            self.callBack?()
        }
    }
    func richEditorToolbarChangeTextColor(_ toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextColor(color)
    }

    func richEditorToolbarChangeBackgroundColor(_ toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextBackgroundColor(color)
    }
}
extension FormTextViewDescriptionTableViewCell: FormUpdatable {
    func update(with formItem: FormItem) {
        self.formItem = formItem
        //self.descriptionView.placeholder = formItem.heading
                self.heading.text = formItem.heading
        //        self.textField.isSecureTextEntry = formItem.isSecure
        self.descriptionView.html = self.formItem?.value as? String ?? ""
        self.descriptionView.accessibilityHint = self.formItem?.keyType
        
        //        self.textField.keyboardType = self.formItem?.uiProperties.keyboardType ?? .default
         self.descriptionView.tintColor = self.formItem?.uiProperties.tintColor
    }
}
