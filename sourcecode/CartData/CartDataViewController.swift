import UIKit

class CartDataViewController: UIViewController {
    
    @IBOutlet weak var bottomClicked: UIView!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountToBePaid: UILabel!
    @IBOutlet weak var crossBtn: UIBarButtonItem!
    @IBOutlet weak var wishlistBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var cartViewModalObject: CartViewModel?
    var emptyView: EmptyView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomClicked.addShadow(location: .top)
        crossBtn.tintColor = AppStaticColors.itemTintColor
        wishlistBtn.tintColor = AppStaticColors.itemTintColor
        wishlistBtn.title = "Go to wishlist".localized
        cartViewModalObject = CartViewModel()
        cartViewModalObject?.priceLabel = self.priceLabel
        cartViewModalObject?.cartController = self
        cartViewModalObject?.tableView = tableView
        self.navigationItem.title = "Cart".localized
        tableView.register(cellType: CartActionTableViewCell.self)
        tableView.register(cellType: CartProductTableViewCell.self)
        tableView.register(cellType: CartVoucherTableViewCell.self)
        tableView.register(cellType: CartPriceTableViewCell.self)
        tableView.register(cellType: RelatedProductTableViewCell.self)
        tableView.tableFooterView = UIView()
        proceedBtn.setTitle("Proceed".localized, for: .normal)
        amountToBePaid.text = "Amount to be paid".localized
        bottomClicked.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.cartViewModalObject?.whichApiCall = .getCartData
        self.callRequest()
        if emptyView == nil {
            emptyView = EmptyView(frame: self.view.frame)
            self.view.addSubview(emptyView)
            emptyView.isHidden = true
            emptyView.emptyImages.addSubview(LottieHandler.sharedInstance.initializeLottie(bounds: emptyView.emptyImages.bounds, fileName: "CartFile"))
            //            emptyView.emptyImages.image = UIImage(named: "illustration-bag")
            emptyView.actionBtn.setTitle("Start Shopping".localized, for: .normal)
            emptyView.labelMessage.text = "You have no items in your cart.".localized
            emptyView.titleText.text = "Empty Cart".localized
            emptyView.actionBtn.addTapGestureRecognizer {
                self.emptyClicked()
            }
        }
    }
    
    func emptyClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func crossClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func wishlistClicked(_ sender: Any) {
        if Defaults.customerToken == nil {
            let customerLoginVC = SignInViewController.instantiate(fromAppStoryboard: .customer)
            let nav = UINavigationController(rootViewController: customerLoginVC)
            //nav.navigationBar.tintColor = AppStaticColors.accentColor
            self.present(nav, animated: true, completion: nil)
        } else {
            let viewController = WishlistDataViewController.instantiate(fromAppStoryboard: .main)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func proceedClicked(_ sender: Any) {
        
        guard let cartModel =  cartViewModalObject?.cartModel else {
            return
        }
        
        if  cartModel.minimumAmount > cartModel.unformattedCartTotal {
            ShowNotificationMessages.sharedInstance.warningView(message: cartModel.descriptionMessage)
        } else if  !cartModel.isCheckoutAllowed {
            ShowNotificationMessages.sharedInstance.warningView(message: "You are not allowed to checkout".localized)
        } else  {
            if Defaults.customerToken != nil {
                let viewController = CheckoutDataViewController.instantiate(fromAppStoryboard: .checkout)
                let nav = UINavigationController(rootViewController: viewController)
                //nav.navigationBar.tintColor = AppStaticColors.accentColor
                viewController.isVirtual = self.cartViewModalObject?.cartModel.isVirtual
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            } else {
                self.showAlert()
            }
        }
        
    }
    
    func callRequest() {
        cartViewModalObject?.callingHttppApi { [weak self] success,_  in
            guard let self = self else { return }
            if success {
                self.priceLabel.text = self.cartViewModalObject?.cartModel.cartTotal
            } else {
                
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func showAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takeAction = UIAlertAction(title: "Checkout as new Customer".localized, style: .default, handler: new)
        let upload = UIAlertAction(title: "Checkout as existing Customer".localized, style: .default, handler: existing)
        let guestAction = UIAlertAction(title: "Checkout as guest Customer".localized, style: .default, handler: guest)
        let CancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: cancel)
        
        alert.addAction(takeAction)
        alert.addAction(upload)
        if let cartModel =  cartViewModalObject?.cartModel, cartModel.isAllowedGuestCheckout  {
            alert.addAction(guestAction)
        }
        
        alert.addAction(CancelAction)
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x:self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height - 60, width : 1.0, height : 1.0)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func new(alertAction: UIAlertAction!) {
        let customerCreateAccountVC = CreateAnAccountViewController.instantiate(fromAppStoryboard: .customer)
        let nav = UINavigationController(rootViewController: customerCreateAccountVC)
        //nav.navigationBar.tintColor = AppStaticColors.accentColor
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    func existing(alertAction: UIAlertAction!) {
        LaunchHome.needAppRefresh = false
        let customerLoginVC = SignInViewController.instantiate(fromAppStoryboard: .customer)
        let nav = UINavigationController(rootViewController: customerLoginVC)
        nav.modalPresentationStyle = .fullScreen
        //nav.navigationBar.tintColor = AppStaticColors.accentColor
        self.present(nav, animated: true, completion: nil)
    }
    
    func cancel(alertAction: UIAlertAction!) {
        
    }
    
    func guest(alertAction: UIAlertAction!) {
        let viewController = CheckoutDataViewController.instantiate(fromAppStoryboard: .checkout)
        let nav = UINavigationController(rootViewController: viewController)
        //nav.navigationBar.tintColor = AppStaticColors.accentColor
        viewController.isVirtual = self.cartViewModalObject?.cartModel.isVirtual
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
}
