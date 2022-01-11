//
//  Categories.swift
//
//  Created by rakesh on 21/07/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Categories {
    
    var thumbnail: String!
    var banner: String!
    var bannerDominantColor: String!
    var id: String!
    var hasChildren: Bool!
    var thumbnailDominantColor: String!
    var name: String!
    
    init(json: JSON) {
        thumbnail = json["thumbnail"].stringValue
        banner = json["banner"].stringValue
        bannerDominantColor = json["bannerDominantColor"].stringValue
        id = json["id"].stringValue
        hasChildren = json["hasChildren"].boolValue
        thumbnailDominantColor = json["thumbnailDominantColor"].stringValue
        name = json["name"].stringValue
    }
    
}
