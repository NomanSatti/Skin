//
//  CustomCellCollectionViewCell.swift
//  Ticom
//
//  Created by bhavuk.chawla on 04/12/17.
//  Copyright © 2017 Bhavuk. All rights reserved.
//

import UIKit

class CustomCellCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var imagee: UIImageView!
    @IBOutlet weak var imageScroll: UIScrollView!
    @IBOutlet weak var playImg: UIImageView!
    
    @IBAction func imageClicked(_ sender: UITapGestureRecognizer) {
        print(imageScroll.zoomScale)
        
        if imageScroll.zoomScale == 1.0 {
            imageScroll.zoom(to: zoomRectForScale(scale: imageScroll.maximumZoomScale, center: sender.location(in: sender.view)), animated: true)
        } else {
            imageScroll.setZoomScale(1, animated: true)
        }
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        print("hello")
        var zoomRect = CGRect.zero
        zoomRect.size.height = imagee.frame.size.height / scale
        zoomRect.size.width  = imagee.frame.size.width  / scale
        let newCenter = imageScroll.convert(center, from: imagee)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imagee
    }
    
    override func awakeFromNib() {
        imageScroll.isUserInteractionEnabled = true
        imagee.isUserInteractionEnabled = true
        
        imageScroll.maximumZoomScale = 5.0
        imageScroll.minimumZoomScale = 1.0
        imageScroll.clipsToBounds = false
        imageScroll.delegate = self
        print(imageScroll.frame)
        print(imagee.frame)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageClicked))
        recognizer.numberOfTapsRequired = 2
        imagee.addGestureRecognizer(recognizer)
    }
}
