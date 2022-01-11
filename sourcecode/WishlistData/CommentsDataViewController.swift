//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: CommentsDataViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */
import UIKit
import MaterialComponents.MaterialTextFields_ColorThemer
import MaterialComponents.MaterialTextFields_TypographyThemer

class CommentsDataViewController: UIViewController {
    
    @IBOutlet weak var textView: MDCMultilineTextField!
    @IBOutlet weak var updateCommentLabel: UILabel!
    
    var textViewController: MDCTextInputControllerBase!
    
    var comment = ""
    var callback: ((String)->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Comment".localized
        updateCommentLabel.text = "Update Comment".localized.uppercased()
//        textView.applyButtonBorder(colours: AppStaticColors.accentColor)
//        textView.layer.cornerRadius = 4
//        textView.text = comment
//        textView.becomeFirstResponder()
        UIBarButtonItem.appearance().tintColor = AppStaticColors.itemTintColor
        
        
        textView.minimumLines = 0
        textViewController = MDCTextInputControllerOutlinedTextArea(textInput: textView)
        textViewController.activeColor = AppStaticColors.accentColor
        textViewController.floatingPlaceholderActiveColor = AppStaticColors.accentColor
        textViewController.placeholderText = "Comment".localized
        textView.text = comment
        textView.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    @IBAction func tickClicked(_ sender: Any) {
        if let text = textView.text, text.count > 0 {
            callback?(text)
            self.dismiss(animated: true, completion: nil)
        } else {
            ShowNotificationMessages.sharedInstance.warningView(message: "Please write a comment!!!".localized)
        }
    }
    @IBAction func crossClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
