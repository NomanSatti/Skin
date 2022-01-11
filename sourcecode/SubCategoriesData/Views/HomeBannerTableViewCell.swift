//
//  HomeBannerTableViewCell.swift
//  Odoo application
//
//  Created by vipin sahu on 8/31/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit
import SwiftyJSON

@objcMembers
class HomeBannerTableViewCell: UITableViewCell {
    
    var banner = [BannerImage]()
    var pageControlView = CHIPageControlFresno()
    
    @IBOutlet weak var page: UIView!
    @IBOutlet weak var bannerCollection: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bannerCollection.register(HomeBannerCollectionViewCell.nib, forCellWithReuseIdentifier: HomeBannerCollectionViewCell.identifier)
        self.startTimer()
        bannerCollection.showsHorizontalScrollIndicator = false
        pageControlView =  CHIPageControlFresno(frame: page.frame)
        pageControlView.radius = 4
        pageControlView.tintColor = .white
        pageControlView.borderWidth = 1
        pageControlView.layer.borderColor = UIColor.white.cgColor
        pageControlView.currentPageTintColor = .white
        pageControlView.center = CGPoint(x: AppDimensions.screenWidth/2, y: 20/2)
        page.addSubview(pageControlView)
        bannerCollection.delegate = self
        bannerCollection.dataSource = self
        selectionStyle = .none
    }
    
    func startTimer () {
        
        //        if timerTest == nil {
        //            timerTest =  Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
        //        }
    }
    
    func stopTimerTest() {
        if timerTest != nil {
            timerTest?.invalidate()
            timerTest = nil
        }
    }
    
    var timerTest: Timer?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension HomeBannerTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControlView.numberOfPages = banner.count
        return banner.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBannerCollectionViewCell", for: indexPath as IndexPath) as? HomeBannerCollectionViewCell {
            cell.item = banner[indexPath.row]
            cell.setNeedsLayout()
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: AppDimensions.screenWidth, height: 2*AppDimensions.screenWidth / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

extension HomeBannerTableViewCell: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControlView.set(progress: Int(scrollView.contentOffset.x /  AppDimensions.screenWidth), animated: true)
    }
    
    func scrollAutomatically(_ timer1: Timer) {
        if let coll  = bannerCollection {
            for cell in coll.visibleCells {
                if  let indexPath: IndexPath = coll.indexPath(for: cell), ((indexPath.row)  < coll.numberOfItems(inSection: 0) - 1) {
                    let indexPath1: IndexPath = IndexPath.init(row: (indexPath.row) + 1, section: (indexPath.section))
                    coll.scrollToItem(at: indexPath1, at: .right, animated: true)
                } else {
                    if  let indexPath: IndexPath = coll.indexPath(for: cell) {
                        let indexPath1 = IndexPath.init(row: 0, section: (indexPath.section))
                        coll.scrollToItem(at: indexPath1, at: .left, animated: true)
                    }
                }
            }
        }
    }
}
