//
//  BasePrice.swift
//
//  Created by rakesh on 21/07/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class BasePrice {
    
    var amount: String?
    
    init(json: JSON) {
        amount = json["amount"].stringValue
    }
}
