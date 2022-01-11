//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: ProductPageDelegates.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation

protocol GettingProductQuantity: NSObjectProtocol {
    func gettingProductQuantity(qty: Int)
}

protocol AddToCartProduct: NSObjectProtocol {
    func addToCartProduct(cart: Bool)
}

protocol GettingDownloadableData: NSObjectProtocol {
    func gettingDownloadableData(data: [String: Any])
}

protocol GettingGroupedData: NSObjectProtocol {
    func gettingGroupedData(data: [String: Any], section: Int)
}

protocol GettingBundleData: NSObjectProtocol {
    func gettingBundleData(data: [String: Any], qtyDict: [String: Any], selectedItem: Int)
}

protocol GettingImageOptions: NSObjectProtocol {
    func gettingBundleData(visible: Bool)
}

protocol ShareClicked: NSObjectProtocol {
    func shareClicked(productLink: String)
}

protocol GettingConfigurableData: NSObjectProtocol {
    func gettingConfigurablData(data: [String: String], unselectedValues: [String], productId: String?, optionProductId: String?)
}

protocol MoveFromProductController: NSObjectProtocol {
    func move(id: String, controller: AllControllers)
}


protocol GettingCustomData: NSObjectProtocol {
    func gettingCustomData(data: [String: Any])
    func gettingCustomFileData(data: [String: FileInfo])
}
