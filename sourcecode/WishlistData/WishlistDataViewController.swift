import UIKit

@objcMembers
class WishlistDataViewController: UIViewController {
    
    @IBOutlet weak var massUpdateBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addAllToCartBtn: UIButton!
    
    var wishlistViewModalObject: WishlistViewModel?
    var emptyView: EmptyView!
    var move = false
    var loginBtn: UIButton!
    var shareBtn: UIBarButtonItem!
    var comment  = false
    override func viewDidLoad() {
        super.viewDidLoad()
        massUpdateBtn.setTitle("Update Wish List".localized, for: .normal)
        addAllToCartBtn.setTitle("Add All to Cart".localized, for: .normal)
        //        massUpdateBtn.isHidden = true
        //        addAllToCartBtn.isHidden = true
        massUpdateBtn.applyBorder(colours: AppStaticColors.accentColor)
        addAllToCartBtn.applyBorder(colours: AppStaticColors.accentColor)
        massUpdateBtn.layer.borderColor = UIColor.lightGray.cgColor
        addAllToCartBtn.layer.borderColor = UIColor.lightGray.cgColor
        self.navigationItem.title = "Wishlist".localized
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isHidden = false
        wishlistViewModalObject = WishlistViewModel()
        wishlistViewModalObject?.wishlistController = self
        wishlistViewModalObject?.collectionView = collectionView
        collectionView.register(cellType: WishlistProductCollectionViewCell.self)
        wishlistViewModalObject?.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        if !comment {
            self.massUpdateBtn.isHidden = true
            self.addAllToCartBtn.isHidden = true
            wishlistViewModalObject?.wishList.removeAll()
            self.collectionView.reloadData()
        }
        setupEmptyView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !comment {
            wishlistViewModalObject?.pageNumber = 1
            wishlistViewModalObject?.wishList.removeAll()
            self.collectionView.reloadData()
            self.massUpdateBtn.isHidden = true
            self.addAllToCartBtn.isHidden = true
            wishlistViewModalObject?.whichApiCall = .getWishlistData
            wishlistViewModalObject?.callingHttppApi(completionHandler: { (_) in
                self.massUpdateBtn.isHidden = false
                self.addAllToCartBtn.isHidden = false
            })
        }
        //self.addCutomBtn()
        self.tabBarController?.tabBar.isHidden = false
        if move == false {
            
        } else {
            move = false
        }
        self.setupEmptyView()
    }
    
    func setupEmptyView() {
        if emptyView == nil {
            emptyView = EmptyView(frame: self.view.frame)
            self.view.addSubview(emptyView)
            emptyView.isHidden = true
            emptyView.emptyImages.addSubview(LottieHandler.sharedInstance.initializeLottie(bounds: emptyView.emptyImages.bounds, fileName: "WishlistFile"))
        }
        if Defaults.customerToken == nil {
            emptyView?.actionBtn.setTitle("Signin".localized, for: .normal)
            emptyView?.labelMessage.text = "".localized
            emptyView?.titleText.text = "You need to login first!!".localized
        } else {
            emptyView?.actionBtn.setTitle("Start Shopping".localized, for: .normal)
            emptyView?.labelMessage.text = "You didn’t add anything to wishlist yet.".localized
            emptyView?.titleText.text = "No Items".localized
        }
        emptyView.actionBtn.addTapGestureRecognizer {
            if Defaults.customerToken == nil {
                self.loginBtnClicked(UIButton())
            } else {
                self.emptyClicked()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        comment = false
    }
    
    func addCutomBtn() {
        if loginBtn == nil && Defaults.customerToken == nil {
            loginBtn = UIButton(type: .custom)
            loginBtn.frame = CGRect(x: 0, y: 0, width: 96, height: 30)
            loginBtn.backgroundColor = UIColor().hexToColor(hexString: "f5f5f5", alpha: 1.0)
            loginBtn.setTitleColor(UIColor().hexToColor(hexString: "000000", alpha: 1.0), for: .normal)
            loginBtn.setTitle("Signin".localized, for: .normal)
            loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
            
            loginBtn.addTarget(self, action: #selector(loginBtnClicked(_:)), for: .touchUpInside)
            let item = UIBarButtonItem(customView: loginBtn)
            self.navigationItem.setRightBarButton(item, animated: false)
        } else {
            if let loginBtn = loginBtn, Defaults.customerToken != nil {
                loginBtn.removeFromSuperview()
            }
        }
        
    }
    
    @IBAction func loginBtnClicked(_ sender: UIButton) {
        let customerLoginVC = SignInViewController.instantiate(fromAppStoryboard: .customer)
        let nav = UINavigationController(rootViewController: customerLoginVC)
        nav.modalPresentationStyle = .fullScreen
        //nav.navigationBar.tintColor = AppStaticColors.accentColor
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func massUpdateClicked(_ sender: Any) {
        wishlistViewModalObject?.update()
    }
    
    @IBAction func tapAddAllToCart(_ sender: Any) {
        wishlistViewModalObject?.addAllToCart()
    }
    
    func emptyClicked() {
        self.tabBarController?.selectedIndex = 0
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tapShareWishlistBtn(_ sender: Any) {
        let viewController = ShareWishlistViewController.instantiate(fromAppStoryboard: .main)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension WishlistDataViewController: MoveController {
    func moveController(id: String, name: String, dict: [String: Any], jsonData: JSON, type: String, controller: AllControllers) {
        if controller == .productPage {
            let viewController = ProductPageDataViewController.instantiate(fromAppStoryboard: .product)
            viewController.productId = id
            viewController.productName = name
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            let VC = CommentsDataViewController.instantiate(fromAppStoryboard: .product)
            self.move = true
            VC.comment = type
            let nav = UINavigationController(rootViewController: VC)
            //nav.navigationBar.tintColor = AppStaticColors.accentColor
            VC.callback = { text in
                self.comment = true
                if let wishlistViewModalObject = self.wishlistViewModalObject, let index = wishlistViewModalObject.wishlistModel.wishList.firstIndex(where: { $0.id == id  }) {
                    wishlistViewModalObject.wishlistModel.wishList[index].updateComment(comment: text)
                    self.collectionView.reloadData()
                }
            }
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
        
    }
}
