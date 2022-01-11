//
//  ViewModal.swift
//  IMOTEX
//
//  Created by bhavuk.chawla on 31/10/18.
//  Copyright © 2018 bhavuk.chawla. All rights reserved.
//

import Foundation
import UIKit
import Reusable

/// UIKit properties for ViewModels
struct FormItemUIProperties {
    var tintColor = UIColor.black
    var keyboardType = UIKeyboardType.default
    var cellType: FormItemCellType?
}

protocol FormValidable {
    var isValid: Bool {get set}
    var isRequired: Bool {get set}
    var isSecure: Bool {get set}
    func checkValidity()
    var keyType: String {get set}
    var emailType: Bool {get set}
    var valiidationType: String {get set}
    
}

class Form {
    var formItems = [FormItem]()
    
    // MARK: Form Validation
    @discardableResult
    func isValid() -> (Bool, String) {
        
        var isValid = true
        var errorString = ""
        for item in self.formItems {
            
            item.checkValidity()
            if !item.isValid {
                isValid = false
                errorString = item.placeholder
                break
            }
            if item.isRequired, item.value == nil || item.value as? String == nil || (item.value as? String)?.count == 0 {
                isValid = false
                errorString = item.placeholder
                break
            }
        }
        return (isValid, errorString)
    }
    
    func getFormData() -> [String: Any] {
        var dict = [String: Any]()
        var arrTypedata = [String:[String]]()
        for item in self.formItems {
            if item.keyType.count > 0, let value = item.value {
                print(item.keyType, value)
                if let _ = dict[item.keyType], let value = value as? String {
                    if var arr = arrTypedata[item.keyType] {
                        arr.append(value)
                        arrTypedata[item.keyType] = arr
                        dict[item.keyType] = arr
                    }
                } else {
                    if let value = value as? String {
                        arrTypedata[item.keyType] = [value]
                    }
                    dict[item.keyType] = value
                }                
            }
            //            print( item.keyType2, item.value2)
            if item.keyType2.count > 0, let value = item.value2 {
                print(item.keyType2, value)
                dict[item.keyType2] = value
            }
        }
        return dict
    }
    
    func getFormDataWithEmptyString() -> [String: Any] {
        var dict = [String: Any]()
        var arrTypedata = [String:[String]]()
        for item in self.formItems {
            if item.keyType.count > 0 {
                let value = item.value ?? ""
                print(item.keyType, value)
                if let _ = dict[item.keyType], let value = value as? String {
                    if var arr = arrTypedata[item.keyType] {
                        arr.append(value)
                        arrTypedata[item.keyType] = arr
                        dict[item.keyType] = arr
                    }
                } else {
                    if let value = value as? String {
                        arrTypedata[item.keyType] = [value]
                    }
                    dict[item.keyType] = value
                }
            }
            if item.keyType2.count > 0, let value = item.value2 {
                print(item.keyType2, value)
                dict[item.keyType2] = value
            }
        }
        return dict
    }
    
    func getSearchFormData() -> [[String: Any]]{
        var dictArray = [[String: Any]]()
        var dict = [String: Any]()
        
        for item in self.formItems {
            if  let value2 = item.value2, let value1 = item.value {
                print(item.keyType2, value2)
                //                dict[item.keyType2] = value
                dict["code"] = item.keyType
                dict["value"] = ["from": value1, "to": value2]
                dict["inputType"] = item.inputType
                dictArray.append(dict)
            }else {
                if item.keyType.count > 0, let value = item.value  {
                    print(item.keyType, value)
                    //                dict[item.keyType] = value
                    if item.inputType == "select", let value = value as? String {
                        dict["value"] = [value: "true"]
                    } else if item.inputType == "date" {
                        dict["value"] = ["from": value, "to": value]
                    } else {
                        dict["value"] = value
                    }
                    
                    dict["code"] = item.keyType
                    
                    dict["inputType"] = item.inputType
                    dictArray.append(dict)
                }
            }
            
            //            print( item.keyType2, item.value2)
            
        }
        return dictArray
    }
}

