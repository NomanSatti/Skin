//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: NewAddressViewModel.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit
import Alamofire

class NewAddressViewModel: NSObject {
    
    var dataModel: NewAddressModel!
    fileprivate var form = Form()
    var saveAddress = false
    var addressId = ""
    var addressType = ""
    var address = [String: Any]()
    var addressDictionary = [String: Any]()
    var isDefaultSave = false
    var moveDelegate: MoveController?
    var automaticSaveAddress = false
    
    func callingHttppApi(completion: @escaping (Bool) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        
        var requstParams = [String: Any]()
        var apiName: WhichApiCall = .getAddress
        var verbs: HTTPMethod = .get
        requstParams["addressId"] = addressId
        requstParams["storeId"] = Defaults.storeId
        requstParams["customerToken"] = Defaults.customerToken
        requstParams["quoteId"] = Defaults.quoteId
        if saveAddress {
            verbs = .post
            apiName = .saveAddress
            requstParams["addressData"] = addressDictionary.convertDictionaryToString()
            
        } else {
            verbs = .get
            apiName = .getAddress
            requstParams["eTag"] = DBManager.sharedInstance.geteTagFromDataBase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "addressData"))
        }
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: verbs, apiname: apiName, currentView: UIViewController()) { [weak self] success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            guard let self = self else { return }
            if success == 1 {                
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                if jsonResponse["success"].boolValue == true {
                    if self.saveAddress {
                        ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: jsonResponse["message"].stringValue)
                        completion(true)
                    } else {
                        if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]) {
                            DBManager.sharedInstance.storeDataToDataBase(data: data, eTag: jsonResponse["eTag"].stringValue, hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "addressData"))
                        }
                        self.doFurtherProcessingWithResult(data: jsonResponse) { success in
                            completion(success)
                        }
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
                self.callingHttppApi {success in
                    completion(success)
                    
                }
            } else if success == 3 {   // No Changes
                let jsonResponse =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "addressData"))
                self.doFurtherProcessingWithResult(data: jsonResponse) { success in
                    completion(success)
                }
                
            }
        }
    }
    
    func doFurtherProcessingWithResult(data: JSON, completion: (Bool) -> Void) {
        print(data)
        
        dataModel = NewAddressModel(json: data)
        var addressData = dataModel.addressData
        if addressType == "Checkout" {
            if addressDictionary.count > 0 {
                let json = JSON(addressDictionary)
                addressData = StoredAddressData(json: json)
            } else {
                if let address = NetworkManager.addressData {
                    addressData = address
                }
            }
            
        } else {
            if addressId.count == 0,  let address = NetworkManager.addressData {
                addressData = address
            }
        }
        //contact info cell
        self.createHeading(heading: "Contact Information".localized)
        if dataModel.isPrefixVisible == true {
            if dataModel.prefixOptions.count > 0 && dataModel.prefixOptions.first != "" {
                self.createDropDown(placeholder: "Prefix".localized, key: "prefix", key2: "", prifixData: dataModel.prefixOptions, isRequired: dataModel.isPrefixRequired, heading: "Prefix".localized, image: UIImage(named: "sharp-arrow-top")!, placeholder2: "".localized, value: addressData?.prefix)
                self.addressDictionary["prefix"] = addressData?.prefix
            } else {
                self.createTextField(placeholder: "Prefix".localized, isRequired: dataModel.isPrefixRequired ?? false, key: "prefix", value: addressData?.prefix)
                self.addressDictionary["prefix"] = addressData?.prefix
            }
        }
        
        var firstname = ""
        var lastname = ""
        if let names = Defaults.customerName?.components(separatedBy: " "), names.count > 1 {
            firstname = addressData?.firstname ?? names[0]
            lastname = addressData?.lastname ?? names[names.count - 1]
        } else {
            firstname = addressData?.firstname ?? Defaults.customerName ?? ""
            lastname = addressData?.lastname ?? ""
        }
        
        self.createTextField(placeholder: "First Name".localized + " *", isRequired: true, key: NewAddressModel.SerializationKeys.firstName, value: firstname)
        self.addressDictionary[NewAddressModel.SerializationKeys.firstName] = firstname
        self.createTextField(placeholder: "Last Name".localized, isRequired: true, key: NewAddressModel.SerializationKeys.lastName, value: lastname)
        self.addressDictionary[NewAddressModel.SerializationKeys.lastName] = lastname
        if dataModel.isSuffixVisible == true {
            if dataModel.suffixOptions.count > 0 {
                self.createDropDown(placeholder: "suffix".localized, key: "suffix", key2: "suffix", prifixData: dataModel.suffixOptions, isRequired: dataModel.isSuffixVisible, heading: "suffix".localized, image: UIImage(named: "sharp-arrow-top")!, placeholder2: "".localized, value: addressData?.suffix)
                self.addressDictionary["suffix"] = addressData?.suffix
            } else {
                self.createTextField(placeholder: "suffix".localized, isRequired: dataModel.isSuffixVisible, key: "suffix", value: addressData?.suffix)
                self.addressDictionary["suffix"] = addressData?.suffix
            }
        }
        if dataModel.isCompanyVisible {
            self.createTextField(placeholder: "Company".localized, isRequired: true, key: "company", value: addressData?.company)
            self.addressDictionary["company"] = addressData?.company
        }
        if dataModel.isTelephoneVisible {
            self.createTextField(placeholder: "Phone Number".localized, isRequired: true, key: "telephone", value: addressData?.telephone)
            self.addressDictionary["telephone"] = addressData?.telephone
        }
        if dataModel.isFaxVisible {
            self.createTextField(placeholder: "fax".localized, isRequired: true, key: "fax", value: addressData?.fax)
            self.addressDictionary["fax"] = addressData?.fax
        }
        
        //Address
        self.createHeading(heading: "Address".localized)
        var strret: Any?
        var streetArray = [String]()
        if let streetArray1 = addressData?.street {
            strret = streetArray1.joined(separator: ",")
            streetArray = streetArray1
        }
        if let count = dataModel.streetLineCount {
            for i in 0..<count {
                if i == 0 && streetArray.count > i {
                    self.createTextField(placeholder: "Street Address".localized + " *", isRequired: true, key: "street", value: streetArray[i])
                    self.addressDictionary["street"] = streetArray[i]
                } else {
                    if streetArray.count > i {
                        self.createTextField(placeholder: "Street Address".localized, isRequired: false, key: "street", value: streetArray[i])
                        self.addressDictionary["street"] = streetArray[i]
                    } else if i == 0 {
                        self.createTextField(placeholder: "Street Address".localized + " *", isRequired: true, key: "street", value: "")
                    } else {
                        self.createTextField(placeholder: "Street Address".localized, isRequired: false, key: "street", value: "")
                    }
                }
            }
        } else {
            self.createTextField(placeholder: "Street Address".localized + " *", isRequired: true, key: "street", value: strret)
            self.addressDictionary["street"] = strret
        }
        if addressType == "Checkout" && Defaults.customerToken == nil {
            self.createTextField(placeholder: "Email Address".localized, isRequired: true, key: "email", value: addressData?.email)
            self.addressDictionary["email"] = addressData?.email
        }
        self.createTextField(placeholder: "City".localized + " *", isRequired: true, key: "city", value: addressData?.city)
        self.addressDictionary["city"] = addressData?.city
        self.createTextField(placeholder: "Zip/Postal Code".localized + " *", isRequired: true, key: "postcode", value: addressData?.postcode)
        self.addressDictionary["postcode"] = addressData?.postcode
        var countryData: Any? = nil
        countryData = addressData?.countryId == nil ? dataModel?.defaultCountry : addressData?.countryId
        self.createCountryDropDown(placeholder: "Country".localized, key: "country_id", key2: "region_id", countryData: dataModel.countryData, isRequired: true, heading: "Country".localized, image: UIImage(named: "sharp-arrow-top")!, placeholder2: "State".localized, value: countryData, value2: addressData?.regionId)
        self.addressDictionary["country_id"] = countryData
        self.addressDictionary["region_id"] = addressData?.regionId ?? dataModel.getFirstRegionId(countryId: countryData as? String ?? "")
        if addressType != "Checkout" {
            if !self.isDefaultSave {
                if addressData?.isDefaultBilling ?? "" == "1" {
                    self.createHeading(heading: "It's a default billing address.".localized)
                } else {
                    self.createAddressCheck(placeholder: "Use as Default Billing Address".localized, heading: "Use as Default Billing Address".localized, isRequired: false, key: "default_billing", value: addressData?.isDefaultShipping)
                    self.addressDictionary["default_billing"] = addressData?.isDefaultBilling
                }
                if addressData?.isDefaultShipping ?? "" == "1" {
                    self.createHeading(heading: "It's a default shipping address.".localized)
                } else {
                    self.createAddressCheck(placeholder: "Use as Default Shipping Address".localized, heading: "Use as Default Shipping Address".localized, isRequired: false, key: "default_shipping", value: addressData?.isDefaultShipping)
                    self.addressDictionary["default_shipping"] = addressData?.isDefaultShipping
                }
            } else {
                self.addressDictionary["default_billing"] = "1"
                self.addressDictionary["default_shipping"] = "1"
            }
        }
        if addressType == "Checkout" && Defaults.customerToken != nil && !automaticSaveAddress {
            self.createAddressCheck(placeholder: "Save in address book".localized, heading: "Save in address book".localized, key: "saveInAddressBook")
        }
        print(addressDictionary)
        completion(true)
    }
    
    func saveAddressClicked(completion: @escaping (Bool) -> Void) {
        print(form.getFormData())
        if !form.isValid().0 {
            ShowNotificationMessages.sharedInstance.warningView(message: form.isValid().1 + " " + "input value is not valid".localized)
        } else {
            //addressDictionary = form.getFormData()
            print(addressDictionary)
            addressDictionary = addressDictionary.merging(form.getFormData()) { (_, new) in new }
            print(addressDictionary)
            if addressDictionary["prefix"] == nil {
                addressDictionary["prefix"] = ""
            }
            if addressDictionary["suffix"] == nil {
                addressDictionary["suffix"] = ""
            }
            addressDictionary["region"] = ""
            if addressDictionary["region_id"] == nil {
                addressDictionary["region_id"] = "0"
            }
            if addressDictionary["fax"] == nil {
                addressDictionary["fax"] = ""
            }
            if addressDictionary["telephone"] == nil {
                addressDictionary["telephone"] = ""
            }
            if addressDictionary["company"] == nil {
                addressDictionary["company"] = ""
            }
            
            if self.isDefaultSave {
                addressDictionary["default_shipping"] = "1"
                addressDictionary["default_billing"] = "1"
            } else {
                
                if addressDictionary["default_shipping"] == nil {
                    addressDictionary["default_shipping"] = ""
                }
                if addressDictionary["default_billing"] == nil {
                    addressDictionary["default_billing"] = ""
                }
            }
            addressDictionary["middlename"] = ""
            if let street = addressDictionary["street"] as? String {
                addressDictionary["street"] = [street]
            } else {
                addressDictionary["street"] = addressDictionary["street"] ?? [""]
            }
            if self.automaticSaveAddress {
                addressDictionary["saveInAddressBook"] = "1"
            }
            print(addressDictionary)
            if addressType == "Checkout" {
                completion(true)
            } else {
                
                saveAddress = true
                self.callingHttppApi { success in
                    completion(success)
                }
            }
            
            //            billingAddress = form.getFormData()
        }
    }
    
}

