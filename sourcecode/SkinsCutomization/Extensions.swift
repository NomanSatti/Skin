

import UIKit
import Foundation
import SVProgressHUD
import SwiftMessages
import CoreFoundation
import AlamofireImage
import UserNotifications
import ActionSheetPicker_3_0


typealias HUD = SVProgressHUD

private var bundleKey: UInt8 = 0

final class BundleExtension: Bundle {
    
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        return (objc_getAssociatedObject(self, &bundleKey) as? Bundle)?.localizedString(forKey: key, value: value, table: tableName) ?? super.localizedString(forKey: key, value: value, table: tableName)
    }
}

enum Language: Equatable {
    case english
    case arabic
    case none
}

extension Language {
    
    var code: String {
        switch self {
        case .english:
            return "en"
            
        case .arabic:
            return "ar"
            
        case .none:
            return ""
        }
    }
    
    var name: String {
        switch self {
        case .english:
            return "English"
            
        case .arabic:
            return "Arabic"
            
        case .none:
            return ""
        }
    }
}

extension Language {
    
    init?(languageCode: String?) {
        guard let languageCode = languageCode else { return nil }
        switch languageCode {
        case "en":     self = .english
        case "ar":     self = .arabic
        default:                return nil
        }
    }
}


extension Bundle {
    
    static let once: Void = { object_setClass(Bundle.main, type(of: BundleExtension())) }()
    
