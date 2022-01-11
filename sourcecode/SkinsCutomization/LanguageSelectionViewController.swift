//
//  LanguageSelectionViewController.swift
//  sourcecode
//
//  Created by Work on 5/15/20.
//  Copyright © 2020 ranjit. All rights reserved.
//

import UIKit
import SnapKit

class LanguageSelectionViewController: UIViewController {

    var selctedIndex = 0
    
    lazy var logoView: UIImageView = {
       let view = UIImageView()
        view.image = #imageLiteral(resourceName: "Artboard")
        return view
    }()
    
    lazy var segemntControl: UISegmentedControl = {
        var items = ["Arabic", "English"]
        let sc = UISegmentedControl(items: items)
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    lazy var startButton: UIButton = {
       let button = UIButton()
        button.setTitle("Start ->", for: .normal)
       
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.lightGray
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
         Defaults.language = "ar"
         Defaults.storeId = "1"
        
        self.view.addSubview(logoView)
        logoView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.view.snp.centerY).offset(-50)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(self.view.snp.width).multipliedBy(0.5)
            make.height.equalTo(100)
        }
        
        self.view.addSubview(segemntControl)
        segemntControl.snp.makeConstraints { (make) in
            make.top.equalTo(self.logoView.snp.bottom).offset(30)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(self.view.snp.width).multipliedBy(0.65)
            make.height.equalTo(35)
        }
        
        self.segemntControl.addTarget(self, action: #selector(changeLanguage(sender:)), for: .valueChanged)
        
        self.view.addSubview(startButton)
        startButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.segemntControl.snp.bottom).offset(20)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(self.view.snp.width).multipliedBy(0.55)
            make.height.equalTo(35)
        }
        
        startButton.addTarget(self, action: #selector(setLanguageAndLauch), for: .touchUpInside)
        
        
    }
    
    
    @objc func changeLanguage(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            Defaults.language = "ar"
        case 1:
            Defaults.language = "en"
            Defaults.storeId = "2"
        default:
            break;
        }
    }
    
    @objc private func setLanguageAndLauch(){
        
        LaunchHome.shared.launchHome()
    }


}
