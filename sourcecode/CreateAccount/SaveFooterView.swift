//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: SaveFooterView.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class SaveFooterView: UIView {
    //@IBOutlet weak var onOffSwitchBtn: UISwitch!
    // @IBOutlet weak var newsLetterLbl: UILabel!
    //@IBOutlet weak var newsLetterView: UIView!
    @IBOutlet weak var createAccountBtn: UIButton!
    @IBOutlet weak var alreadyHaveAccountBtn: UIButton!
    override func awakeFromNib() {
        
        createAccountBtn.setTitle("Create an Account".localized.uppercased(), for: .normal)
        //alreadyHaveAccountBtn.setTitle("Already have an account? Sign In".localized, for: .normal)
        self.alreadyHaveAccountBtn.titleLabel?.halfTextWithColorChange(fullText: "Already have an account? Sign In".localized.uppercased(), changeText: "Sign In".localized.uppercased(), color: .blue)
        alreadyHaveAccountBtn.setAttributedTitle(self.alreadyHaveAccountBtn.titleLabel?.attributedText, for: .normal)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let xibView = Bundle.main.loadNibNamed("SaveFooterView", owner: self, options: nil)?[0] as? UIView {
            xibView.frame = self.bounds
            xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.addSubview(xibView)
        }
    }
}
