//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: CustomOptionsDateAndTimeTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit
import ActionSheetPicker_3_0

class CustomOptionsDateAndTimeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var headingLabel: UILabel!
    var dateType: UIDatePicker.Mode = .date
    let dateFormatterGet = DateFormatter()
    var customDict = [String: Any]()
    var parentID = ""
    weak var delegate: GettingCustomData?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.isUserInteractionEnabled = true
        textField.delegate = self
        textField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapCountryView)))
        
    }
    
    override func layoutSubviews() {
        if let val = customDict[parentID] as? [String: String]  {
            
            var date = ""
            if let day = val["day"], let month = val["month"], let year = val["year"] {
                date += day + "-"
                date += month + "-"
                date += year
            }
            var time = ""
            if let hour = val["hour"], let minute = val["minute"], let day_part = val["day_part"] {
                time += "("
                time += hour + ":"
                time += minute + " "
                time += day_part + ")"
            }
            if dateType == .date {
                textField.text = date
            } else if dateType == .dateAndTime {
                textField.text = date + " " + time
            } else if dateType == .time {
                textField.text = time
            }
            
        }
    }
    
    @objc private func didTapCountryView() {
        if dateType == .date {
            dateFormatterGet.dateFormat = "yyyy-MM-dd"
        } else if dateType == .dateAndTime {
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        } else if dateType == .time {
            dateFormatterGet.dateFormat = "HH:mm:ss"
        }
        
        let gg =  ActionSheetDatePicker(title: headingLabel.text ?? "", datePickerMode: dateType, selectedDate: Date(), doneBlock: { _, selectedDate, origin in
            
            if let selectedDate = selectedDate as? Date {
                let dateString = self.dateFormatterGet.string(from: selectedDate)
                print(dateString)
                let calendar = Calendar.current
                var dict = [String: String]()
                
                if self.dateType == .date {
                    dict["month"] = selectedDate.monthAsString()
                    dict["year"] = selectedDate.yearAsString()
                    dict["day"] = selectedDate.dayAsString()
                    self.customDict[self.parentID] = dict
                } else if self.dateType == .dateAndTime {
                    dict["month"] = selectedDate.monthAsString()
                    dict["year"] = selectedDate.yearAsString()
                    dict["day"] = selectedDate.dayAsString()
                    dict["hour"] = selectedDate.hourAsString()
                    dict["minute"] = selectedDate.minuteAsString()
                    dict["day_part"] = selectedDate.amAsString()
                    self.customDict[self.parentID] = dict
                } else if self.dateType == .time {
                    dict["hour"] = selectedDate.hourAsString()
                    dict["minute"] = selectedDate.minuteAsString()
                    dict["day_part"] = selectedDate.amAsString()
                    self.customDict[self.parentID] = dict
                }
                self.delegate?.gettingCustomData(data: self.customDict)
                self.textField.text = dateString
            }
            //            self.fetchHistoryForDate()
        }, cancel: { _ in
            print("Block Picker Canceled")
        }, origin: self.textField)
        
        //        let gg =  ActionSheetStringPicker(title: headingLabel.text ?? "", rows: optionValues.map { $0.title }, initialSelection: row, doneBlock: { _, indexes, _ in
        //            self.textField.text = self.optionValues[indexes].title
        //            self.qtyLabel.text =  self.optionValues[indexes].defaultQty
        //            self.bundleDict[self.parentID] = self.optionValues[indexes].optionValueId
        //            self.delegate?.gettingBundleData(data: self.bundleDict)
        //        }, cancel: { _ in
        //            UIBarButtonItem.appearance().tintColor = UIColor.white
        //            return }, origin: self.textField)
        
        //            toolbar?.setCancelButton(UIBarButtonItem.init(title: "PICKER_Cancel".localized, style: .done, target: self, action: nil))
        gg?.setCancelButton(UIBarButtonItem.init(title: "Cancel".localized, style: .done, target: self, action: nil))
        gg?.setDoneButton(UIBarButtonItem.init(title: "Done".localized, style: .done, target: self, action: nil))
        gg?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]//this is actually the title of toolbar
        gg?.toolbarButtonsColor = UIColor.black
        
        gg?.show()
    }
}

extension CustomOptionsDateAndTimeTableViewCell: UITextFieldDelegate {
    
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

extension Date {
    func monthAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MM")
        return df.string(from: self)
    }
    
    func dayAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("dd")
        return df.string(from: self)
    }
    
    func yearAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("yyyy")
        return df.string(from: self)
    }
    
    func hourAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("HH")
        return df.string(from: self)
    }
    
    func minuteAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("mm")
        return df.string(from: self)
    }
    
    func amAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("a")
        return df.string(from: self)
    }
}
