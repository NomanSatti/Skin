//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: AccountInformationViewModal.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit
import Alamofire

class AccountInformationViewModal: NSObject {
    
    var model: AccountInformationModel!
    fileprivate var form = Form()
    var genderArray = ["Male".localized, "Female".localized, "Not Specified".localized]
    var apiType = ""
    var requstParams = [String: Any]()
    var changeEmailFlag = false
    var changePasswordFlag = false
    var tableView : UITableView!
    
    func callingHttppApi(completion: @escaping (Bool) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        var verbs: HTTPMethod = .get
        var apiName: WhichApiCall = .accountinfoData
        requstParams["storeId"] = Defaults.storeId
        requstParams["width"] = UrlParams.width
        requstParams["quoteId"] = Defaults.quoteId
        requstParams["customerToken"] = Defaults.customerToken
        if apiType == "save" {
            if changePasswordFlag == true{
                requstParams["doChangePassword"] = "1"
            }else{
                requstParams["doChangePassword"] = "0"
            }
            if changeEmailFlag == true{
                requstParams["doChangeEmail"] = "1"
            }else{
                requstParams["email"] = model.email ?? ""
                requstParams["doChangeEmail"] = "0"
            }
            verbs = .post
            apiName = .saveAccountInfo
        }
        
        requstParams["eTag"] = DBManager.sharedInstance.geteTagFromDataBase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "AccountInformationData"))
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: verbs, apiname: apiName, currentView: UIViewController()) { [weak self] success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            if success == 1 {                
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                if jsonResponse["success"].boolValue == true {
                    if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]) {
                        DBManager.sharedInstance.storeDataToDataBase(data: data, eTag: jsonResponse["eTag"].stringValue, hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "AccountInformationData"))
                    }
                    
                    self?.doFurtherProcessingWithResult(data: jsonResponse) { success in
                        completion(success)
                    }
                } else {
                    if jsonResponse["message"].stringValue.removeWhiteSpace.count > 0 {
                        ShowNotificationMessages.sharedInstance.warningView(message: jsonResponse["message"].stringValue)
                    } else {
                        ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
                    }
                }
            } else if success == 2 {   // Retry in case of error
                NetworkManager.sharedInstance.dismissLoader()
                self?.callingHttppApi {success in
                    completion(success)
                    
                }
            } else if success == 3 {   // No Changes
                let jsonResponse =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "AccountInformationData"))
                self?.doFurtherProcessingWithResult(data: jsonResponse) { success in
                    completion(success)
                }
                
            }
        }
    }
    
    func doFurtherProcessingWithResult(data: JSON, completion: (Bool) -> Void) {
        
        if apiType != "save" {
            model = AccountInformationModel(json: data)
            if model.isPrefixVisible {
                if model.prefixOptions.count  > 0 {
                    self.createDropDown(placeholder: "Prefix".localized, key: "prefix", key2: "", prifixData: model.prefixOptions, isRequired: false, heading: "Prefix".localized, image: UIImage(named: "sharp-arrow-top")!, placeholder2: "".localized, value: model.prefixValue)
                } else {
                    self.createTextField(placeholder: "Prefix".localized, isRequired: false, key: "prefix", value: model.prefixValue)
                }
                
            }
            
            self.createTextField(placeholder: "First Name".localized, isRequired: true, key: AccountInformationModel.SerializationKeys.firstName, value: model.firstName)
            if model.isMiddlenameVisible {
                self.createTextField(placeholder: "Middle Name/Initial".localized, isRequired: false, key: AccountInformationModel.SerializationKeys.middleName, value: model.middleName)
            }
            if model.isDOBVisible {
                self.createDateDropDown(placeholder: "Date of birth".localized, key: "dob", isRequired: model.isDOBRequired, heading: "Date of birth".localized, value: model.dOBValue)
            }
            if model.isSuffixVisible {
                if model.prefixOptions.count  > 0 {
                    self.createDropDown(placeholder: "suffix".localized, key: "suffix", key2: "suffix", prifixData: model.suffixOptions, isRequired: false, heading: "suffix".localized, image: UIImage(named: "sharp-arrow-top")!, placeholder2: "".localized, value: model.suffixValue)
                } else {
                    self.createTextField(placeholder: "suffix".localized, isRequired: false, key: "suffix", value: model.suffixValue)
                }
            }
            
            if model.isTaxVisible {
                self.createTextField(placeholder: "Tax/Vat Number".localized, isRequired: false, key: "taxvat", value: model.taxValue)
            }
            self.createTextField(placeholder: "Last Name".localized, isRequired: true, key: AccountInformationModel.SerializationKeys.lastName, value: model.lastName )
            if model.isGenderVisible {
                var genderValue: Any? = nil
                if model.genderValue == "1" {
                    genderValue = genderArray[0].localized
                } else if model.genderValue == "2" {
                    genderValue = genderArray[1].localized
                } else if model.genderValue == "3" {
                    genderValue = genderArray[2].localized
                }
                self.createDropDown(placeholder: "gender".localized, key: "gender", key2: "gender", prifixData: genderArray, isRequired: false, heading: "gender".localized, image: UIImage(named: "sharp-arrow-top")!, placeholder2: "".localized, value: genderValue)
            }
            //self.createTextField(placeholder: "Email".localized, isRequired: true, key: AccountInformationModel.SerializationKeys.email, value: model.email,isEditable:false)
            
            self.createSwitchControl(placeholder: "Change Email".localized, isRequired: false, key: "", id: 1)
            self.createSwitchControl(placeholder: "Change Password".localized, isRequired: false, key: "", id: 2)
            
            completion(true)
        } else {
            if let email = requstParams["email"] as? String, changeEmailFlag {
                Defaults.customerEmail = email
            }
            
            if let customerName = data["customerName"].string {
                Defaults.customerName = customerName
            }
            ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message:  data["message"].stringValue)
            completion(true)
        }
        
    }
    
    func saveAddressClicked(completion: @escaping (Bool) -> Void) {
        print(form.getFormData())
        if !form.isValid().0 {
            ShowNotificationMessages.sharedInstance.warningView(message: form.isValid().1 + " " + "input value is not valid".localized)
        } else {
            apiType = "save"
            var dict = form.getFormData()
            if let password = dict["newPassword"] as? String{
                if password !=  dict["confirmPassword"] as? String{
                    ShowNotificationMessages.sharedInstance.warningView(message: "Password should be Same".localized)
                }else{
                    if let value = dict["gender"] as? String {
                        if value == genderArray[0].localized {
                            dict["gender"] = "1"
                        } else if value == genderArray[1].localized {
                            dict["gender"] = "2"
                        } else if value == genderArray[2].localized {
                            dict["gender"] = "3"
                        }
                    }
                    requstParams = dict
                    self.callingHttppApi { _ in
                        completion(true)
                    }
                }
                
            }else{
                if let value = dict["gender"] as? String {
                    if value == genderArray[0].localized {
                        dict["gender"] = "1"
                    } else if value == genderArray[1].localized {
                        dict["gender"] = "2"
                    } else if value == genderArray[2].localized {
                        dict["gender"] = "3"
                    }
                }
                
                requstParams = dict
                self.callingHttppApi { _ in
                    completion(true)
                }
            }
        }
    }
    
    func createTextField(placeholder: String, isRequired: Bool = false, pwdType: Bool = false, key: String = "", valiidationType: String = "", value: Any?,isEditable : Bool = true) {
        let fieldItem = FormItem(placeholder: placeholder)
        fieldItem.uiProperties.cellType = FormItemCellType.textField
        fieldItem.isRequired = isRequired
        fieldItem.isSecure = pwdType
        fieldItem.keyType = key
        fieldItem.valiidationType = valiidationType
        fieldItem.value = value
        fieldItem.isEditable = isEditable
        fieldItem.valueCompletion = { [weak fieldItem] value in
            fieldItem?.value = value
        }
        self.form.formItems.append(fieldItem)
    }
    
    func createDateDropDown(placeholder: String, key: String = "", isRequired: Bool = false, heading: String = "", value: Any?) {
        let fieldItem = FormItem(placeholder: placeholder)
        fieldItem.uiProperties.cellType = FormItemCellType.date
        fieldItem.keyType = key
        fieldItem.heading = heading
        fieldItem.value = value
        fieldItem.keyType2 = "yyyy-MM-dd"
        
        self.form.formItems.append(fieldItem)
        
    }
    
    func createDropDown(placeholder: String, key: String = "", key2: String = "", prifixData: [String], isRequired: Bool = false, heading: String = "", image: UIImage, placeholder2: String, value: Any?) {
        let fieldItem = FormItem(placeholder: placeholder)
        fieldItem.uiProperties.cellType = FormItemCellType.singleDropDown
        fieldItem.prifixData = prifixData
        fieldItem.keyType = key
        fieldItem.keyType2 = key2
        fieldItem.rightIcon = image
        fieldItem.value = value
        fieldItem.heading = heading
        fieldItem.placeholder2 = placeholder2
        self.form.formItems.append(fieldItem)
    }
    
    func createSwitchControl(placeholder: String, isRequired: Bool = false, key: String = "",id:Int) {
        let fieldItem = FormItem(placeholder: placeholder)
        fieldItem.uiProperties.cellType = FormItemCellType.changePassword
        fieldItem.isRequired = isRequired
        fieldItem.keyType = key
        fieldItem.id = id
        fieldItem.valueCompletion = { [weak fieldItem] value in
            fieldItem?.value = value
        }
        
        self.form.formItems.append(fieldItem)
    }
    
    func insertTextField(placeholder: String, isRequired: Bool = false, pwdType: Bool = false, key: String = "", valiidationType: String = "", value: Any?,isEditable : Bool = true, index: Int? = nil) {
        let fieldItem = FormItem(placeholder: placeholder)
        fieldItem.uiProperties.cellType = FormItemCellType.textField
        fieldItem.isRequired = isRequired
        fieldItem.isSecure = pwdType
        fieldItem.keyType = key
        fieldItem.valiidationType = valiidationType
        fieldItem.value = value
        fieldItem.isEditable = isEditable
        fieldItem.valueCompletion = { [weak fieldItem] value in
            fieldItem?.value = value
        }
        if let index = index {
            self.form.formItems.insert(fieldItem, at: index)
        } else {
            self.form.formItems.append(fieldItem)
        }
    }
    
}

