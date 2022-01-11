import Foundation
import UIKit

class AdvanceSearchViewModel: NSObject {
    
    weak var tableView: UITableView!
    fileprivate var form = Form()
    var requstParams = [String: Any]()
    func callingHttppApi() {
        let defaults = UserDefaults.standard
        
        NetworkManager.sharedInstance.showLoader()
        
        if defaults.object(forKey: "storeId") != nil {
            requstParams["storeId"] = defaults.object(forKey: "storeId") as? String ?? ""
        }
        
        requstParams["eTag"] = DBManager.sharedInstance.geteTagFromDataBase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "advanceSearch"))
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .get, apiname: .advancedSearchFormData, currentView: UIViewController()) { success, responseObject in
            NetworkManager.sharedInstance.dismissLoader()
            if success == 1 {                
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                if jsonResponse["success"].boolValue == true {
                    if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]) {
                        DBManager.sharedInstance.storeDataToDataBase(data: data, eTag: jsonResponse["eTag"].stringValue, hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "advanceSearch"))
                    }
                    
                    self.doFurtherProcessingWithResult(data: jsonResponse)
                } else {
                    if jsonResponse["message"].stringValue.removeWhiteSpace.count > 0 {
                        ShowNotificationMessages.sharedInstance.warningView(message: jsonResponse["message"].stringValue)
                    } else {
                        ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
                    }
                }
            } else if success == 2 {   // Retry in case of error
                NetworkManager.sharedInstance.dismissLoader()
                self.callingHttppApi()
            } else if success == 3 {   // No Changes
                let jsonResponse =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "advanceSearch"))
                self.doFurtherProcessingWithResult(data: jsonResponse)
                
            }
        }
    }
    
    func doFurtherProcessingWithResult(data: JSON) {
        let data = AdvanceSearchModel(json: data)
        //        print(data.fieldList)
        if let fieldList = data.fieldList {
            for i in 0..<fieldList.count {
                
                switch  fieldList[i].inputType {
                case "string":
                    self.createTextField(placeholder: fieldList[i].title, isRequired: false, key: fieldList[i].attributeCode, heading: fieldList[i].title, inputType: fieldList[i].inputType)
                case "yesno":
                    self.createBoolCheck(placeholder: fieldList[i].title, heading: fieldList[i].title, isRequired: false, key: fieldList[i].attributeCode, inputType: fieldList[i].inputType)
                case "date":
                    self.createDateDropDown(placeholder: fieldList[i].title, key: fieldList[i].attributeCode, isRequired: false, heading: fieldList[i].title, inputType: fieldList[i].inputType)
                case "select":
                    self.creatRadioOptions(placeholder: fieldList[i].title, key: fieldList[i].attributeCode, isRequired: false, heading: fieldList[i].title, countryData: fieldList[i].options, inputType: fieldList[i].inputType)
                case "price":
                    var title = fieldList[i].title
                    if let currency = Defaults.currency {
                        title?.append(" (" + currency + ")")
                    }
                    self.createTextFieldPrice(placeholder: "", isRequired: true, key: fieldList[i].attributeCode, heading:title ?? "", inputType: fieldList[i].inputType)
                default:
                    print()
                }
                
            }
            self.tableView?.reloadData()
        }
    }
    
    func createTextField(placeholder: String, isRequired: Bool = false, pwdType: Bool = false, key: String = "", heading: String, inputType: String) {
        let fieldItem = FormItem(placeholder: placeholder)
        fieldItem.uiProperties.cellType = FormItemCellType.textField
        fieldItem.isRequired = isRequired
        fieldItem.isSecure = pwdType
        fieldItem.keyType = key
        fieldItem.heading = heading
        fieldItem.inputType = inputType
        
        fieldItem.valueCompletion = { [weak fieldItem] value in
            fieldItem?.value = value
        }
        self.form.formItems.append(fieldItem)
    }
    
    func createBoolCheck(placeholder: String, heading: String, isRequired: Bool = false, key: String = "", inputType: String = "") {
        let fieldItem = FormItem(placeholder: placeholder)
        fieldItem.uiProperties.cellType = FormItemCellType.addressCheck
        fieldItem.isRequired = isRequired
        fieldItem.keyType = key
        fieldItem.inputType = inputType
        fieldItem.valueCompletion = { [weak fieldItem] value in
            fieldItem?.value = value
        }
        self.form.formItems.append(fieldItem)
    }
    
    func createDateDropDown(placeholder: String, key: String = "", isRequired: Bool = false, heading: String = "", inputType: String = "") {
        let fieldItem = FormItem(placeholder: placeholder)
        fieldItem.uiProperties.cellType = FormItemCellType.date
        fieldItem.keyType = key
        fieldItem.inputType = inputType
        fieldItem.heading = heading
        self.form.formItems.append(fieldItem)
        
    }
    
    func creatRadioOptions(placeholder: String, key: String = "", isRequired: Bool = false, heading: String = "", countryData: [Any], inputType: String = "") {
        let fieldItem = FormItem(placeholder: placeholder)
        fieldItem.uiProperties.cellType = FormItemCellType.radio
        fieldItem.keyType = key
        fieldItem.heading = heading
        fieldItem.inputType = inputType
        fieldItem.countryData = countryData
        self.form.formItems.append(fieldItem)
        
    }
    
    func createTextFieldPrice(placeholder: String, isRequired: Bool = false, pwdType: Bool = false, key: String = "", heading: String, inputType: String = "") {
        let fieldItem = FormItem(placeholder: placeholder)
        fieldItem.uiProperties.cellType = FormItemCellType.price
        fieldItem.isRequired = isRequired
        fieldItem.isSecure = pwdType
        fieldItem.keyType = key
        fieldItem.heading = heading
        fieldItem.inputType = inputType
        
        fieldItem.valueCompletion = { [weak fieldItem] value in
            fieldItem?.value = value
        }
        self.form.formItems.append(fieldItem)
    }
    
    func advanceSearchClicked(completion: @escaping (String) -> Void) {
        print(form.getSearchFormData())
        if form.getSearchFormData().count > 0 {
            completion(form.getSearchFormData().convertArrayToString() ?? "")
        } else {
            ShowNotificationMessages.sharedInstance.warningView(message: "Please select options".localized)
        }
        //        if !form.isValid().0 {
        //            ShowNotificationMessages.sharedInstance.warningView(message: form.isValid().1 + " " + "input value is not valid".localized)
        //        } else {
        
        //        }
    }
    
    
}

extension AdvanceSearchViewModel: UITableViewDataSource, UITableViewDelegate {
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