    static func set(language: Language) {
        Bundle.once
        
        let isLanguageRTL = Locale.characterDirection(forLanguage: language.code) == .rightToLeft
        UIView.appearance().semanticContentAttribute = isLanguageRTL == true ? .forceRightToLeft : .forceLeftToRight
        
        UserDefaults.standard.set(isLanguageRTL,   forKey: "AppleTe  zxtDirection")
        UserDefaults.standard.set(isLanguageRTL,   forKey: "NSForceRightToLeftWritingDirection")
        UserDefaults.standard.set([language.code], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        guard let path = Bundle.main.path(forResource: language.code, ofType: "lproj") else {
            //log(.error, "Failed to get a bundle path.")
            return
        }
        
        objc_setAssociatedObject(Bundle.main, &bundleKey, Bundle(path: path), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

struct LocaleManager {
    
    /// "ko-US" → "ko"
    static var languageCode: String? {
        guard var splits = Locale.preferredLanguages.first?.split(separator: "-"), let first = splits.first else { return nil }
        guard 1 < splits.count else { return String(first) }
        splits.removeLast()
        return String(splits.joined(separator: "-"))
    }
    
    static var language: Language? {
        return Language(languageCode: languageCode)
    }
}

//MARK:- Int Extension
extension Int {
    var isEven:Bool     {return (self % 2 == 0)}
    var isOdd:Bool      {return (self % 2 != 0)}
    var isPositive:Bool {return (self >= 0)}
    var isNegative:Bool {return (self < 0)}
    var toDouble:Double {return Double(self)}
    var toFloat:Float   {return Float(self)}
    
    var digits:Int {
        if(self == 0) {
            return 1
        } else if(Int(fabs(Double(self))) <= LONG_MAX) {
            return Int(log10(fabs(Double(self)))) + 1
        } else {
            return -1; //out of bound
        }
    }
}


//MARK:- Double Extension
extension Double {
    func roundToDecimalDigits(_ decimals:Int) -> Double {
        
        let format : NumberFormatter = NumberFormatter()
        format.numberStyle = NumberFormatter.Style.decimal
        format.roundingMode = NumberFormatter.RoundingMode.halfUp
        format.maximumFractionDigits = 2
        let string: NSString = format.string(from: NSNumber(value: self as Double))! as NSString
        //        print(string.doubleValue)
        return string.doubleValue
    }
}

//MARK:- Sequence Extension
extension Sequence {
    
    func splitBefore(
        
        separator isSeparator: (Iterator.Element) throws -> Bool
        ) rethrows -> [AnySequence<Iterator.Element>] {
        var result: [AnySequence<Iterator.Element>] = []
        var subSequence: [Iterator.Element] = []
        
        var iterator = self.makeIterator()
        while let element = iterator.next() {
            if try isSeparator(element) {
                if !subSequence.isEmpty {
                    result.append(AnySequence(subSequence))
                }
                subSequence = [element]
            }
            else {
                subSequence.append(element)
            }
        }
        result.append(AnySequence(subSequence))
        return result
    }
}


//MARK:- Character Extension
extension Character {
    var isUpperCase: Bool { return String(self) == String(self).uppercased() }
}


//MARK:- String Extension
extension String {
    
    var floatRoundedString: String! {
        
        if let floatSelf = Float(self) {
            
            let reminder = floatSelf - Float(Int(floatSelf))
            
            if (reminder == 0) {
                return String(format: "%.f", floatSelf)
            } else if reminder < 0.05 {
                return String(format: "%.02f", floatSelf)
            } else {
                return String(format: "%.01f", floatSelf)
            }
        } else {
            return self
        }
    }
    
    var first: String {
        return String(self.prefix(1))
    }
    var last: String {
        return String(self.suffix(1))
    }
    var uppercaseFirst: String {
        return first.uppercased() + self.dropFirst()
    }
    
   /* var localized: String {
        
        let path = Bundle.main.path(forResource: LoggedInUserHelper.sharedInstance.currentLanguage.code, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }*/
    
    func defaultDateIfZero() -> String {
        
        if self == "0000-00-00" {
            return "2017-01-01"
        } else if self == "0000-00-00 00:00:00" {
            return "2017-01-01 10:00:00"
        } else {
            return self
        }
    }
    
    func splittedCamelCaseString() -> String {
        
        let splitted = self.splitBefore(separator: { $0.isUpperCase }).map{String($0)}
        let joinedString = splitted.joined(separator: " ")
        return joinedString
    }
    
    func isValidEmail() -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
    func stringWithoutSupHTML() -> String {
        
        return self.replace("", withString: "<sup>").replace("</sup>", withString: "")
    }
    
    var boolValue: Bool { return NSString(string: self).boolValue }
    
    func containsString(_ s:String) -> Bool {
        
        if self.range(of: s) != nil {
            return true
        } else {
            return false
        }
    }
    
    func containsString(_ s:String, compareOption: NSString.CompareOptions) -> Bool {
        
        if(self.range(of: s, options: compareOption)) != nil {
            return true
        } else {
            return false
        }
    }
    
    func cleanedString() ->  String {
        
        return self.removeLeadingAndTrailingSpaces()
    }
    
    func removeLeadingAndTrailingSpaces() ->  String {
        
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    var lastPathComponent: String {
        
        get {
            return (self as NSString).lastPathComponent
        }
    }
    var pathExtension: String {
        
        get {
            
            return (self as NSString).pathExtension
        }
    }
    var stringByDeletingLastPathComponent: String {
        
        get {
            
            return (self as NSString).deletingLastPathComponent
        }
    }
    var stringByDeletingPathExtension: String {
        
        get {
            
            return (self as NSString).deletingPathExtension
        }
    }
    var pathComponents: [String] {
        
        get {
            
            return (self as NSString).pathComponents
        }
    }
    
    func stringByAppendingPathComponent(_ path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.appendingPathComponent(path)
    }
    
    func stringByAppendingPathExtension(_ ext: String) -> String? {
        
        let nsSt = self as NSString
        
        return nsSt.appendingPathExtension(ext)
    }
    
    func formatString() -> String {
        
        if self.count == 10 {
            
            var list: [Int] = []
            for char in self {
                if let integerVal = Int("\(char)") {
                    list.append(integerVal)
                } else {
                    return self
                }
            }
            return "(\(list[0])\(list[1])\(list[2])) \(list[3])\(list[4])\(list[5])-\(list[6])\(list[7])\(list[8])\(list[9])"
        } else {
            return self
        }
    }
    
    func validateNPI() -> Bool{
        
        let list: [Int] = self.map({Int(String($0))!})
        
        var sum = 0
        //Double value of alternating digits, add the sum of their resulting product's digits
        sum = sumDigits(list[8] * 2) + sumDigits(list[6] * 2) + sumDigits(list[4] * 2) + sumDigits(list[2] * 2) + sumDigits(list[0] * 2) + 24;
        sum += list[1] + list[3] + list[5] + list[7];
        
        //Subtract the next highest number divisible by 10 from the sum (gives us check digit)
        if (sum % 10 != 0)
        {
            sum = (sum + (10 - (sum % 10))) - sum;
        }
        else
        {
            sum = 0; //Check digit must be zero
        }
        
        if (sum == list[9])
        {
            return true
        }
        else
        {
            return false
        }
        
    }
    
    func sumDigits(_ number: Int) -> Int {
        
        var sum = 0
        
        var value = number
        
        while (value > 0) {
            
            sum += (value % 10)
            value = value / 10
        }
        
        return sum
    }
    
    func removePrecedingZeroes() -> String {
        
        var zeros = self
        
        while zeros.hasPrefix("0"){
            let index = zeros.index(after: zeros.startIndex)
            zeros = String(zeros[index...])
        }
        
        return zeros
    }
    
    func hasPrecedingZeroes() -> Bool {
        
        var zeroCount = 0
        
        var zeros = self
        
        while zeros.hasPrefix("0") {
            let index = zeros.index(after: zeros.startIndex)
            zeros = String(zeros[index...])
            zeroCount = zeroCount + 1
        }
        
        if zeroCount > 1 {
            return true
        }
        
        return false
    }
    
    func getPlainStringFromEnum() -> String{
        let array = self.components(separatedBy: "_")
        
        if array.count > 1{
            return array.last!.capitalized
        }
        else if array.count == 1{
            return array.first!.capitalized
        }
        
        return ""
    }
    
    func secondsToHoursMinutesSeconds() -> String {
        
        guard let number = Int(self) else {
            return "00:00:00"
        }
        
        let hours = number / 3600
        let minutes = (number % 3600) / 60
        let seconds = (number % 3600) % 60
        
        return "\(timeText(hours)):\(timeText(minutes)):\(timeText(seconds))"
    }
    
    func timeText(_ number: Int) -> String {
        return number < 10 ? "0\(number)" : "\(number)"
    }
}


//MARK:- NSAttributedString Extension
extension NSAttributedString {
    
}


//MARK:- UIWindow Extension
extension UIWindow {
    
}

//MARK:- UIBarButtonItem
extension UIBarButtonItem {
    
    func getBarButton(_ title : String) -> UIBarButtonItem {
        let cancelButton =  UIButton.init(type: UIButton.ButtonType.custom)
        cancelButton.setTitle(title, for: .normal)
        //
        //        if K.IS_IPAD {
        //            cancelButton.titleLabel?.font = UIFont.robotoRegular(14)
        //        }else{
        //            cancelButton.sizeToFit()
        //        }
        cancelButton.sizeToFit()
        cancelButton.backgroundColor = UIColor.clear
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        
        return UIBarButtonItem.init(customView: cancelButton)
    }
}


//MARK:- UIViewController Extension
extension UIViewController {
    
    func showDatePicker(_ sender: UIButton, title: String = "Select Date", minimumDate: Date? = nil, maximumDate: Date? = nil, mode: UIDatePicker.Mode = UIDatePicker.Mode.date, doneBlock: @escaping (_ selectedDate: Date) -> Void) {
        
        let mainContainer = CurrentUser.sharedInstance
        
        var date = Date()
        var dateFormat = ""
        
        if mode == .time {
            
            dateFormat = K.TimeFormatShort2
            
        } else if mode == .dateAndTime{
            
            dateFormat = K.DateTimeFormatStandard2
            
        } else if mode == .date {
            
            dateFormat = K.DateFormatStandard
        }
        
        if let selectedDate = sender.title(for: .normal){
            
            if let btnDate = DateHelper.dateFromString(selectedDate, dateFormat: K.DateFormatStandard) {
                
                date = btnDate
                dateFormat = K.DateFormatStandard
                
            } else if let btnDate = DateHelper.dateFromString(selectedDate, dateFormat: K.DateTimeFormatStandard2) {
                
                date = btnDate
                dateFormat = K.DateTimeFormatStandard2
                
            } else if  let btnDate = DateHelper.dateFromString(selectedDate, dateFormat: K.TimeFormatShort2) {
                date = btnDate
                dateFormat = K.TimeFormatShort2
            }
        }
       
        mainContainer.dateActionSheetPicker = ActionSheetDatePicker.init(title: title,
                                                                         datePickerMode: mode,
                                                                         selectedDate: date,
                                                                         doneBlock: { (picker, selectedDate, item) in
                                                                            let date = DateHelper.stringFromDate(selectedDate as! Date, dateFormat: dateFormat)
                                                                            sender.setTitle(date, for: .normal)
                                                                            
                                                                            doneBlock(selectedDate as! Date)
                                                                            
        }, cancel: { (picker) in
            
        }, origin: sender)
        
        if let max = maximumDate{
            mainContainer.dateActionSheetPicker!.maximumDate = max
        }
        
        if let min = minimumDate{
            mainContainer.dateActionSheetPicker!.minimumDate = min
        }
        
        mainContainer.dateActionSheetPicker!.setCancelButton(UIBarButtonItem().getBarButton("Cancel".localized))
        mainContainer.dateActionSheetPicker!.setDoneButton(UIBarButtonItem().getBarButton("Done".localized))
        mainContainer.dateActionSheetPicker!.show()
    }
    
    func showSimpleDatePickerWithOrigin(initialDate date: Date? = nil, origin: UIView? , _ doneBlock: @escaping (_ selectedDate: Date) -> Void) {
        
        let mainContainer = CurrentUser.sharedInstance
        
        mainContainer.dateActionSheetPicker = ActionSheetDatePicker.init(title: title, datePickerMode: .date, selectedDate: date ?? Date(), doneBlock: { (picker, selectedDate, item) in
            doneBlock(selectedDate as! Date)
        }, cancel: { (picker) in
        }, origin: origin)
        
        mainContainer.dateActionSheetPicker!.setCancelButton(UIBarButtonItem().getBarButton("Cancel".localized))
        mainContainer.dateActionSheetPicker!.setDoneButton(UIBarButtonItem().getBarButton("Done".localized))
        mainContainer.dateActionSheetPicker!.show()
    }
    
    func showStringPicker(_ sender: UIButton, title: String, items: [String], doneBlock: @escaping (_ item: Any?, _ index: Int?)-> Void) {
        
        let mainContainer = CurrentUser.sharedInstance
        var index = 0
        if let ind = items.map({$0.lowercased()}).index(of: sender.title(for: .normal)!.lowercased()) {
            index = ind
        }
        
        mainContainer.stringActionSheetPicker = ActionSheetStringPicker(title: title, rows: items as [Any], initialSelection: index, doneBlock: { (picker : ActionSheetStringPicker?, selectedIndex : Int, selectedItem : Any?) in
            doneBlock(selectedItem, selectedIndex)
            mainContainer.stringActionSheetPicker = nil

        }, cancel: { (picker : ActionSheetStringPicker?) in
            mainContainer.stringActionSheetPicker = nil

        }, origin: sender)
        
        mainContainer.stringActionSheetPicker!.setCancelButton(UIBarButtonItem().getBarButton("Cancel".localized))
        mainContainer.stringActionSheetPicker!.setDoneButton(UIBarButtonItem().getBarButton("Done".localized))
        mainContainer.stringActionSheetPicker!.show()
    }
    
    func showSimpleDatePicker(initialDate date: Date? = nil, _ doneBlock: @escaping (_ selectedDate: Date) -> Void) {
        
        let mainContainer = CurrentUser.sharedInstance
        
        mainContainer.dateActionSheetPicker = ActionSheetDatePicker.init(title: title, datePickerMode: .date, selectedDate: date ?? Date(), doneBlock: { (picker, selectedDate, item) in
            doneBlock(selectedDate as! Date)

        }, cancel: { (picker) in

        }, origin: self.view)
        
        mainContainer.dateActionSheetPicker!.setCancelButton(UIBarButtonItem().getBarButton("Cancel".localized))
        mainContainer.dateActionSheetPicker!.setDoneButton(UIBarButtonItem().getBarButton("Done".localized))
        mainContainer.dateActionSheetPicker!.show()
    }
    
    func showLoadingActivity() {
        
        HUD.showLoading()
        
    }
    
    func hideLoadingActivity() {
        
        HUD.dismiss()
    }
    
    func addChildViewController(_ controller: UIViewController,
                                containerView: UIView,
                                preserverViewController: UIViewController? = nil) {
        
        self.removeAllChildViewControllers(preserverViewController)
        
        self.addChild(controller)
        controller.view.frame = containerView.bounds
        containerView.insertSubview(controller.view, at: 0)
        controller.didMove(toParent: self)
        
        controller.view.layoutIfNeeded()
    }
    
    func removeAllChildViewControllers(_ except: UIViewController? = nil) {
        
        func removeVCFromParent(_ childController: UIViewController) {
            childController.willMove(toParent: nil)
            childController.view.removeFromSuperview()
            childController.removeFromParent()
        }
        
        for childController in self.children {
            
            if except == nil {
                removeVCFromParent(childController)
            } else if except != nil && except != childController {
                removeVCFromParent(childController)
            }
        }
    }
    
    func showErrorAlertView(title: String = "Error", message: String = "", actionHandler:(() -> Void)? = nil) {
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction) in
            actionHandler?()
        }))
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    func showConfirmationAlertView(title: String = "Confirmation".localized,
                                   message: String = "",
                                   cancelTitle: String = "No",
                                   confirmTitle: String = "Yes",
                                   rejectionHandler:(() -> Void)? = nil,
                                   confirmationHandler:@escaping (() -> Void)) {
        
        let alertView = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
        
        alertView.addAction(UIAlertAction(title: confirmTitle,
                                          style: .default,
                                          handler: { (action: UIAlertAction) in
                                            confirmationHandler() }))
        
        alertView.addAction(UIAlertAction(title: cancelTitle,
                                          style: .cancel,
                                          handler: { (action: UIAlertAction) in
                                            
                                            rejectionHandler?()
        }))
        // Comment by Zeeshan Haider on August 30, 2018
        // #BugId : https://mecoshealth.atlassian.net/browse/CC-4710
        alertView.modalPresentationStyle = UIModalPresentationStyle.popover
        if let popoverController = alertView.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.height, width: 0, height: 0)
            popoverController.dimmingView?.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alertView, animated: true,
                     completion: nil)
    }
    
