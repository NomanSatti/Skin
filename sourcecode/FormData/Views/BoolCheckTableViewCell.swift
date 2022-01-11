//
//  BoolCheckTableViewCell.swift
//  MobikulOpencartMp
//
//  Created by bhavuk.chawla on 18/11/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import UIKit
import Reusable

class BoolCheckTableViewCell: UITableViewCell, FormConformity, NibReusable {
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var yesImage: UIImageView!
    @IBOutlet weak var yesBrn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var noImage: UIImageView!
    var formItem: FormItem?
    override func awakeFromNib() {
        super.awakeFromNib()
        yesImage.applyBorder(colours: UIColor.lightGray)
        noImage.applyBorder(colours: UIColor.lightGray)
        noImage.layer.cornerRadius = 2
        yesImage.layer.cornerRadius = 2
        
        bottomLabel.text = "By registering now in the Musaed Alajlan App, you agree to ".localized + "Terms of return".localized + " and ".localized +  "replacement".localized
        
        //        bottomLabel.halfTextWithColorChange(fullText: bottomLabel.text!, changeText: "Terms of return".localized, color: UIColor().HexToColor(hexString: LIGHTGREY))
        //        bottomLabel.halfTextWithColorChange(fullText: bottomLabel.text!, changeText: "replacement".localized, color: UIColor().HexToColor(hexString: LIGHTGREY))
        //        
        yesImage.isUserInteractionEnabled = true
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap))
        yesImage.addGestureRecognizer(doubleTap)
        
        noImage.isUserInteractionEnabled = true
        let doubleTap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap1))
        noImage.addGestureRecognizer(doubleTap1)
        
        bottomLabel.isUserInteractionEnabled = true
        let doubleTap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap2))
        bottomLabel.addGestureRecognizer(doubleTap2)
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func handleDoubleTap2() {
        //        let str = UIStoryboard(name: "Customer", bundle: nil)
        //        let view = str.instantiateViewController(withIdentifier: "cmsDataViewController") as! CmsDataViewController
        //        view.api = "terms"
        //        let nav = UINavigationController(rootViewController: view)
        //        self.viewController()?.present(nav, animated: true, completion: nil)
    }
    @objc func handleDoubleTap() {
        noImage.backgroundColor = UIColor.white
        self.noImage.image = nil
        if let form = formItem {
            form.value = "1"
            self.yesImage.image = UIImage(named: "ic_check")
            yesImage.backgroundColor = AppStaticColors.accentColor
            yesImage.clipsToBounds = true
        }
    }
    
    @objc func handleDoubleTap1() {
        yesImage.backgroundColor = UIColor.white
        self.yesImage.image = nil
        if let form = formItem {
            form.value = "0"
            self.noImage.image = UIImage(named: "ic_check")
            noImage.backgroundColor = AppStaticColors.accentColor
            noImage.clipsToBounds = true
        }
    }
    
    @IBAction func yesClicked(_ sender: Any) {
        self.handleDoubleTap()
    }
    @IBAction func noClicked(_ sender: Any) {
        self.handleDoubleTap1()
        
    }
    
}

extension BoolCheckTableViewCell: FormUpdatable {
    func update(with formItem: FormItem) {
        self.formItem = formItem
        self.headingLabel.text = formItem.placeholder
        if formItem.value as? String == "0" {
            self.noImage.image = UIImage(named: "ic_check")
            noImage.backgroundColor = AppStaticColors.accentColor
            noImage.clipsToBounds = true
            yesImage.backgroundColor = UIColor.white
            self.yesImage.image = nil
        }
        
        if formItem.value as? String == "1" {
            self.yesImage.image = UIImage(named: "ic_check")
            yesImage.backgroundColor = AppStaticColors.accentColor
            yesImage.clipsToBounds = true
            noImage.backgroundColor = UIColor.white
            self.noImage.image = nil
        }
    }
}
