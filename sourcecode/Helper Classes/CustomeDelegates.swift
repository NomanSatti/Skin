//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: CustomeDelegates.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation

protocol PasswordCharacter: NSObjectProtocol {
    func passwordUpdate(data: String, confirmPassword: String)
}
protocol moveToControlller: NSObjectProtocol {
    func moveController(id: String, name: String, dict: [String: Any], jsonData: JSON, index: Int, controller: AllControllers)
}
protocol  NesLaterClick: NSObjectProtocol {
    func newLetterCheck(check: Bool)
}

protocol Pagination: NSObjectProtocol {
    func pagination()
}
protocol ReOrder: NSObjectProtocol {
    func reOrderAct()
}
protocol  OrderListReviewProduct: NSObjectProtocol {
    func orderListReviewProductAct(id: Int)
}

protocol changeDelegate{
    func passdata(index : Int, actionData : Int)
}

protocol  getImageDataProduct: NSObjectProtocol {
    func orderListReviewProductAct(id: Int)
}
