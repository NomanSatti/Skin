//
//  BannerImages.swift
//
//  Created by rakesh on 21/07/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class BannerImages {
    
    var productName: String!
    var title: String!
    var productId: String!
    var bannerType: String!
    var url: String!
    var error: Bool!
    var categoryName: String!
    var categoryId: String!
    var dominantColor: String!
    var id: String!
    
    init(json: JSON) {
        productName = json["productName"].stringValue
        title = json["title"].stringValue
        productId = json["productId"].stringValue
        categoryName = json["categoryName"].string ?? json["name"].stringValue
        categoryId = json["categoryId"].stringValue
        bannerType = json["bannerType"].stringValue
        url = json["url"].stringValue
        error = json["error"].boolValue
        id = json["id"].stringValue
        dominantColor = json["dominantColor"].stringValue
    }
}


struct AdsImage: Codable {
      let id, name, banner: String
  }

/*public final class AdsImage {
    
   struct AdsImage: Codable {
        let id, name, banner: String
    }

    
    init(json: JSON) {
      
        title = json["title"].stringValue
        bannerType = json["bannerType"].stringValue
        url = json["url"].stringValue
     
    }
}*/