    func showChangePasswordAlertView(title: String = "Change Password",
                                     message: String,
                                     cancelTitle: String = "Later",
                                     confirmTitle: String = "Change",
                                     showCancelOption: Bool = true,
                                     confirmationHandler:@escaping (() -> Void)) {
        
        let alertView = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
        
        alertView.addAction(UIAlertAction(title: confirmTitle,
                                          style: .default,
                                          handler: { (action: UIAlertAction) in
                                            confirmationHandler() }))
        
        if showCancelOption {
            alertView.addAction(UIAlertAction(title: cancelTitle,
                                              style: .cancel,
                                              handler: nil))
        }
        
        // Comment by Zeeshan Haider on August 30, 2018
        // #BugId : https://mecoshealth.atlassian.net/browse/CC-4710
        alertView.modalPresentationStyle = UIModalPresentationStyle.popover
        if let popoverController = alertView.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.height, width: 0, height: 0)
            popoverController.dimmingView?.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alertView,
                     animated: true,
                     completion: nil)
    }
    
    enum ImageSource {
        case camera
        case imageLibrary
    }
    
    func showActionSheetForImageInput(title: String? = nil,
                                      message: String = "Choose Image Source",
                                      cancelTitle: String = "Cancel",
                                      confirmationHandler:@escaping ((_ imageSource: ImageSource) -> Void)) {
        
        let alertView = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .actionSheet)
        
        alertView.addAction(UIAlertAction(title: "Camera",
                                          style: .default,
                                          handler: { (action: UIAlertAction) in
                                            confirmationHandler(.camera) }))
        
        alertView.addAction(UIAlertAction(title: "Photo Library",
                                          style: .default,
                                          handler: { (action: UIAlertAction) in
                                            confirmationHandler(.imageLibrary) }))
        
        alertView.addAction(UIAlertAction(title: cancelTitle,
                                          style: .cancel,
                                          handler: nil))
        
        // Comment by Zeeshan Haider on August 30, 2018
        // #BugId : https://mecoshealth.atlassian.net/browse/CC-4710
        alertView.modalPresentationStyle = UIModalPresentationStyle.popover
        if let popoverController = alertView.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.height, width: 0, height: 0)
            popoverController.dimmingView?.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alertView, animated: true,
                     completion: nil)
    }
    
    func checkNotificationPermissions(permission: @escaping ((Bool) -> Void)) {
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            
            permission(granted)
            
            if granted == false {
                
                DispatchQueue.main.async(execute: {
                    let alertController = UIAlertController(title: "Notification Alert", message: "Kindly enable push notifications for using this service.", preferredStyle: .alert)
                    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            })
                        }
                    }
                    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                    alertController.addAction(cancelAction)
                    alertController.addAction(settingsAction)
                    
                    if let popoverController = alertController.popoverPresentationController {
                        popoverController.sourceView = self.view
                        popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.height, width: 0, height: 0)
                        popoverController.permittedArrowDirections = []
                    }
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                })
            }
        }
    }
}

