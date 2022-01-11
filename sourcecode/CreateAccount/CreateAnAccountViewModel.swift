//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: CreateAnAccountViewModel.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit
import Alamofire

class CreateAnAccountViewModel: NSObject {
    
    var rwg =  [String: String]()
    
    @IBOutlet weak var tableView: UITableView!
    var dataModel: CreateAccountModel?
    var customerDetails: AccountInformationModel!
    fileprivate var form = Form()
    fileprivate var items = [SignupCasesViewItem]()
    let defaults = UserDefaults.standard
    var saveData = false
    var addressId = ""
    var signupDictionary = [String: Any]()
    var passwordTextFieldData = ""
    var confirmPasswordTextFieldData = ""
    weak var delegate: moveToControlller?
    var newsLaterCheck: Bool?
    @IBOutlet weak var footerView: SaveFooterView!
    var genderArray = ["Male".localized, "Female".localized, "Not Specified".localized]
    var registerSeller = false
    var shopURL = ""
    
    func callingHttppApi(completion: @escaping (Bool) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        var apiName: WhichApiCall = .getAddress
        var verbs: HTTPMethod = .get
        requstParams["storeId"] = Defaults.storeId
        requstParams["customerToken"] = Defaults.customerToken
        requstParams["quoteId"] = Defaults.quoteId
        requstParams["token"] = Defaults.customerToken
        if saveData {
            verbs = .post
            apiName = .createAccount
            for (key, value) in signupDictionary {
                requstParams[key] = value
            }
        } else {
            verbs = .get
            apiName = .createAccountFormData
            requstParams["eTag"] = DBManager.sharedInstance.geteTagFromDataBase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "CreateAnAccountViewController"))
        }
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: verbs, apiname: apiName, currentView: UIViewController()) { [weak self] success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            guard let self = self else { return }
            if success == 1 {
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                if jsonResponse["success"].boolValue == true {
                    if self.saveData {
                        if jsonResponse["success"].boolValue {
                            UserDefaults.standard.set(self.passwordTextFieldData, forKey: "loginUserPassword")
                            ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: jsonResponse["message"].stringValue)
                        } else {
                            ShowNotificationMessages.sharedInstance.warningView(message: jsonResponse["message"].stringValue)
                        }
                        self.doFurtherProcessingWithResult(data: jsonResponse) { success in
                            completion(success)
                        }
                    } else {
                        if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]) {
                            DBManager.sharedInstance.storeDataToDataBase(data: data, eTag: jsonResponse["eTag"].stringValue, hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "CreateAnAccountViewController"))
                        }
                        self.doFurtherProcessingWithResult(data: jsonResponse) { success in
                            completion(success)
                        }
                    }
                } else {
                    if jsonResponse["message"].stringValue.removeWhiteSpace.count == 0 {
                        ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: jsonResponse["message"].stringValue)
                    } else {
                        ShowNotificationMessages.sharedInstance.warningView(message: jsonResponse["message"].stringValue)
                    }
                }
            } else if success == 2 {   // Retry in case of error
                NetworkManager.sharedInstance.dismissLoader()
                self.callingHttppApi {success in
                    completion(success)
                    
                }
            } else if success == 3 {   // No Changes
                if !(self.saveData) {
                    let jsonResponse =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "CreateAnAccountViewController"))
                    print(jsonResponse)
                    self.doFurtherProcessingWithResult(data: jsonResponse) { success in
                        completion(success)
                    }
                }
            }
        }
    }
    
    func doFurtherProcessingWithResult(data: JSON, completion: (Bool) -> Void) {
        if !(saveData) {
            dataModel = CreateAccountModel(data: data)
            if dataModel?.signUpData?.isPrefixVisible ?? false {
                var prefixString = "Prefix".localized
                if dataModel?.signUpData?.isPrefixRequired ?? false {
                    prefixString += " *"
                }
                if dataModel?.signUpData?.prefixValue.count ?? 0 > 0 {
                    self.createSingleDropDown(placeholder: prefixString, key: "prefix", prifixData: dataModel?.signUpData?.prefixValue ?? [""], isRequired: dataModel?.signUpData?.isPrefixRequired ?? false, heading: "Prefix".localized, image: UIImage(named: "sharp-arrow-top")!)
                } else {
                    self.createTextField(placeholder: prefixString, isRequired: dataModel?.signUpData?.isPrefixRequired ?? false, key: "prefix")
                }
            }
            if customerDetails != nil {
                self.createTextField(placeholder: "First Name".localized + " *", isRequired: true, key: "firstName", value: customerDetails.firstName)
            } else {
                self.createTextField(placeholder: "First Name".localized + " *", isRequired: true, key: "firstName")
            }
            
            if dataModel?.signUpData?.isMiddleNameVisible == true {
                self.createTextField(placeholder: "Middile Name".localized, isRequired: false, key: "middleName")
            }
            if customerDetails != nil {
                self.createTextField(placeholder: "Last Name".localized, isRequired: true, key: "lastName", value: customerDetails.lastName)
            } else {
                self.createTextField(placeholder: "Last Name".localized, isRequired: true, key: "lastName")
            }
            
            if dataModel?.signUpData?.isSuffixVisible ?? false {
                var suffixString = "suffix".localized
                if dataModel?.signUpData?.isSuffixRequired ?? false {
                    suffixString += " *"
                }
                if dataModel?.signUpData?.suffixValue.count ?? 0 > 0 {
                    self.createSingleDropDown(placeholder: suffixString, key: "suffix", prifixData: dataModel?.signUpData?.suffixValue ?? [""], isRequired: dataModel?.signUpData?.isSuffixRequired ?? false, heading: "suffix".localized, image: UIImage(named: "sharp-arrow-top")!)
                } else {
                    self.createTextField(placeholder: suffixString, isRequired: dataModel?.signUpData?.isSuffixVisible ?? false, key: "suffix")
                }
            }
            
            if dataModel?.signUpData?.isTaxVisible ?? false == true {
                let taxvatString = "taxvat".localized
                self.createTextField(placeholder: taxvatString, isRequired: false, key: "taxvat")
            }
            if dataModel?.signUpData?.isGenderVisible ?? false {
                var genderString = "gender".localized
                if dataModel?.signUpData?.isGenderRequired ?? false {
                    genderString += " *"
                }
                self.createSingleDropDown(placeholder: genderString, key: "gender", prifixData: genderArray, isRequired: dataModel?.signUpData?.isGenderRequired ?? false, heading: "gender".localized, image: UIImage(named: "sharp-arrow-top")!)
            }
            if dataModel?.signUpData?.isDobVisible ?? false == true {
                var dobString = "Date of birth".localized
                if dataModel?.signUpData?.isDobRequired ?? false {
                    dobString += " *"
                }
                self.createDateDropDown(placeholder: dobString, key: "dob", isRequired: false, heading: "Date of birth".localized, format: dataModel?.signUpData?.dateFormat ?? "yyyy-MM-dd")
            }
            
            if dataModel?.signUpData?.isMobileNumberVisible ?? false == true {
                if dataModel?.signUpData?.isMobileNumberRequired ?? false == true {
                    self.createTextField(placeholder: "Mobile Number".localized + " *", isRequired: false, key: "mobile")
                } else {
                    self.createTextField(placeholder: "Mobile Number".localized, isRequired: false, key: "mobile")
                }
            }
            //self.createTextField(placeholder: "Mobile Number".localized, isRequired: false, key: "mobile")
            let emailString = "Email".localized + " *"
            if customerDetails != nil {
                self.createTextField(placeholder: emailString, isRequired: true, key: "email", value: customerDetails.email)
            } else {
                self.createTextField(placeholder: emailString, isRequired: true, key: "email")
            }
            
            items.append(TextFiledItem(textArrayCount: self.form.formItems.count))
           
            items.append(PasswordFiledItem())
            //items.append(NewsFiledItem())
            footerView?.createAccountBtn.addTarget(self, action: #selector(saveDataClicked), for: .touchUpInside)
            footerView?.alreadyHaveAccountBtn.addTarget(self, action: #selector(signInClicked), for: .touchUpInside)
        } else {
            self.defaults.set(data["customerEmail"].stringValue, forKey: Defaults.Key.customerEmail.rawValue)
            self.defaults.set(data["customerToken"].stringValue, forKey: Defaults.Key.customerToken.rawValue)
            self.defaults.set(data["customerName"].stringValue, forKey: Defaults.Key.customerName.rawValue)
            
            if self.defaults.object(forKey: Defaults.quoteId) != nil {
                self.defaults.set(nil, forKey: Defaults.quoteId)
                self.defaults.synchronize()
            }
            //UserDefaults.standard.removeObject(forKey: "quoteId")
            if let profileImage = data["profileImage"].string {
                self.defaults.set(profileImage, forKey: (Defaults.Key.profilePicture.rawValue))
            }
            if let bannerImage  = data["bannerImage"].string {
                self.defaults.set(bannerImage, forKey: Defaults.Key.profileBanner.rawValue)
            }
            
            if data["isAdmin"].intValue == 0 {
                //self.defaults.set("false", forKey: Defaults.Key.isAdmin.rawValue)
                Defaults.isAdmin = false
            } else {
                //self.defaults.set("true", forKey: Defaults.Key.isAdmin.rawValue)
                Defaults.isAdmin = true
            }
            if data["isSeller"].intValue == 0 {
                self.defaults.set("false", forKey: Defaults.Key.isSeller.rawValue)
            } else {
                self.defaults.set("true", forKey: Defaults.Key.isSeller.rawValue)
            }
            if data["isPending"].intValue == 0 {
                self.defaults.set("false", forKey: Defaults.Key.isPending.rawValue)
                
            } else {
                self.defaults.set("true", forKey: Defaults.Key.isPending.rawValue)
            }
            self.defaults.synchronize()
            ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: data["message"].stringValue)
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHome"), object: nil)
        self.delegate?.moveController(id: "", name: "", dict: [:], jsonData: JSON.null, index: 0, controller: .none)
        completion(true)
    }
    
    @objc func saveDataClicked() {
        print(form.getFormData())
        if !form.isValid().0 {
            ShowNotificationMessages.sharedInstance.warningView(message: form.isValid().1 + " " + "input value is not valid".localized)
        } else if passwordTextFieldData.isEmpty {
            ShowNotificationMessages.sharedInstance.warningView(message: "Password" + " " + "input value is not valid".localized)
        } else if passwordTextFieldData != confirmPasswordTextFieldData {
            ShowNotificationMessages.sharedInstance.warningView(message: "Password & Confirm Password must be same!!".localized)
        } else {
            signupDictionary = form.getFormData()
            signupDictionary["becomeSeller"] = "0"
            if self.registerSeller {
                signupDictionary["shopUrl"] = self.shopURL
                signupDictionary["becomeSeller"] = "1"
            }
            signupDictionary["password"] = passwordTextFieldData
            signupDictionary["isSocial"] = "0"
            signupDictionary["pictureURL"] = ""
            if signupDictionary["gender"]as? String ?? "" == "Male".localized {
                signupDictionary["gender"] = "1"
            } else if signupDictionary["gender"]as? String ?? "" == "Male".localized {
                signupDictionary["gender"] = "2"
            } else {
                signupDictionary["gender"] = "0"
            }
//            if newsLaterCheck ?? false {
//                signupDictionary["becomeSeller"] = "0"
//            } else {
//                signupDictionary["becomeSeller"] = "1"
//            }
            signupDictionary["token"] = Defaults.deviceToken
            saveData = true
            self.callingHttppApi { _ in
                
            }
        }
    }
    
    @objc func signInClicked() {
        delegate?.moveController(id: "", name: "", dict: [:], jsonData: JSON.null, index: 0, controller: .signInController)
    }
}
extension CreateAnAccountViewModel {
    func createTextField(placeholder: String, isRequired: Bool = false, pwdType: Bool = false, key: String = "", valiidationType: String = "", value: Any? = nil) {
        let fieldItem = FormItem(placeholder: placeholder)
        fieldItem.uiProperties.cellType = FormItemCellType.textField
        fieldItem.isRequired = isRequired
        fieldItem.isSecure = pwdType
        fieldItem.keyType = key
        fieldItem.valiidationType = valiidationType
        fieldItem.value = value
        if key == "mobile" {
            fieldItem.uiProperties.keyboardType = .numberPad
        }
        
        fieldItem.valueCompletion = { [weak fieldItem] value in
            fieldItem?.value = value
        }
        self.form.formItems.append(fieldItem)
    }
    
    func createSingleDropDown(placeholder: String, key: String = "", prifixData: [String], isRequired: Bool = false, heading: String = "", image: UIImage) {
        let fieldItem = FormItem(placeholder: placeholder)
        fieldItem.uiProperties.cellType = FormItemCellType.singleDropDown
        fieldItem.prifixData = prifixData
        fieldItem.keyType = key
        fieldItem.rightIcon = image
        fieldItem.heading = heading
        self.form.formItems.append(fieldItem)
    }
    
    func createDateDropDown(placeholder: String, key: String = "", isRequired: Bool = false, heading: String = "", format: String) {
        let fieldItem = FormItem(placeholder: placeholder)
        fieldItem.uiProperties.cellType = FormItemCellType.date
        fieldItem.keyType2 = format
        fieldItem.keyType = key
        fieldItem.heading = heading
        self.form.formItems.append(fieldItem)
        
    }
    
    func createAddressCheck(placeholder: String, heading: String, isRequired: Bool = false, key: String = "", valiidationType: String = "") {
        let fieldItem = FormItem(placeholder: placeholder)
        fieldItem.uiProperties.cellType = FormItemCellType.addressCheck
        fieldItem.isRequired = isRequired
        fieldItem.keyType = key
        fieldItem.valiidationType = valiidationType
        fieldItem.valueCompletion = { [weak fieldItem] value in
            fieldItem?.value = value
        }
        self.form.formItems.append(fieldItem)
    }
}

extension CreateAnAccountViewModel: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let itemData = items[indexPath.section]
        switch  itemData.type {
        case .textFieldSection:
            let item = self.form.formItems[indexPath.row]
            let cell: UITableViewCell
            if let cellType = self.form.formItems[indexPath.row].uiProperties.cellType {
                cell = cellType.dequeueCell(for: tableView, at: indexPath)
            } else {
                cell = UITableViewCell() //or anything you want
            }
            self.form.formItems[indexPath.row].indexPath = indexPath
            if let formUpdatableCell = cell as? FormUpdatable {
                item.indexPath = indexPath
                formUpdatableCell.update(with: item)
            }
            cell.contentView.clipsToBounds = true
            return cell
        case .password:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordTableViewCell", for: indexPath)as? PasswordTableViewCell {
                cell.delegate = self
                return cell
            }
        case .newsLetter:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NewsLaterCheckTableViewCell", for: indexPath)as? NewsLaterCheckTableViewCell {
                cell.delegate = self
                return cell
            }
       
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //         let itemData = items[indexPath.section]
        return UITableView.automaticDimension
    }
}

