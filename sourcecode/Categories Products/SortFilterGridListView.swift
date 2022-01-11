//
//  SortFilterGridListView.swift
//  Mobikul Single App
//
//  Created by akash on 27/01/19.
//  Copyright © 2019 kunal. All rights reserved.
//

import UIKit

protocol SortFilterGridListActions: class {
    func tappedSort()
    func tappedFilter()
    func tappedGridList()
}

class SortFilterGridListView: UIView {
    
    @IBOutlet weak var containerView: UIView!
//    @IBOutlet weak var sortLbl: UILabel!
//    @IBOutlet weak var filterLbl: UILabel!
//    @IBOutlet weak var gridListImg: UIImageView!
//    @IBOutlet weak var gridListLbl: UILabel!
    @IBOutlet weak var sortBtn: UIButton!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var gridListBtn: UIButton!
    @IBOutlet weak var sortApplyView: UIView!
    @IBOutlet weak var filterApplyView: UIView!
    
    weak var delegate: SortFilterGridListActions?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let xibView = Bundle.main.loadNibNamed("SortFilterGridListView", owner: self, options: nil)?.first as? UIView {
            xibView.frame = self.bounds
            xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.addSubview(xibView)
        }
    }
    
    override func awakeFromNib() {
        filterBtn.setTitle("FILTER".localized, for: .normal)
        sortBtn.setTitle("SORT".localized, for: .normal)
    }
    
    @IBAction func tapSortBtn(_ sender: UIButton) {
        self.delegate?.tappedSort()
    }
    
    @IBAction func tapFilterBtn(_ sender: UIButton) {
        self.delegate?.tappedFilter()
    }
    
    @IBAction func tapGridListBtn(_ sender: UIButton) {
        self.delegate?.tappedGridList()
    }
    
}