extension AccountInformationViewModal: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.form.formItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        if let switchCell =  cell as? ChangeTableViewCell{
            switchCell.delegate = self
        }
        cell.contentView.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension AccountInformationViewModal:changeDelegate {
    func passdata(index: Int, actionData: Int) {
        if index == 1{
            if actionData == 1{
                self.insertTextField(placeholder: "Email".localized, isRequired: true, key: AccountInformationModel.SerializationKeys.email, value: model.email,isEditable:true, index: 3)
            }else{
                self.form.formItems.remove(at: 3)
            }
            if actionData == 1 && !changePasswordFlag{
                self.createTextField(placeholder: "Current Password".localized, isRequired: true, pwdType: true, key: AccountInformationModel.SerializationKeys.currentPassword, value: "")
            }else if actionData != 1 && !changePasswordFlag{
                self.form.formItems.removeLast()
            }
            changeEmailFlag = !changeEmailFlag
        }else{
            if actionData == 1 && !changeEmailFlag{
                self.createTextField(placeholder: "Current Password".localized, isRequired: true, pwdType: true, key: AccountInformationModel.SerializationKeys.currentPassword, value: "" )
                self.createTextField(placeholder: "New password".localized, isRequired: true, pwdType: true, key: AccountInformationModel.SerializationKeys.newPassword, value: "" )
                self.createTextField(placeholder: "Confirm New password".localized, isRequired: true, pwdType: true, key: AccountInformationModel.SerializationKeys.confirmPassword, value: "" )
            }else if actionData == 1 && changeEmailFlag{
                self.createTextField(placeholder: "New password".localized, isRequired: true,pwdType:true, key: AccountInformationModel.SerializationKeys.newPassword, value: "" )
                self.createTextField(placeholder: "Confirm New password".localized, isRequired: true,pwdType:true, key: AccountInformationModel.SerializationKeys.confirmPassword, value: "" )
            }else if actionData != 1 && !changeEmailFlag{
                self.form.formItems.removeLast()
                self.form.formItems.removeLast()
                self.form.formItems.removeLast()
            }else if actionData != 1 && changeEmailFlag{
                self.form.formItems.removeLast()
                self.form.formItems.removeLast()
            }
            changePasswordFlag = !changePasswordFlag
        }
        self.tableView.reloadData()
    }
}