//MARK:- HUD
extension HUD {
    
    class func showLoading() {
        
        HUD.show()
    }
}

//MARK:- SwiftMessages
extension SwiftMessages {
    
    class func showToast(_ message: String, type: Theme = .warning, buttonTitle: String? = nil) {
        
        let view = MessageView.viewFromNib(layout: .cardView)
        
        if let buttonTitle = buttonTitle {
            
            view.configureContent(title: nil,
                                  body: message,
                                  iconImage: nil,
                                  iconText: nil,
                                  buttonImage: nil,
                                  buttonTitle: buttonTitle, buttonTapHandler: { _ in SwiftMessages.hide() })
        } else {
            view.configureContent(title: "", body: message)
            view.button?.isHidden = true
        }
        
        view.bodyLabel?.font = UIFont.robotoRegular(13.0)
        view.configureTheme(type, iconStyle: .default)
        view.configureDropShadow()
        view.titleLabel?.isHidden = true
        view.backgroundView.backgroundColor = UIColor.black
        
        var config = SwiftMessages.defaultConfig
        config.dimMode = .gray(interactive: false)
        config.interactiveHide = true
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        config.duration = .seconds(seconds: type == .warning ? 1.5:3.0)
        
        SwiftMessages.show(config: config, view: view)
    }
    
    
    class func showMessageToast(_ message: String, title: String) -> UIView {
        
