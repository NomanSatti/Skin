//
//  CategoryHeadeViewCell.swift
//  CS-Cart MVVM
//
//  Created by vipin sahu on 8/25/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class ProductSectionHeading: UITableViewHeaderFooterView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    var section: Int = 0
    weak var delegate: HeaderViewDelegate?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var arrowLabel: UIImageView!
    @IBOutlet weak var lineView: UIView!
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundView?.backgroundColor = UIColor(named: "BackColor")
        //        CategoryHeadeViewCell.backgroundColor = UIColor().HexToColor(hexString: .Credentials.defaultBackgroundColor)
        //        self.backgroundColor = UIColor(named: "BackColor")
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
    }
    
    @objc private func didTapHeader() {
        //        delegate?.toggleSection(header: self, section: section)
    }
    
    func setCollapsed(collapsed: Bool) {
//        arrowLabel?.image = UIImage(named: "icon-up")
//        arrowLabel?.rotate(collapsed ? 0.0 : .pi)
        arrowLabel?.rotateView(collapsed ? 0.0 : .pi)
    }
}

extension UIView {
    func rotateView(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        UIView.animate(withDuration: duration, animations: {
            self.transform = CGAffineTransform(rotationAngle: toValue)
        })
    }
}

extension UIView {
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        self.layer.add(animation, forKey: nil)
    }
}