enum FormItemCellType {
    case textField
    case textView
    case dropDown
    case imageUpload
    case boolCheck
    case addressCheck
    case label
    case location
    case addressType
    case addressMove
    case date
    case radio
    case price
    case singleDropDown
    case changePassword
    case descriptionView
    /// Registering methods for all forms items cell types
    ///
    /// - Parameter tableView: TableView where apply cells registration
    static func registerCells(for tableView: UITableView) {
        
        tableView.register(cellType: AddressFieldTableViewCell.self)
        tableView.register(cellType: AddressMoveTableViewCell.self)
        tableView.register(cellType: BoolCheckTableViewCell.self)
        tableView.register(cellType: AddressCheckTableViewCell.self)
        //         tableView.register(cellType: AdressTypeTableViewCell.self)
        tableView.register(cellType: FormLabelTableViewCell.self)
        //         tableView.register(cellType: FormLocationTableViewCell.self)
        tableView.register(cellType: FormTextViewTableViewCell.self)
        tableView.register(cellType: FormDropDownTableViewCell.self)
        tableView.register(cellType: DateFormTableViewCell.self)
        tableView.register(cellType: FormRadioTableViewCell.self)
        tableView.register(cellType: FormPriceTableViewCell.self)
        tableView.register(cellType: SingleDropDownTableViewCell.self)
        tableView.register(cellType: ChangeTableViewCell.self)
        tableView.register(cellType: FormTextViewDescriptionTableViewCell.self)
        
    }
    
    /// Correctly dequeue the UITableViewCell according to the current cell type
    ///
    /// - Parameters:
    ///   - tableView: TableView where cells previously registered
    ///   - indexPath: indexPath where dequeue
    /// - Returns: a non-nullable UITableViewCell dequeued
    func dequeueCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        
        switch self {
        case .textView:
            cell = tableView.dequeueReusableCell(for: indexPath,
                                                 cellType: FormTextViewTableViewCell.self)
        case .singleDropDown:
            
            cell = tableView.dequeueReusableCell(for: indexPath,
                                                 cellType: SingleDropDownTableViewCell.self)
            if let cell = cell as? SingleDropDownTableViewCell {
                cell.tableView = tableView
            }
        case .textField:
            cell = tableView.dequeueReusableCell(for: indexPath,
                                                 cellType: AddressFieldTableViewCell.self)
        case .dropDown:
            //            cell = UITableViewCell()
            cell = tableView.dequeueReusableCell(for: indexPath,
                                                 cellType: FormDropDownTableViewCell.self)
            if let cell = cell as? FormDropDownTableViewCell {
                cell.tableView = tableView
            }
        case .imageUpload:
            cell = UITableViewCell()
        case .boolCheck:
            cell = tableView.dequeueReusableCell(for: indexPath,
                                                 cellType: BoolCheckTableViewCell.self)
            //            cell = tableView.dequeueReusableCell(for: indexPath,
        //                                                 cellType: FormImageUploadTableViewCell.self)
        case .addressCheck:
            cell = tableView.dequeueReusableCell(for: indexPath,
                                                 cellType: AddressCheckTableViewCell.self)
        case .label:
            cell = tableView.dequeueReusableCell(for: indexPath,
                                                 cellType: FormLabelTableViewCell.self)
        case .location:
            cell = UITableViewCell()
        case .addressType:
            cell = UITableViewCell()
        case .addressMove:
            cell = tableView.dequeueReusableCell(for: indexPath,
                                                 cellType: AddressMoveTableViewCell.self)
        case .date:
            cell = tableView.dequeueReusableCell(for: indexPath,
                                                 cellType: DateFormTableViewCell.self)
        case .radio:
            cell = tableView.dequeueReusableCell(for: indexPath,
                                                 cellType: FormRadioTableViewCell.self)
        case .price:
            cell = tableView.dequeueReusableCell(for: indexPath,
                                                 cellType: FormPriceTableViewCell.self)
        case .changePassword:
            cell = tableView.dequeueReusableCell(for: indexPath,
                                                 cellType: ChangeTableViewCell.self)
            
        case .descriptionView:
            cell = tableView.dequeueReusableCell(for: indexPath,cellType: FormTextViewDescriptionTableViewCell.self)
            
        }
        return cell
    }
}

protocol FormUpdatable {
    func update(with formItem: FormItem)
}

/// Conform receiver to have a form item property
protocol FormConformity {
    var formItem: FormItem? {get set}
}