        // Instantiate a message view from the provided card view layout. SwiftMessages searches for nib
        // files in the main bundle first, so you can easily copy them into your project and make changes.
        let view = MessageView.viewFromNib(layout: .messageView)
        
        view.button?.isHidden = true
        
        // Theme message elements with the warning style.
        view.configureTheme(.info)
        
        // Add a drop shadow.
        view.configureDropShadow()
        
        view.configureContent(title: title, body: message)
        
        return view
        // Show the message.
        //SwiftMessages.show(view: view)
        
    }
}

//MARK:- UIView Extension
extension UIView {
    
    var origin:     CGPoint { return self.frame.origin }
    var x:          CGFloat { return self.frame.origin.x }
    var y:          CGFloat { return self.frame.origin.y }
    var centerX:    CGFloat { return self.center.x }
    var centerY:    CGFloat { return self.center.y }
    
    var left:       CGFloat { return self.frame.origin.x }
    var right:      CGFloat { return self.frame.origin.x + self.frame.size.width }
    var top:        CGFloat { return self.frame.origin.y }
    var bottom:     CGFloat { return self.frame.origin.y + self.frame.size.height }
    
    func setWidth(_ width:CGFloat)
    {
        self.frame.size.width = width
    }
    
    func setHeight(_ height:CGFloat)
    {
        self.frame.size.height = height
    }
    
    func setSize(_ size:CGSize)
    {
        self.frame.size = size
    }
    
    func setOrigin(_ point:CGPoint)
    {
        self.frame.origin = point
    }
    
    func setX(_ x:CGFloat) //only change the origin x
    {
        self.frame.origin = CGPoint(x: x, y: self.frame.origin.y)
    }
    
    func setY(_ y:CGFloat) //only change the origin x
    {
        self.frame.origin = CGPoint(x: self.frame.origin.x, y: y)
    }
    
    func setCenterX(_ x:CGFloat) //only change the origin x
    {
        self.center = CGPoint(x: x, y: self.center.y)
    }
    
    func setCenterY(_ y:CGFloat) //only change the origin x
    {
        self.center = CGPoint(x: self.center.x, y: y)
    }
    
    func roundCorner(_ radius:CGFloat)
    {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
    
    func roundedView(_ withBorder: Bool = false)
    {
        self.layer.layoutIfNeeded()
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width / 2
        if withBorder {
            self.addBorder()
        }
    }
    
    func addBorder(_ borderColor: UIColor = UIColor.gray,
                   borderWidth: CGFloat = 0.5) {
        
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    
    func setTop(_ top:CGFloat)
    {
        self.frame.origin.y = top
    }
    
    func setLeft(_ left:CGFloat)
    {
        self.frame.origin.x = left
    }
    
    func setRight(_ right:CGFloat)
    {
        self.frame.origin.x = right - self.frame.size.width
    }
    
    func setBottom(_ bottom:CGFloat)
    {
        self.frame.origin.y = bottom - self.frame.size.height
    }
    
    func addShadow(_ radius: CGFloat, offset: CGSize) {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 0.45
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
    
    func addDropShadow() {
        self.addShadow(1, offset: CGSize(width: -1, height: 1))
    }
    
    func addUpperShadow() {
        
        self.layoutIfNeeded()
        self.addShadow(1, offset: CGSize(width: 1, height: -1))
    }
    
    enum ShakeDirection {
        case horizontal
        case vertical
    }
    
    func shake(_ times: Int = 10,
               direction: Int = 1,
               currentTimes: Int = 0,
               delta: CGFloat = 5.0,
               interval: TimeInterval = 0.03,
               shakeDirection: ShakeDirection = .horizontal) {
        
        UIView.animate(withDuration: interval, animations: {
            self.transform = shakeDirection == .horizontal ? CGAffineTransform(translationX: delta * CGFloat(direction), y: 0) : CGAffineTransform(translationX: 0, y: delta * CGFloat(direction))
        }, completion: { (completed) in
            
            if currentTimes >= times {
                
                UIView.animate(withDuration: interval, animations: {
                    self.transform = CGAffineTransform.identity
                })
                return
            }
            
            self.shake(times-1,
                       direction: (direction * -1),
                       currentTimes: currentTimes+1,
                       delta: delta,
                       interval: interval,
                       shakeDirection: shakeDirection)
        })
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as? UIViewController
            }
        }
        return nil
    }
}

//MARK:- UIImageView Extension
extension UIImageView {
    
}

//MARK:- UIImage Extension
extension UIImage {
    func croppedImage(_ bound : CGRect) -> UIImage
    {
        let scaledBounds : CGRect = CGRect(x: bound.origin.x * self.scale,
                                           y: bound.origin.y * self.scale,
                                           width: bound.size.width * self.scale,
                                           height: bound.size.height * self.scale)
        
        let imageRef = self.cgImage?.cropping(to: scaledBounds)
        
        let croppedImage : UIImage = UIImage(cgImage: imageRef!,
                                             scale: self.scale,
                                             orientation: UIImage.Orientation.up)
        return croppedImage
    }
    
