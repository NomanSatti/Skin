//
//  SearchHeader.swift
//  Mobikul Single App
//
//  Created by akash on 11/02/19.
//  Copyright © 2019 kunal. All rights reserved.
//

import UIKit

class SearchHeader: UIView {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var clearBtn: UIButton!
    let nibName = "SearchHeader"
    var contentView: UIView!
    
    override func awakeFromNib() {
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let xibView = Bundle.main.loadNibNamed("SearchHeader", owner: self, options: nil)?[0] as? UIView {
            xibView.frame = self.bounds
            xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.addSubview(xibView)
        }
    }
    
    private func setUpView() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        contentView.frame = self.frame
        self.contentView.layoutIfNeeded()
        addSubview(contentView)
        contentView.center = self.center
        contentView.autoresizingMask = []
        contentView.translatesAutoresizingMaskIntoConstraints = true
    }
}
