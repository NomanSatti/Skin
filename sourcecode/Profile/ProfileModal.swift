//
//  ProfileModal.swift
//  Mobikul Single App
//
//  Created by akash on 19/01/19.
//  Copyright © 2019 kunal. All rights reserved.
//

import Foundation
import UIKit

struct ProfileItem {
    
    var image: UIImage?
    var title: String!
    var action: AllControllers!
    
    init(image: String, title: String, action: AllControllers) {
        self.image = UIImage(named: image)
        self.title = title
        self.action = action
    }
}
