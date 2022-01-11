//
//  EmptyNewAddressView.swift
//  WooCommerce
//
//  Created by Webkul  on 09/11/17.
//  Copyright © 2017 Webkul . All rights reserved.
//

import UIKit

class EmptyView: UIView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var emptyImages: UIImageView!
    @IBOutlet weak var titleText: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("EmptyView", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.frame
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        actionBtn.layer.cornerRadius = 5
        actionBtn.layer.masksToBounds = true
    }
    
}
