//
/**
 Mobikul_Magento2V3_App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: BottomMoveToTopTableView.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit
import SnapKit

class BottomMoveToTopTableView: UIView {
    @IBOutlet weak var bottomLabelMessage: UILabel!
    var tableView: UITableView!
    @IBOutlet weak var backToTopButton: UIButton!
    
    @IBOutlet weak var bottomLine: UILabel!
    
    
    lazy var socialCollectionViewLayout: UICollectionViewFlowLayout = {
          let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
        
          
       }()
    
    lazy var socialCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: socialCollectionViewLayout)
        return view
       
    }()
    
    
    override func layoutSubviews() {
        //        bottomLabelMessage.font = UIFont(name: REGULARFONT, size: 12)
        
        self.addSubview(bottomLabelMessage)
        self.bottomLabelMessage.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(5)
            make.height.equalTo(self.snp.height).multipliedBy(0.35)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(self.snp.width).multipliedBy(0.8)
        }
        
        self.addSubview(backToTopButton)
        self.backToTopButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.bottomLabelMessage.snp.bottom).offset(2)
            make.height.equalTo(self.snp.height).multipliedBy(0.25)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(self.snp.width).multipliedBy(0.5)
        }
        
        self.addSubview(bottomLine)
        self.bottomLine.snp.makeConstraints { (make) in
            make.top.equalTo(self.backToTopButton.snp.bottom).offset(3)
            make.height.equalTo(1)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(self.snp.width).multipliedBy(0.75)
        }
        
        self.addSubview(socialCollectionView)
        self.socialCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.bottomLine.snp.bottom).offset(3)
            make.bottom.equalTo(self.snp.bottom)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(self.snp.width).multipliedBy(0.7)
        }
        
        
        
        bottomLabelMessage.textColor = UIColor(red: 117 / 255.0, green: 117 / 255.0, blue: 117 / 255.0, alpha: 1 / 1.0)
        bottomLabelMessage.text = "You have just reached to the bottom of page.".localized
        backToTopButton.setTitle("Back to Top".localized.uppercased(), for: .normal)
        //        backToTopButton.titleLabel?.font = UIFont(name: BOLDFONT, size: 12)
        backToTopButton.titleLabel?.textColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 1 / 1.0)
    }
    
    @IBAction func backToTopButtonAction(_ sender: Any) {
        scrollToFirstRow() 
    }
    
    func scrollToFirstRow() {
        let indexPath = NSIndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
    }
    
    
    
    
}
