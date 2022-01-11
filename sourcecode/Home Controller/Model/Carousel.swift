//
//  Carousel.swift
//
//  Created by rakesh on 21/07/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Carousel {
    
    var label: String!
    var banners = [Banners]()
    var id: String!
    var productList = [ProductList]()
    var type: String!
    var order: String!
    var layoutType: Int!
    
    init(json: JSON) {
        label = json["label"].stringValue
        if let items = json["banners"].array { banners = items.map { Banners(json: $0) } }
        id = json["id"].stringValue
        if let items = json["productList"].array { productList = items.map { ProductList(json: $0) } }
        type = json["type"].stringValue
        order = json["order"].stringValue
        self.layoutType = Int().random(1..<4)
    }
    
}
