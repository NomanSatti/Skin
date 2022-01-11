//
//  CustomPickerControl.swift
//  mecosHealth
//
//  Created by Waris on 4/27/17.
//  Copyright © 2017 Teleglobal. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0


enum CustomPickerType: Int {
    case string = 0
    case date
    case dateTime
    case time
}


@IBDesignable class CustomPickerControl: UIView {

    // MARK: - IBOutlet -
    @IBOutlet weak var mainContainerView: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCompulsory: UILabel!
    
    @IBOutlet weak var btnTitle: UIButton!
    @IBOutlet weak var btnRemoveOptional: UIButton!
    
    @IBOutlet weak var imgDropDown: UIImageView!
    
    // MARK: - Variables -
    var displayTitle : String = ""
//    weak var overlay : UIView?
    
    @IBInspectable var displayButtonTitle: String {
        get{
            return self.displayTitle
        }
        set(title){
            self.displayTitle = title
            
            if title == self.buttonTitle{
                self.buttonColor = UIColor.gray
                
                self.imgDropDown.isHidden = false
                self.btnRemoveOptional.isHidden = true
            }
            else{
                self.buttonColor = UIColor.black
                
                self.imgDropDown.isHidden = true
                self.btnRemoveOptional.isHidden = false
            }
        }
    }
    
    @IBInspectable var buttonTitle: String{
        get {
            return btnTitle.title(for: .normal) ?? ""
        }
        set(text) {
            btnTitle.setTitle(text, for: .normal)
            
            if text == self.displayButtonTitle{
                self.buttonColor = UIColor.gray
            }
            else{
                self.buttonColor = UIColor.black
            }
            if text.count > 0{
                if self.isCompulsory || text == self.displayButtonTitle {
                    self.btnRemoveOptional.isHidden = true
                    self.imgDropDown.isHidden = !self.isEnable
                }
                else if text != self.displayButtonTitle{
                    self.imgDropDown.isHidden = true
                    self.btnRemoveOptional.isHidden = false
                }
            }
            else{
                if self.isCompulsory{
                }
                else{
                    self.removeOptionalClicked(self.btnRemoveOptional)
                }
            }
        }
    }
    
    @IBInspectable var title: String{
        get {
            return lblTitle.text!
        }
        set(title) {
            lblTitle.text = title
        }
    }
    
    @IBInspectable var isCompulsory: Bool{
        get {
            return !(lblCompulsory.isHidden)
        }
        set(title) {
            lblCompulsory.isHidden = !title
        }
    }
    
    @IBInspectable var isEnable: Bool{
        get {
            return self.isUserInteractionEnabled
        }
        set(enable) {
            self.isUserInteractionEnabled = enable
            self.btnTitle.isEnabled = enable
            self.btnTitle.setTitleColor(.gray, for: .disabled)
            self.imgDropDown.isHidden = !isEnable
            self.btnRemoveOptional.isEnabled = isEnable
        }
    }
    
    @IBInspectable var pickerType: Int{
        get{
            return self.customPickerType.rawValue
        }
        set(type){
            self.customPickerType = CustomPickerType.init(rawValue: type) ?? .string
        }
    }
    
    @IBInspectable var buttonColor: UIColor{
        get{
            return self.btnTitle.titleColor(for: .normal)!
        }
        set(color){
            self.btnTitle.setTitleColor(color, for: .normal)
        }
    }
    
    @IBInspectable var enableLayoutMargin: Bool {
        get{
            return self.mainContainerView.layoutMargins.left > 0
        }
        set(enable){
            self.mainContainerView.layoutMargins = enable ? UIEdgeInsets.init(top: 5, left: 10, bottom: 0, right: 10) : UIEdgeInsets.zero
        }
    }
    
    var minimumDate: Date?
    
    var maximumDate: Date?
    
    var customPickerType: CustomPickerType = .string
    
    
    var pickerData: [String] = []{
        didSet{
            if !pickerData.contains("Select".localized){
                if pickerData.count == 0 {
                    pickerData.append("Select".localized)
                } else {
                    pickerData.insert("Select".localized, at: 0)
                }
            }
        }
    }
    
    var pickerViewController: UIViewController?
    
    var view: UIView!
    
    var nibName: String = "CustomPickerControl"
    