enum SignupCases {
    case textFieldSection
    case password
    case newsLetter
    
}

protocol SignupCasesViewItem {
    var type: SignupCases { get }
    var rowCount: Int { get }
}

class TextFiledItem: SignupCasesViewItem {
    
    var type: SignupCases {
        return .textFieldSection
    }
    
    var rowCount: Int {
        return textArrayCount ?? 0
    }
    
    var heading: String {
        return String.init(format: "%@ #", "order".localized)
    }
    var textArrayCount: Int?
    
    init(textArrayCount: Int) {
        self.textArrayCount = textArrayCount
    }
}



class PasswordFiledItem: SignupCasesViewItem {
    
    var type: SignupCases {
        return .password
    }
    
    var rowCount: Int {
        return 1
    }
}

class NewsFiledItem: SignupCasesViewItem {
    
    var type: SignupCases {
        return .newsLetter
    }
    
    var rowCount: Int {
        return 1
    }
}
extension CreateAnAccountViewModel: PasswordCharacter, NesLaterClick {
    func newLetterCheck(check: Bool) {
        newsLaterCheck = check
    }
    
    func passwordUpdate(data: String, confirmPassword: String) {
        passwordTextFieldData = data
        confirmPasswordTextFieldData = confirmPassword        
        //tableView.reloadSections([2], with: .none)
    }
}