    func compressImage() -> Data {
        let compressionQuality : CGFloat = 0.5
        
        let rect = CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = img!.jpegData(compressionQuality: compressionQuality)
        UIGraphicsEndImageContext()
        
        return imageData!
    }
}



//MARK:- UITextField Extension


//MARK:- UILabel Extension
extension UILabel {
    
    func setupNoDataFoundLabel(_ message: String) {
        
        self.isHidden = true
        self.font = UIFont.robotoRegular(K.IS_IPAD ? 16 : 12.0)
        self.textAlignment = .center
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
        self.textColor = UIColor.darkGray
        self.text = message
    }
}



//MARK:- NSUserDefaults Extension
extension UserDefaults {
    public subscript(key: String) -> AnyObject? {
        get {
            return object(forKey: key) as AnyObject?
        }
        set {
            set(newValue, forKey: key)
        }
    }
}



//MARK:- UIFont Extension
extension UIFont {
    class func robotoBlack(_ size:CGFloat) -> UIFont {
        
        return UIFont(name: K.FontNameRobotoBlack,
                      size: size)!
    }
    
    class func robotoBold(_ size:CGFloat) -> UIFont {
        
        return UIFont(name: K.FontNameRobotoBold,
                      size: size)!
    }
    
    class func robotoItalic(_ size:CGFloat) -> UIFont {
        
        return UIFont(name: K.FontNameRobotoItalic,
                      size: size)!
        
    }
    
    class func robotoLight(_ size:CGFloat) -> UIFont {
        
        return UIFont(name: K.FontNameRobotoLight,
                      size: size)!
    }
    
    class func robotoMedium(_ size:CGFloat) -> UIFont {
        
        return UIFont(name: K.FontNameRobotoMedium,
                      size: size)!
    }
    
    class func robotoRegular(_ size:CGFloat) -> UIFont {
        
        return UIFont(name: K.FontNameRobotoRegular,
                      size: size)!
    }
    
    class func robotoThin(_ size:CGFloat) -> UIFont {
        
        return UIFont(name: K.FontNameRobotoThin,
                      size: size)!
    }
    
    class func robotoCondensedBold(_ size:CGFloat) -> UIFont {
        
        return UIFont(name: K.FontNameRobotoCondensedBold,
                      size: size)!
        
    }
    
    class func robotoCondensedRegular(_ size:CGFloat) -> UIFont {
        
        return UIFont(name: K.FontNameRobotoCondensedRegular,
                      size: size)!
    }
}

//MARK:- UITableViewCell
extension UITableViewCell {
    
    func removeSeparatorInsets() {
        
        self.layoutMargins = UIEdgeInsets.zero
        self.separatorInset = UIEdgeInsets.zero
    }
}



//MARK:- UIDevice Extension
private let DeviceList = [
    /* iPod 5 */          "iPod5,1": "iPod Touch 5",
                          /* iPod 6 */          "iPod7,1": "iPod Touch 6",
                                                /* iPhone 4 */        "iPhone3,1":  "iPhone 4", "iPhone3,2": "iPhone 4", "iPhone3,3": "iPhone 4",
                                                                      /* iPhone 4S */       "iPhone4,1": "iPhone 4S",
                                                                                            /* iPhone 5 */        "iPhone5,1": "iPhone 5", "iPhone5,2": "iPhone 5",
                                                                                                                  /* iPhone 5C */       "iPhone5,3": "iPhone 5C", "iPhone5,4": "iPhone 5C",
                                                                                                                                        /* iPhone 5S */       "iPhone6,1": "iPhone 5S", "iPhone6,2": "iPhone 5S",
                                                                                                                                                              /* iPhone 6 */        "iPhone7,2": "iPhone 6",
                                                                                                                                                                                    /* iPhone 6 Plus */   "iPhone7,1": "iPhone 6 Plus",
                                                                                                                                                                                                          /* iPhone 6S */       "iPhone8,1": "iPhone 6S",
                                                                                                                                                                                                                                /* iPhone 6S Plus */  "iPhone8,2": "iPhone 6S Plus",
                                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                      /* iPad 2 */          "iPad2,1": "iPad 2", "iPad2,2": "iPad 2", "iPad2,3": "iPad 2", "iPad2,4": "iPad 2",
                                                                                                                                                                                                                                                                            /* iPad 3 */          "iPad3,1": "iPad 3", "iPad3,2": "iPad 3", "iPad3,3": "iPad 3",
                                                                                                                                                                                                                                                                                                  /* iPad 4 */          "iPad3,4": "iPad 4", "iPad3,5": "iPad 4", "iPad3,6": "iPad 4",
                                                                                                                                                                                                                                                                                                                        /* iPad Air */        "iPad4,1": "iPad Air", "iPad4,2": "iPad Air", "iPad4,3": "iPad Air",
                                                                                                                                                                                                                                                                                                                                              /* iPad Air 2 */      "iPad5,3": "iPad Air 2", "iPad5,4": "iPad Air 2",
                                                                                                                                                                                                                                                                                                                                                                    /* iPad Mini */       "iPad2,5": "iPad Mini", "iPad2,6": "iPad Mini", "iPad2,7": "iPad Mini",
                                                                                                                                                                                                                                                                                                                                                                                          /* iPad Mini 2 */     "iPad4,4": "iPad Mini 2", "iPad4,5": "iPad Mini 2", "iPad4,6": "iPad Mini 2",
                                                                                                                                                                                                                                                                                                                                                                                                                /* iPad Mini 3 */     "iPad4,7": "iPad Mini 3", "iPad4,8": "iPad Mini 3", "iPad4,9": "iPad Mini 3",
                                                                                                                                                                                                                                                                                                                                                                                                                                      /* iPad Mini 4 */     "iPad5,1": "iPad Mini 4", "iPad5,2": "iPad Mini 4",
                                                                                                                                                                                                                                                                                                                                                                                                                                                            /* iPad Pro */        "iPad6,7": "iPad Pro", "iPad6,8": "iPad Pro",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  /* AppleTV */         "AppleTV5,3": "AppleTV",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        /* Simulator */       "x86_64": "Simulator", "i386": "Simulator"]
extension UIDevice {
    
