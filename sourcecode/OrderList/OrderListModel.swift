//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: OrderListModel.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation

class OrderListModel {
    var orderListData = [OrderListDataStruct]()
    var totalItem: Int?
    init?(data: JSON) {
        print("Response data: ", data)
        totalItem = data["totalCount"].intValue
        for i in 0..<data["orderList"].count {
            orderListData.append(OrderListDataStruct.init(data: data["orderList"][i]))
        }
    }
}

struct OrderListDataStruct {
    var orderId: String?
    var orderStatus: String?
    var orderDate: String?
    var orderPrice: String?
    var canReorder: Bool?
    var statusColorCode: String!
    var itemImageUrl: String!
    init(data: JSON) {
        orderId = data["order_id"].stringValue
        orderStatus = data["status"].stringValue
        orderDate = data["date"].stringValue
        orderPrice = data["order_total"].stringValue
        canReorder = data["canReorder"].boolValue
        statusColorCode = data["statusColorCode"].stringValue
        itemImageUrl = data["item_image_url"].stringValue
    }
    
}