extension NewAddressViewModel {
    
    func createHeading(heading: String) {
        let fieldItem = FormItem(placeholder: "")
        fieldItem.uiProperties.cellType = FormItemCellType.label
        fieldItem.heading = heading
        self.form.formItems.append(fieldItem)
    }
    
    func createTextField(placeholder: String, isRequired: Bool = false, pwdType: Bool = false, key: String = "", valiidationType: String = "", value: Any?) {
        let fieldItem = FormItem(placeholder: placeholder)
        fieldItem.uiProperties.cellType = FormItemCellType.textField
        fieldItem.isRequired = isRequired
        fieldItem.isSecure = pwdType
        fieldItem.keyType = key
        fieldItem.valiidationType = valiidationType
        fieldItem.value = value
        
        if key == "email" {
            fieldItem.emailType = true
        }
        if key == "telephone" || key == "fax" {
            fieldItem.uiProperties.keyboardType = .phonePad
        }
        
        fieldItem.valueCompletion = { [weak fieldItem] value in
            fieldItem?.value = value
        }
        fieldItem.valueCompleted = { value in
            if let value = value, value.isEmail {
                self.callingHttppApi(email: value)
            }
        }
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
    
    func createCountryDropDown(placeholder: String, key: String = "", key2: String = "", countryData: [CountryData], isRequired: Bool = false, heading: String = "", image: UIImage, placeholder2: String, value: Any?,  value2: Any?) {
        let fieldItem = FormItem(placeholder: placeholder)
        fieldItem.uiProperties.cellType = FormItemCellType.dropDown
        fieldItem.countryData = countryData
        fieldItem.keyType = key
        fieldItem.keyType2 = key2
        fieldItem.rightIcon = image
        fieldItem.heading = heading
        fieldItem.value = value
        fieldItem.value2 = value2
        fieldItem.placeholder2 = placeholder2
        self.form.formItems.append(fieldItem)
        
    }
    
    func createAddressCheck(placeholder: String, heading: String, isRequired: Bool = false, key: String, valiidationType: String = "",value: Any?) {
        let fieldItem = FormItem(placeholder: placeholder)
        fieldItem.uiProperties.cellType = FormItemCellType.addressCheck
        fieldItem.isRequired = isRequired
        fieldItem.keyType = key
        fieldItem.valiidationType = valiidationType
        fieldItem.value = value
        fieldItem.valueCompletion = { [weak fieldItem] value in
            fieldItem?.value = value
        }
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
    
    func callingHttppApi(email: String) {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        let apiName: WhichApiCall = .checkCustomerByEmail
        let verbs: HTTPMethod = .get
        requstParams["email"] = email
        requstParams["storeId"] = Defaults.storeId
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: verbs, apiname: apiName, currentView: UIViewController()) { [weak self] success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            guard let self = self else { return }
            if success == 1 {
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                if jsonResponse["success"].boolValue && jsonResponse["isCustomerExist"].boolValue  {
                    self.moveDelegate?.moveController(id: "", name: email, dict: [:], jsonData: JSON.null, type: "", controller: AllControllers.signInController)
                }
            }
        }
    }
    
}

extension NewAddressViewModel: UITableViewDataSource, UITableViewDelegate {
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
            if self.form.formItems[indexPath.row].heading == "It's a default billing address.".localized || self.form.formItems[indexPath.row].heading == "It's a default shipping address.".localized {
                cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
                cell.textLabel?.text = self.form.formItems[indexPath.row].heading
                cell.textLabel?.textColor = UIColor.orange
            } else {
                cell = cellType.dequeueCell(for: tableView, at: indexPath)
            }
        } else {
            cell = UITableViewCell() //or anything you want
        }
        self.form.formItems[indexPath.row].indexPath = indexPath
        //        cell.backgroundColor = UIColor.yellow
        if let formUpdatableCell = cell as? FormUpdatable {
            item.indexPath = indexPath
            formUpdatableCell.update(with: item)
        }
        cell.contentView.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