    public enum iPhoneType: String {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case iPhoneX
        case Unknown
    }
    
    public var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    
    public var isIPhone5: Bool! { return self.sizeType == .iPhone5 }
    public var isIPhone4: Bool! { return self.sizeType == .iPhone4 }
    public var isIPhoneX: Bool! { return self.sizeType == .iPhoneX }
    
    public var sizeType: iPhoneType! {
        guard iPhone else { return .Unknown }
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhone5
        case 1334:
            return .iPhone6
        case 2208:
            return .iPhone6Plus
        case 2436:
            return .iPhoneX
        default:
            return .Unknown
        }
    }
    
    public class func idForVendor() -> String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    
    // Operating system name
    public class func systemName() -> String {
        return UIDevice.current.systemName
    }
    
    // Operating system version
    public class func systemVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    // Operating system version
    public class func systemFloatVersion() -> Float {
        return (systemVersion() as NSString).floatValue
    }
    
    public class func deviceName() -> String {
        return UIDevice.current.name
    }
    
    public class func deviceLanguage() -> String {
        return Bundle.main.preferredLocalizations[0]
    }
    
    public class func deviceModelReadable() -> String {
        return DeviceList[deviceModel()] ?? deviceModel()
    }
    
    /// Returns true if the device is iPhone //TODO: Add to readme
    public class func isPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }
    
    /// Returns true if the device is iPad //TODO: Add to readme
    public class func isPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
    
    public class func deviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machine = systemInfo.machine
        var identifier = ""
        let mirror = Mirror(reflecting: machine)
        
        for child in mirror.children {
            let value = child.value
            
            if let value = value as? Int8, value != 0 {
                identifier.append(String(UnicodeScalar(UInt8(value))))
            }
        }
        
        return identifier
    }
    
    /// Device Version Checks
    public enum Versions: Float {
        case five = 5.0
        case six = 6.0
        case seven = 7.0
        case eight = 8.0
        case nine = 9.0
    }
    
    public class func isVersion(_ version: Versions) -> Bool {
        return systemFloatVersion() >= version.rawValue && systemFloatVersion() < (version.rawValue + 1.0)
    }
    
    public class func isVersionOrLater(_ version: Versions) -> Bool {
        return systemFloatVersion() >= version.rawValue
    }
    
    public class func isVersionOrEarlier(_ version: Versions) -> Bool {
        return systemFloatVersion() < (version.rawValue + 1.0)
    }
    
    public class var CURRENT_VERSION: String {
        return "\(systemFloatVersion())"
    }
    
    /// iOS 5 Checks
    public class func IS_OS_5() -> Bool {
        return isVersion(.five)
    }
    
    public class func IS_OS_5_OR_LATER() -> Bool {
        return isVersionOrLater(.five)
    }
    
    public class func IS_OS_5_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.five)
    }
    
    /// iOS 6 Checks
    public class func IS_OS_6() -> Bool {
        return isVersion(.six)
    }
    
    public class func IS_OS_6_OR_LATER() -> Bool {
        return isVersionOrLater(.six)
    }
    
    public class func IS_OS_6_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.six)
    }
    
    /// iOS 7 Checks
    public class func IS_OS_7() -> Bool {
        return isVersion(.seven)
    }
    
    public class func IS_OS_7_OR_LATER() -> Bool {
        return isVersionOrLater(.seven)
    }
    
    public class func IS_OS_7_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.seven)
    }
    
    /// iOS 8 Checks
    public class func IS_OS_8() -> Bool {
        return isVersion(.eight)
    }
    
    public class func IS_OS_8_OR_LATER() -> Bool {
        return isVersionOrLater(.eight)
    }
    
    public class func IS_OS_8_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.eight)
    }
    
    /// iOS 9 Checks
    public class func IS_OS_9() -> Bool {
        return isVersion(.nine)
    }
    
    public class func IS_OS_9_OR_LATER() -> Bool {
        return isVersionOrLater(.nine)
    }
    
    public class func IS_OS_9_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.nine)
    }
    
}



//MARK:- NSBundle Extension
extension Bundle {
    
