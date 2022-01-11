//
//  Banners.swift
//
//  Created by rakesh on 21/07/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Banners {
    var productName: String!
    var title: String!
    var bannerType: String!
    var productId: String!
    var url: String!
    var error: Bool! = false
    var categoryName: String!
    var categoryId: String!
    var dominantColor: String!
    var id: String!
    
    init(json: JSON) {
        productName = json["productName"].stringValue
        title = json["title"].stringValue
        bannerType = json["bannerType"].stringValue
        productId = json["productId"].stringValue
        url = json["url"].stringValue
        error = json["error"].boolValue
        categoryName = json["categoryName"].string ?? json["name"].stringValue
        categoryId = json["categoryId"].stringValue
        dominantColor = json["dominantColor"].stringValue
        id = json["id"].stringValue
        bannerType = json["bannerType"].stringValue
    }
}

public final class Ads {
  
    var url: String!
     var title: String!
  
    
    init(json: JSON) {
      
        url = json["url"].stringValue
         title = json["title"].stringValue
    }
}