    var customPickerHandler : ((_ selectedItem: Any?, _ selectedIndex: Int?, _ pickerType: CustomPickerType) -> Void)?
    
    
    // MARK: - UIView -
    
    init(title: String, pickerData data: [String], isFieldCompulsory isCompulsory: Bool, pickerType: CustomPickerType) {
        
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 60))
        
        self.setup()
        
        self.title = title
        
        self.isCompulsory = isCompulsory
        
        self.pickerData = data
        
        self.customPickerType = pickerType
    }
    
    func setup() {
        view = loadViewFromNib()
        
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        addSubview(view)
        
        self.lblCompulsory.textColor = .red
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        if LoggedInUserHelper.sharedInstance.currentLanguage == .english {
            btnTitle.contentHorizontalAlignment = .left
        } else if LoggedInUserHelper.sharedInstance.currentLanguage == .arabic {
            btnTitle.contentHorizontalAlignment = .right
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
        if LoggedInUserHelper.sharedInstance.currentLanguage == .english {
            btnTitle.contentHorizontalAlignment = .left
        } else if LoggedInUserHelper.sharedInstance.currentLanguage == .arabic {
            btnTitle.contentHorizontalAlignment = .right
        }
    }
    
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    // MARK: - IBAction -
    
    @IBAction func removeOptionalClicked(_ sender: UIButton){
        if self.isCompulsory == false{
            
            self.btnTitle.setTitle(self.displayButtonTitle, for: .normal)
            self.buttonColor = UIColor.gray
            
            self.customPickerHandler?(nil, -1, self.customPickerType)
            self.imgDropDown.isHidden = false
            self.btnRemoveOptional.isHidden = true
        }
    }
    
    @IBAction func pickerClicked(_ sender: UIButton){
        
        UIApplication.shared.keyWindow?.endEditing(true)
        
        if let vc = self.pickerViewController{
            
            vc.view.endEditing(true)
            
            if self.customPickerType == .string{
                
                if self.pickerData.count > 0{
                    // Comment by Zeeshan Haider on August 30, 2018
                    // Breaking memory leak by [unowned self]
                    vc.showStringPicker(sender, title: self.title, items: self.pickerData) { [unowned self] (selectedItem, index) in
                        
                        
                        self.buttonTitle = selectedItem as! String
                        if self.isCompulsory {
                            self.customPickerHandler?(selectedItem, index!-1, self.customPickerType)
                        } else {
                            self.customPickerHandler?(selectedItem, index!-1, self.customPickerType)
                        }
                    }
                }
            } else {
                
                var mode = UIDatePicker.Mode.date
                
                if self.customPickerType == .dateTime {
                    
                    mode = UIDatePicker.Mode.dateAndTime
                } else if self.customPickerType == .date {
                    
                    mode = UIDatePicker.Mode.date
                } else {
                    
                    mode = UIDatePicker.Mode.time
                }
                // Comment by Zeeshan Haider on August 30, 2018
                // Breaking memory leak by [unowned self]
                vc.showDatePicker(sender, title: self.title, minimumDate: self.minimumDate, maximumDate: self.maximumDate, mode: mode, doneBlock: { [unowned self] (selectedDate: Date) in
                    
                    if mode == .time {
                        self.buttonTitle = DateHelper.stringFromDate(selectedDate, dateFormat: K.TimeFormatShort2) ?? ""
                    } else {
                        self.buttonTitle = sender.title(for: .normal)!
                    }
                    self.customPickerHandler?(selectedDate, 0, self.customPickerType)
                    
                })
            }
        
        }
    }
    
    func selectedItemIndex() -> Int {
        
        if self.customPickerType == .string && self.pickerData.count > 0 {
            if let index = self.pickerData.index(where: {$0.capitalized == self.btnTitle.currentTitle?.capitalized}) {
                return index-1
            } else {
                return -1
            }
        }
        
        return -1
    }
    
    func selectFirstItem() {
        if self.customPickerType == .string && self.pickerData.count > 1 {
            self.buttonTitle = self.pickerData[1]
        }
        
    }
    
    func selectIndex(index: Int) {
        if self.customPickerType == .string && self.pickerData.count > (index+1) {
            self.buttonTitle = self.pickerData[index+1]
        }
        
    }
    
    
}