    public var appVersion: String? {
        return self.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    public var appBuild: String? {
        return self.infoDictionary?["CFBundleVersion"] as? String
    }
    
}

//MARK:- String
extension String {
    var unescaped: String {
        let entities = ["\0", "\t", "\n", "\r", "\"", "\'", "\\"]
        var current = self
        for entity in entities {
            let descriptionCharacters = entity.debugDescription.dropFirst().dropLast()
            let description = String(descriptionCharacters)
            current = current.replacingOccurrences(of: description, with: entity)
        }
        return current
    }
    
    func isValidFaxNumber() -> Bool {
        
        var number = self
        
        number = number.replace("+", withString: "").replace(" ", withString: "").replace("-", withString: "").replace("(", withString: "").replace(")", withString: "")
        
        if number.count != 10 {
            return false
        } else {
            for char in number {
                if Int("\(char)") == nil {
                    return false
                }
            }
        }
        
        return true
    }
    
    func replace(_ target: String, withString: String) -> String {
        
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    static func getCurrentTimeZone() -> String {
        
        let timeZoneOffset = ((NSTimeZone.system.secondsFromGMT()) / 3600) * -60
        
        return "&tz=\(timeZoneOffset)"
    }
    
    
    func convertStringToDictionary() -> [String:AnyObject]? {
        
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    func getInitial() -> String {
        var initial = ""
        if self.count > 0 {
            let array = self.components(separatedBy: " ")
            
            if array.count > 0 {
                
                for item in array {
                    
                    if item.count > 0 {
                        initial.append(item.first)
                    }
                }
                
            } else {
                return first
            }
        }
        
        return initial
    }
}


//MARK:- AppDelegate
extension AppDelegate {
    
    func appleApplicationUITheme() {
        
        let titleTextAttribute = [NSAttributedString.Key.font:R.Fonts.AppPrimaryFont, NSAttributedString.Key.foregroundColor:UIColor.white]
        
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().titleTextAttributes = titleTextAttribute
        
        UIToolbar.appearance().tintColor = UIColor.white
        UIToolbar.appearance().barTintColor = .black
        
        //UISwitch.appearance().onTintColor = .black
        
        UIBarButtonItem.appearance().setTitleTextAttributes(titleTextAttribute, for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.gray], for: .disabled)
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(titleTextAttribute, for: .normal)
        //UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = R.Fonts.NormalTextFont
        
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor.black
        
        //UISegmentedControl.appearance().tintColor = R.Colors.AppSecondaryColor
        
        HUD.setDefaultMaskType(.clear)
        HUD.setForegroundColor(UIColor.lightGray)
        HUD.setBackgroundColor(UIColor.clear)
        HUD.setRingThickness(4)
        HUD.setRingRadius(24)
        HUD.setRingNoTextRadius(28)
    }
    
    func isUpdateAvailable(completion: @escaping (Bool?, Error?) -> Void) throws -> URLSessionDataTask {
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                throw VersionError.invalidBundleInfo
        }
        print("Current version: ", currentVersion)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw VersionError.invalidResponse }
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
                guard let result = (json?["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String else {
                    throw VersionError.invalidResponse
                }
                completion(currentVersion < version, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
        return task
    }
}

enum VersionError: Error {
    case invalidResponse, invalidBundleInfo
}

//MARK:- Date Extension
extension Date {
    
    func getDifference(toDate date: Date, forComponent components: Set<Calendar.Component>) -> DateComponents {
        
        let components = Calendar.current.dateComponents(components, from: self, to: date)
        return components
    }
    
    func getTimeStamp() -> String {
        
        let timeStamp: String = "Img-\(DateHelper.stringFromDate(self, dateFormat: "yyyyDDMM-HHmmss")!)"
        return timeStamp
    }
}

extension UIColor {
    
    var rgbComponents:(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        if getRed(&r, green: &g, blue: &b, alpha: &a) {
            return (r,g,b,a)
        }
        return (0,0,0,0)
    }
    // hue, saturation, brightness and alpha components from UIColor**
    var hsbComponents:(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var hue:CGFloat = 0
        var saturation:CGFloat = 0
        var brightness:CGFloat = 0
        var alpha:CGFloat = 0
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha){
            return (hue,saturation,brightness,alpha)
        }
        return (0,0,0,0)
    }
    var htmlRGBColor:String {
        return String(format: "#%02x%02x%02x", Int(rgbComponents.red * 255), Int(rgbComponents.green * 255),Int(rgbComponents.blue * 255))
    }
    var htmlRGBaColor:String {
        return String(format: "#%02x%02x%02x%02x", Int(rgbComponents.red * 255), Int(rgbComponents.green * 255),Int(rgbComponents.blue * 255),Int(rgbComponents.alpha * 255) )
    }
}

extension UIPopoverPresentationController {
    var dimmingView: UIView? {
        return value(forKey: "_dimmingView") as? UIView
    }
}


// MARK: - UIStackView
extension UIStackView {
    
    func removeAllArrangedViews() {
        
        for view in self.arrangedSubviews {
            view.removeFromSuperview()
        }
    }
}


// MARK: - UISegmentedControl
extension UISegmentedControl {
    
    var selectedIndexTitle: String {
        return self.titleForSegment(at: self.selectedSegmentIndex) ?? ""
    }
    
    var isLastIndexSelected: Bool {
        return self.selectedSegmentIndex == self.numberOfSegments-1
    }
    
    var isFirstIndexSelected: Bool {
        return self.selectedSegmentIndex == 0
    }
    
    var isAnyIndexSelected: Bool {
        return self.selectedSegmentIndex >= 0
    }
}

extension Dictionary {
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
    func dict2json() -> String {
        return json
    }
}
