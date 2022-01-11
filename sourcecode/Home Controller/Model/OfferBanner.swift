//
//  OfferBanner.swift
//  sourcecode
//
//  Created by Noman Satti on 05/01/2022.
//  Copyright © 2022 ranjit. All rights reserved.
//

import Foundation

public final class OfferBanner {
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
