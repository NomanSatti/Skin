//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: ProductPageDataViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit
import Crashlytics
import IQKeyboardManager

class ProductPageDataViewController: UIViewController {
    
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var cartBtn: BadgeBarButtonItem!
    @IBOutlet weak var searchBtn: UIBarButtonItem!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    
    var viewModel: ProductPageViewModal!
    var productId: String!
    var productName: String!
    var itemId = ""
    var parentController = ""
    var spinner = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let img = backBtn.image?.withRenderingMode(.alwaysTemplate)
        backBtn.image = img?.flipImage()
        backBtn.tintColor = AppStaticColors.itemTintColor
        self.navigationItem.title = productName
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.registerCells()
        self.hitRequest()
        // Do any additional setup after loading the view.
    }
    
    func registerCells() {
        productTableView.separatorStyle = .none
        productTableView.register(cellType: ProductTopImagesTableViewCell.self)
        productTableView.register(cellType: ProductNamePriceTableViewCell.self)
        productTableView.register(cellType: ProductReviewCountTableViewCell.self)
        productTableView.register(cellType: ProductActionTableViewCell.self)
        productTableView.register(cellType: ProductShortDescriptionTableViewCell.self)
        productTableView.register(cellType: StockManagementTableViewCell.self)
       
        productTableView.register(cellType: ProductQuantityViewTableViewCell.self)
        productTableView.register(cellType: ProductCartViewTableViewCell.self)
        productTableView?.register(ProductSectionHeading.nib, forHeaderFooterViewReuseIdentifier: ProductSectionHeading.identifier)
        productTableView.register(cellType: ProsuctFeaturesTableViewCell.self)
        productTableView.register(cellType: ProductReviewDataTableViewCell.self)
        productTableView.register(cellType: RelatedProductTableViewCell.self)
        productTableView?.register(ActionButtonFooterView.nib, forHeaderFooterViewReuseIdentifier: ActionButtonFooterView.identifier)
        productTableView.register(cellType: ConfigurableProductDataTableViewCell.self)
        productTableView.register(cellType: GroupProductTableViewCell.self)
        productTableView.register(cellType: BundleDropDownTableViewCell.self)
        productTableView.register(cellType: BundleRadioTableViewCell.self)
        productTableView.register(cellType: BundleCheckboxTableViewCell.self)
        productTableView.register(cellType: LinkDataTableViewCell.self)
        productTableView.register(cellType: CustomOptionsDateAndTimeTableViewCell.self)
        productTableView.register(cellType: CustomTextFieldTableViewCell.self)
        productTableView.register(cellType: CustomOptionImageUploadTableViewCell.self)
        productTableView?.register(ReviewHeaderView.nib, forHeaderFooterViewReuseIdentifier: ReviewHeaderView.identifier)
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func hitRequest() {
        viewModel = ProductPageViewModal(productId: productId)
        viewModel.spinner = spinner
        
        viewModel?.loadData { [weak self] success in
            guard let self = self else { return }
            if success {
                DispatchQueue.main.async {
                    self.navigationItem.title = self.viewModel.model.name
                    self.productTableView.delegate = self.viewModel
                    self.productTableView.dataSource = self.viewModel
                    self.productTableView.reloadData()
                }
            } else {
            }
        }
        viewModel.reloadSections = { [weak self] (section: Int, makeScroll: Bool) in
            //self?.productTableView?.beginUpdates()
            //self?.productTableView?.reloadSections([section], with: .fade)
            self?.productTableView?.reloadSections([section], with: .automatic)
            if makeScroll {
                self?.productTableView.scrollToRow(at: IndexPath(row: 0, section: section), at: .middle, animated: true)
            }
            //self?.productTableView?.endUpdates()
        }
        viewModel.reloadSectionsWithoutAnimation = { [weak self] (section: Int) in
            self?.productTableView?.reloadSections([section], with: .none)
        }
        viewModel.reloadTableView = { [weak self] (_ reloadType: ReloadType) in
            switch reloadType {
            case .updateImage:
                if let cell = self?.productTableView?.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProductTopImagesTableViewCell, let item = self?.viewModel.productItems[0] as? ProductViewModalbannerItem {
                    cell.arType = self?.viewModel.model.arType
                    cell.arUrl = self?.viewModel.model.arUrl
                    cell.offerLabel.text = item.offer
                    cell.images = item.images
                    cell.layoutIfNeeded()
                    cell.collectionView.reloadData()
                    cell.collectionView.contentOffset.x = 0
                }
            case .price:
                if let cell = self?.productTableView?.cellForRow(at: IndexPath(row: 0, section: 1)) as? ProductNamePriceTableViewCell, let item = self?.viewModel.productItems[1] as? ProductViewModalNamePriceItem {
                    cell.optionProductId = self?.viewModel.optionProductId ?? ""
                    cell.item = item.data
                }
            default:
                self?.productTableView?.reloadData()
            }
        }
        viewModel.itemId = itemId
        viewModel.parentController = parentController
        viewModel.cartBtn = cartBtn
        viewModel.delegate = self
        viewModel.moveDelegate = self
        viewModel?.callingHttppApi { [weak self] success in
            guard let self = self else { return }
            if success {
                DispatchQueue.main.async {
                    self.navigationItem.title = self.viewModel.model.name
                    self.productTableView.delegate = self.viewModel
                    self.productTableView.dataSource = self.viewModel
                    self.productTableView.reloadData()
                }
            } else {
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cartBtn.badgeNumber = Int(Defaults.cartBadge) ?? 0
        IQKeyboardManager.shared().previousNextDisplayMode = .alwaysHide
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared().previousNextDisplayMode = .alwaysShow
    }
    
    @IBAction func cartClicked(_ sender: UIBarButtonItem) {
        let viewController = CartDataViewController.instantiate(fromAppStoryboard: .product)
        let nav = UINavigationController(rootViewController: viewController)
        //nav.navigationBar.tintColor = AppStaticColors.accentColor
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func searchClicked(_ sender: UIBarButtonItem) {
        let viewController = SearchDataViewController.instantiate(fromAppStoryboard: .search)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    

    
}

extension ProductPageDataViewController: ShareClicked {
    func shareClicked(productLink: String) {
        let vc = UIActivityViewController(activityItems: [productLink], applicationActivities: nil)
        if UI_USER_INTERFACE_IDIOM() == .phone {
            self.present(vc, animated: true, completion: nil)
        } else {
            UIBarButtonItem.appearance().tintColor = UIColor.black
            let popup = UIPopoverController(contentViewController: vc)
            popup.present(from: CGRect(x: CGFloat(self.view.frame.size.width / 2), y: CGFloat(self.view.frame.size.height / 4), width: CGFloat(0), height: CGFloat(0)), in: self.view, permittedArrowDirections: .any, animated: true)
        }
    }
}

extension ProductPageDataViewController: MoveFromProductController {
    func move(id: String, controller: AllControllers) {
        if controller == .addToCart {
            let viewController = CartDataViewController.instantiate(fromAppStoryboard: .product)
            let nav = UINavigationController(rootViewController: viewController)
            //nav.navigationBar.tintColor = AppStaticColors.accentColor
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        } else if controller == .checkout {
            let viewController = CheckoutDataViewController.instantiate(fromAppStoryboard: .checkout)
            let nav = UINavigationController(rootViewController: viewController)
            //nav.navigationBar.tintColor = AppStaticColors.accentColor
            viewController.isVirtual = id.count > 0 ? true : false
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        } else if controller == .signInController {
            let customerLoginVC = SignInViewController.instantiate(fromAppStoryboard: .customer)
            let nav = UINavigationController(rootViewController: customerLoginVC)
            //nav.navigationBar.tintColor = AppStaticColors.accentColor
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        } else if controller == .none {
            self.navigationController?.popViewController(animated: true)
        }  else {
            let nextController = AllReviewsDataViewController.instantiate(fromAppStoryboard: .product)
            nextController.productId = id
            self.navigationController?.pushViewController(nextController, animated: true)
        }
    }
}
