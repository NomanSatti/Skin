//
//  BaseViewController.swift
//  Skins
//
//  Created by Work on 2/16/20.
//  Copyright © 2020 Work. All rights reserved.
//

import UIKit
import Alamofire
//import AlamofireImage

protocol BaseViewControllerDelegate: class {
    
    func leftNavigationBarButtonClicked()
    func rightPrimaryNavigationBarButtonClicked(_ sender: UIButton)
    func rightSecondaryNavigationBarButtonClicked(_ sender: UIButton)
    func rightThirdNavigationBarButtonClicked(_ sender: UIButton)
    func canLeftNavigationBarButtonClicked() -> Bool
    func nuanceControllerDidFinishProcessing()
}

extension BaseViewControllerDelegate {
    
    func leftNavigationBarButtonClicked() {}
    func rightPrimaryNavigationBarButtonClicked(_ sender: UIButton) {}
    func rightSecondaryNavigationBarButtonClicked(_ sender: UIButton) {}
    func rightThirdNavigationBarButtonClicked(_ sender: UIButton) {}
    func canLeftNavigationBarButtonClicked() -> Bool { return true }
    func nuanceControllerDidFinishProcessing(){}
}



class BaseViewController: UIViewController {
    
    
    //MARK:- Variables
    weak var baseDelegate: BaseViewControllerDelegate?
    var rightNavigationBarButtons: [UIBarButtonItem] = []
    lazy var leftNavigationButton: UIButton = self.initialLeftButton()
    @IBOutlet weak internal var bottomSubmitButtonConstraint: NSLayoutConstraint?

    
    //MARK:- ViewController Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                                style: .plain,
                                                                target: nil,
                                                                action: nil)
        
        self.navigationController?.view?.removeGestureRecognizer(self.navigationController!.interactivePopGestureRecognizer!)
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "placeholder"))
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        self.setTitleView(imageView)
//        self.showRightNavigationBarButtonsWithImage(["search", "account"])
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main) { (notification) in
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.bottomSubmitButtonConstraint?.constant =  8
            })

        }
        notificationCenter.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: OperationQueue.main) { (notification) in
            let userInfo = notification.userInfo!
            let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let keyboardViewEndFrame = self.view.convert(keyboardScreenEndFrame, from: self.view.window)
            // Nuance Toolbar height 60 iPad, 40 iPhone.
            if keyboardViewEndFrame.size.height == 60 ||  keyboardViewEndFrame.size.height == 40 {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.bottomSubmitButtonConstraint?.constant = keyboardViewEndFrame.size.height + 8
                })
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
    }
    
    deinit {
        print("deinit - \(type(of: self))")
    }
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        self.view.endEditing(true)
    }
    
    //MARK:- Public Methods
    
    func hideNavigationBar(_ hide: Bool = true,
                           animated: Bool = false) {
        
        self.navigationController?.setNavigationBarHidden(hide,
                                                          animated: animated)
    }
    
    func makeUINavigationBarTransparent() {
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(),
                                                                    for:.default)
        
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
    }
    
    func setTitle(_ titleStr: String = "",
                  showBackButton: Bool = true) {
        
        //self.title = titleStr
        
        self.hideNavigationBar(false)
        self.showBackButton(showBackButton)
    }
    
    func setTitleImage(_ imageName: String,
                       showBackButton: Bool = true) {
        
        self.setTitleView(UIImageView(image: UIImage(named: imageName)),
                          showBackButton: showBackButton)
        
        self.hideNavigationBar(false)
        self.showBackButton(showBackButton)
    }
    
    func setTitleView(_ view: UIView,
                      showBackButton: Bool = true) {
        
        self.navigationItem.titleView = view
        
        self.hideNavigationBar(false,
                               animated: false)
        self.showBackButton(showBackButton)
    }
    
    func updateTitleViewImage() {
        
    }
    
    func showBackButton(_ show: Bool = true) {
        
        if show {
            
            let backButtonItem = UIBarButtonItem(customView: self.leftNavigationButton)
            
            self.navigationItem.setLeftBarButton(backButtonItem, animated: false)
            
        } /*else {
            self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: UIButton()), animated: false)
        }*/
    }
    
    func showRightNavigationBarButtonsWithTitle(_ titles: [String],
                                                layoutImmediately: Bool = false) {
        
        if self.rightNavigationBarButtons.count != titles.count || layoutImmediately {
            
            var tagIndex = 1
            self.rightNavigationBarButtons.removeAll()
            for title in titles {
                let btn = UIButton.init(type: UIButton.ButtonType.custom)
                btn.setTitle(title, for: UIControl.State.normal)
                btn.addTarget(self, action: #selector(BaseViewController.rightNavigationButtonClicked(_:)), for: UIControl.Event.touchUpInside)
                btn.sizeToFit()
                btn.tag = tagIndex
                let navbarItem = UIBarButtonItem(customView:btn)
                
                self.rightNavigationBarButtons.append(navbarItem)
                
                tagIndex += 1
            }
            
            self.navigationItem.rightBarButtonItems = self.rightNavigationBarButtons
        }
    }
    
    func showRightNavigationBarButtonsWithImage(_ imageNames: [String],
                                                layoutImmediately: Bool = false) {
        
        if self.rightNavigationBarButtons.count != imageNames.count || layoutImmediately {
            
            var tagIndex = imageNames.count
            print(tagIndex)
            self.rightNavigationBarButtons.removeAll()
            for imageName in imageNames {
                let btn = UIButton.init(type: UIButton.ButtonType.custom)
                btn.setBackgroundImage(UIImage(named: imageName), for: UIControl.State.normal)
                btn.addTarget(self, action: #selector(BaseViewController.rightNavigationButtonClicked(_:)), for: UIControl.Event.touchUpInside)
                btn.sizeToFit()
                btn.tag = tagIndex
                let navbarItem = UIBarButtonItem(customView:btn)
                
                self.rightNavigationBarButtons.append(navbarItem)
                
                tagIndex -= 1
            }
            
            
            self.navigationItem.rightBarButtonItems = self.rightNavigationBarButtons
        }
    }
    
    func hideLeftNavigationButton(_ hide: Bool = true) {
        
        self.leftNavigationButton.isHidden = hide
    }
    
    
    //MARK:- Private Methods
    fileprivate func initialLeftButton() -> UIButton {
        
        var image = UIImage(named: "menu_icon")
        if let shouldShowBack = self.navigationController?.viewControllers.count,  shouldShowBack > 1 {
            
           /* if LoggedInUserHelper.sharedInstance.currentLanguage == .arabic {
                image = UIImage(named: "ar-backButton")
            } else {
                image = UIImage(named: "en-backButton")
            }*/
        }
         image = UIImage(named: "backArrow")
        let button = UIButton(frame: CGRect(x: 0,
                                            y: 0,
                                            width: 40,
                                            height: 40))
        
        button.imageEdgeInsets = UIEdgeInsets(top: 0,
                                              left: -20,
                                              bottom: 0,
                                              right: 0)
        button.addTarget(self,
                         action: #selector(BaseViewController.leftNavigationButtonClicked(_:)),
                         for: .touchUpInside)
        
        if let img = image {
            button.setImage(img, for: UIControl.State())
        }
        return button
    }
    
    
    // Mark: - Public API Methods
    
    //MARK:- Actions
    @objc internal func leftNavigationButtonClicked(_ sender: UIButton) {
        
        if let canGoBack = self.baseDelegate?.canLeftNavigationBarButtonClicked() {
            
            if canGoBack {
                
                self.confirmedLeftNavigationButtonClicked()
            }
        } else {
            
            self.confirmedLeftNavigationButtonClicked()
        }
    }
    
    internal func confirmedLeftNavigationButtonClicked() {
        
        if let nav = self.navigationController, nav.viewControllers.count > 1 {
            
            self.baseDelegate?.leftNavigationBarButtonClicked()
            _ = self.navigationController?.popViewController(animated: true)
            
        } else {
            
            self.btnMenuClicked()
        }
    }
    
    internal func btnMenuClicked() {
        
        self.view.endEditing(true)
    }
    
    @objc internal func rightNavigationButtonClicked(_ sender: UIButton) {
        
        if sender.tag == 1 {
            
            self.baseDelegate?.rightPrimaryNavigationBarButtonClicked(sender)
        } else if sender.tag == 2 {
            
            self.baseDelegate?.rightSecondaryNavigationBarButtonClicked(sender)
        } else {
            self.baseDelegate?.rightThirdNavigationBarButtonClicked(sender)
        }
        
        // Hide keybaord here.
        UIApplication.shared.windows.first?.endEditing(true)
    }
    
}
