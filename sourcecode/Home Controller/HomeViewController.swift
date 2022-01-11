//

/*
 Mobikul_Magento2V3_App
 @Category Webkul
 @author Webkul
 FileName: ViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html
 */

import UIKit
import RealmSwift
import CoreLocation
import Alamofire
import AlamofireImage
import SnapKit
import SwiftyJSON


class ViewController: UIViewController {
    var homeViewModel: HomeViewModel!
    
    @IBOutlet weak var cartBtn: BadgeBarButtonItem!
    @IBOutlet weak var notificationBtn: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var tableviewHeight: NSLayoutConstraint!
    @IBOutlet weak var homeTableView: UITableView!
    
    
   
    
    
    @IBOutlet weak var socialIconsView: UIView!
    
  
    var socialIcons = [SocialIconModel]()
    
    var refreshControl: UIRefreshControl!
    let defaults = UserDefaults.standard
    var locationManager: CLLocationManager?
    
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           socialCollectionView?.centerContentHorizontalyByInsetIfNeeded(minimumInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
       }
    
    
    var socialCollectionView: UICollectionView?{
        didSet{
            NetworkManager.sharedInstance.showLoader()
            self.getSocialIcons {
                 NetworkManager.sharedInstance.dismissLoader()
            }
        }
    }
    

    
    
       
 
    
    @objc private func adsButtonTapped(){
        
        
        self.showActionSheetForImageInput { [unowned self](imageSource) in
                           
                           let imagePicker = UIImagePickerController()
                           imagePicker.delegate = self
                           
                           switch imageSource {
                           case .camera:
                               imagePicker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera:.photoLibrary;
                               
                           case .imageLibrary:
                               imagePicker.sourceType = .photoLibrary;
                           }
                           
                           self.present(imagePicker, animated: true, completion: nil)
                       }
    }
    

    
    
    var homeJsonData: JSON = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.homeTableView.isHidden = true
       // self.socialIconsView.isHidden = true
        self.setView()
      
        
 
        homeViewModel = HomeViewModel()
       // refreshingView.layer.cornerRadius = 5
      //  refreshingView.layer.masksToBounds = true
     //   refreshLbl.text = "Refreshing...".localized
        homeTableView.register(cellType: OfferBannerCellTableViewCell.self)
        homeTableView.register(cellType: TopCategoryTableViewCell.self)
        homeTableView.register(cellType: BannerTableViewCell.self)
        homeTableView.register(AdvertisementTableViewCell.self, forCellReuseIdentifier: "AdvertisementTableViewCell")
        homeTableView.register(cellType: ImageCarouselTableViewCell.self)
        homeTableView.register(cellType: ProductTableViewCell.self)
        homeTableView.register(cellType: ProductTableViewCellLayout2.self)
        homeTableView.register(cellType: ProductTableViewCellLayout3.self)
        homeTableView.register(cellType: ProductTableViewCellLayout4.self)
        homeTableView.register(cellType: RecentHorizontalTableViewCell.self)
        homeTableView.register(cellType: SliderTableViewCell.self)
        self.setupTableFooterView()
        homeViewModel.homeTableView = homeTableView
        self.homeTableView?.dataSource = homeViewModel
        self.homeTableView?.delegate = homeViewModel
        homeViewModel.moveDelegate = self
        self.homeViewModel.homeViewController = self
        if Defaults.searchEnable == nil {
            Defaults.searchEnable = "1"
        }
        
          
        homeTableView.rowHeight = UITableView.automaticDimension
        self.homeTableView.estimatedRowHeight = 100
        self.homeTableView.separatorColor = UIColor.clear
        
        self.navigationItem.title = applicationName
        
        //add refresh control to tableview
        refreshControl = UIRefreshControl()
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let attributedTitle = NSAttributedString(string: "Refreshing...".localized, attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            homeTableView.refreshControl = refreshControl
        } else {
            homeTableView.backgroundView = refreshControl
        }
        
        self.tabBarController?.tabBar.items?[0].title = "Home".localized
        self.tabBarController?.tabBar.items?[1].title = "Shop".localized
        self.tabBarController?.tabBar.items?[2].title = "Wallpapers".localized
        self.tabBarController?.tabBar.items?[3].title = "Store Locator".localized//"Maintenance".localized
        self.tabBarController?.tabBar.items?[4].title = "More".localized
       // self.tabBarController?.tabBar.items?[3].title = "Account".localized
     //   self.tabBarController?.tabBar.items?[4].title = "More".localized
        self.registerToReceiveNotification()
        self.homeViewModel.getData(jsonData: homeJsonData, recentViewData: self.getProductDataFromDB()) {(data: Bool) in
            if data {
                self.processDataForHomeController()
            }
        }
        DispatchQueue.main.async {
            self.locationManager = CLLocationManager()
            self.fetchLocation()
        }
        self.setupRefreshHome()
        if LaunchHome.needAppRefresh {
          //  self.refreshingView.isHidden = false
            //self.callingHttppApi(showLoader: false)
            self.refreshHomePageData()
        }
        
        if let tabbar = self.parent?.parent {
            print(tabbar)
            tabbar.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
        self.navigationController?.navigationBar.draw(CGRect(x: 0, y: 0, width: 30, height: 30))
        self.navigationItem.rightBarButtonItem?.customView?.frame.size.width = 30
        
        print("viewDidLoad - \(type(of: self))")
    }
    
    func setView() {
        if Defaults.language == "ar" {
            L102Language.setAppleLAnguageTo(lang: "ar")
            if #available(iOS 9.0, *) {
                UINavigationBar.appearance().semanticContentAttribute = .forceRightToLeft
                UITabBar.appearance().semanticContentAttribute = .forceRightToLeft
                
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
                
            } else {
                // Fallback on earlier versions
            }
            
        } else {
            
            L102Language.setAppleLAnguageTo(lang: "en")
            if #available(iOS 9.0, *) {
                UINavigationBar.appearance().semanticContentAttribute = .forceLeftToRight
                UITabBar.appearance().semanticContentAttribute =  .forceLeftToRight
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
                
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        callingHttppApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cartBtn.badgeNumber = Int(Defaults.cartBadge) ?? 0
        self.tabBarController?.tabBar.isHidden = false
        socialCollectionView?.centerContentHorizontalyByInsetIfNeeded(minimumInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        socialCollectionView?.centerContentHorizontalyByInsetIfNeeded(minimumInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    func callingHttppApi(showLoader: Bool = true) {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = false
            var requstParams = [String: Any]()
            NetworkManager.sharedInstance.showLoader()
            if self.refreshControl.isRefreshing {
                NetworkManager.sharedInstance.dismissLoader()
            } else if !showLoader {
                NetworkManager.sharedInstance.dismissLoader()
                self.view.isUserInteractionEnabled = true
            }
            requstParams["storeId"] = Defaults.storeId
            requstParams["customerToken"] = Defaults.customerToken
            requstParams["quoteId"] = Defaults.quoteId
            requstParams["currency"] = Defaults.currency
            
            requstParams["websiteId"] = UrlParams.defaultWebsiteId
            requstParams["width"] = UrlParams.width
            requstParams["eTag"] = DBManager.sharedInstance.geteTagFromDataBase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "homedata"))
            
            NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .get, apiname: .loadHome, currentView: self) {success, responseObject in
                //self.refreshingView.isHidden = true
                if success == 1 {
                    NetworkManager.sharedInstance.dismissLoader()
                    self.view.isUserInteractionEnabled = true
                    let jsonResponse = JSON(responseObject as? NSDictionary ?? [:])
                    if jsonResponse["success"].boolValue == true {
                        if jsonResponse["storeId"] != JSON.null {
                            let storeId: String = String(format: "%@", jsonResponse["storeId"].stringValue)
                            if storeId != "0"{
                                self.defaults .set(storeId, forKey: "storeId")
                            }
                        }
                        
                        if jsonResponse["defaultCurrency"] != JSON.null {
                            if self.defaults.object(forKey: "currency") == nil {
                                self.defaults .set(jsonResponse["defaultCurrency"].stringValue, forKey: "currency")
                            }
                        }
                        
                        let dict =  JSON(responseObject as? NSDictionary ?? [:])
                        
                        // store the data to data base
                        if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]) {
                            DBManager.sharedInstance.storeDataToDataBase(data: data, eTag: dict["eTag"].stringValue, hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "homedata"))
                        }
                        //                        if let products = self.getProductDataFromDB() {
                        self.homeViewModel.getData(jsonData: dict, recentViewData: self.getProductDataFromDB()) {(data: Bool) in
                            if data {
                                //save etag
                                Defaults.eTag = dict["eTag"].stringValue
                                
                                self.processDataForHomeController()
                            }
                        }
                        //                        }
                        
                    } else {
                        self.showErrorSnackBar(msg: "somethingWentWrong".localized)
                    }
                } else if success == 2 {   // Retry in case of error
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                } else if success == 3 {   // No Changes
                    let data =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "homedata"))
                    print(data)
                    if let products = self.getProductDataFromDB() {
                        self.homeViewModel.getDataFromDB(data: data, recentViewData: products, completion: { (data: Bool) in
                            if data {
                                self.processDataForHomeController()
                            }
                        })
                    }
                }
            }
        }
    }
    
    func getProductDataFromDB() -> [Productcollection]? {
        if  let results: Results<Productcollection> = DBManager.sharedInstance.database?.objects(Productcollection.self) {
            return ((Array(results)).sorted(by: { $0.dateTime.compare($1.dateTime) == .orderedDescending }))
        } else {
            return nil
        }
    }
    
    func setupTableFooterView() {
        
        guard let historyToolBarView = Bundle.main.loadNibNamed("BottomMoveToTopTableView", owner: nil, options: nil)![0] as? BottomMoveToTopTableView else { return }
        historyToolBarView.tableView = self.homeTableView
        historyToolBarView.translatesAutoresizingMaskIntoConstraints = false
        historyToolBarView.socialCollectionView.register(SocialCollectionViewCell.self, forCellWithReuseIdentifier: "SocialIconsCell")
        historyToolBarView.socialCollectionView.dataSource = self
        historyToolBarView.socialCollectionView.delegate = self
        self.socialCollectionView = historyToolBarView.socialCollectionView
        
        
        historyToolBarView.addConstraints(
            [NSLayoutConstraint.init(item: historyToolBarView,
                                     attribute: .height,
                                     relatedBy: .equal,
                                     toItem: nil,
                                     attribute: .notAnAttribute,
                                     multiplier: 1.0,
                                     constant: 103),
             NSLayoutConstraint.init(item: historyToolBarView,
                                     attribute: .width,
                                     relatedBy: .equal,
                                     toItem: nil,
                                     attribute: .notAnAttribute,
                                     multiplier: 1.0,
                                     constant: UIScreen.main.bounds.size.width)])
        
        // Create a container of your footer view called footerView and set it as a tableFooterView
        let footerView = UIView(frame: CGRect.init(x: 0, y: 0, width: self.homeTableView.frame.width, height: 130))
        footerView.backgroundColor = UIColor.white
       
        homeTableView.tableFooterView = footerView
        
        // Add your footer view to the container
        footerView.addSubview(historyToolBarView)
    }
    
    func processDataForHomeController() {
        self.refreshControl.endRefreshing()
        
        self.homeViewModel.homeTableviewheight = self.tableviewHeight
       // self.homeTableView.reloadDataWithAutoSizingCellWorkAround()
        
        self.tabBarController?.tabBar.isHidden = false
        self.view.isUserInteractionEnabled = true
        self.homeTableView.isHidden = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("pushNotificationforCategoryOnTap"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("pushNotificationforProductOnTap"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("pushNotificationforCustomCollectionOnTap"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("pushNotificationforOtherOnTap"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("pushNotificationforOrderOnTap"), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("refreshHome"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("updateRecentlyViewed"), object: nil)
    }
}

extension ViewController: MoveController {
    func moveController(id: String, name: String, dict: DictType, jsonData: JSON, type: String, controller: AllControllers) {
        self.navigationController?.navigationBar.isHidden = false
        switch controller {
        case .productcategory:
            let nextController = CategoryProductsViewController.instantiate(fromAppStoryboard: .product)
            nextController.categoryId = id
            nextController.titleName = name
            nextController.categoryType = type
            //            nextController.categories = self.homeViewModel.categories
            self.navigationController?.pushViewController(nextController, animated: true)
        case .signInController:
            let customerLoginVC = SignInViewController.instantiate(fromAppStoryboard: .customer)
            let nav = UINavigationController(rootViewController: customerLoginVC)
            //nav.navigationBar.tintColor = AppStaticColors.accentColor
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        default:
            break
        }
    }
}

// For barbutton actions

extension ViewController {
    @IBAction func searchClicked(_ sender: UIBarButtonItem) {
        self.tabBarController?.tabBar.isHidden = true
        let viewController = SearchDataViewController.instantiate(fromAppStoryboard: .search)
        //viewController.modalPresentationStyle = .overCurrentContext
        viewController.categories = self.homeViewModel.categories
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func notificationClicked(_ sender: UIBarButtonItem) {
        self.tabBarController?.tabBar.isHidden = true
        let viewController = NotificationDataViewController.instantiate(fromAppStoryboard: .main)
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    @IBAction func cartClicked(_ sender: UIBarButtonItem) {
        let viewController = CartDataViewController.instantiate(fromAppStoryboard: .product)
        let nav = UINavigationController(rootViewController: viewController)
        //nav.navigationBar.tintColor = AppStaticColors.accentColor
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
    }
    
    
}
extension ViewController{
    func registerToReceiveNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushNotificationReceivedCategoryTap), name: NSNotification.Name(rawValue: "pushNotificationforCategoryOnTap"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushNotificationReceivedProductTap), name: NSNotification.Name(rawValue: "pushNotificationforProductOnTap"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushNotificationReceivedCustomCollectionTap), name: NSNotification.Name(rawValue: "pushNotificationforCustomCollectionOnTap"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushNotificationReceivedOtherTap), name: NSNotification.Name(rawValue: "pushNotificationforOtherOnTap"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushNotificationReceivedOrderTap), name: NSNotification.Name(rawValue: "pushNotificationforOrderOnTap"), object: nil)
    }
    
    @objc func pushNotificationReceivedCategoryTap(_ note: Notification) {
        let root  = note.userInfo
        let nextController = CategoryProductsViewController.instantiate(fromAppStoryboard: .product)
        nextController.categoryId = root?["categoryId"] as? String ?? ""
        nextController.titleName = root?["categoryName"] as? String ?? ""
        nextController.categoryType = ""
        //            nextController.categories = self.homeViewModel.categories
        self.navigationController?.pushViewController(nextController, animated: true)
        
    }
    
    @objc func pushNotificationReceivedProductTap(_ note: Notification) {
        let root = note.userInfo
        
        let nextController = ProductPageDataViewController.instantiate(fromAppStoryboard: .product)
        nextController.productId = root?["productId"] as? String ?? ""
        nextController.productName = root?["productName"] as? String ?? ""
        self.navigationController?.pushViewController(nextController, animated: true)
    }
    
    @objc func pushNotificationReceivedCustomCollectionTap(_ note: Notification) {
        let root = note.userInfo;
        
        let nextController = CategoryProductsViewController.instantiate(fromAppStoryboard: .product)
        nextController.categoryId = root?["id"] as? String ?? ""
        nextController.titleName = root?["title"] as? String ?? ""
        nextController.categoryType = "custom"
        //            nextController.categories = self.homeViewModel.categories
        self.navigationController?.pushViewController(nextController, animated: true)
        
    }
    
    @objc func pushNotificationReceivedOtherTap(_ note: Notification) {
        let root = note.userInfo;
        let title = root?["title"] as? String ?? ""
        let content = root?["message"] as? String ?? ""
        let AC = UIAlertController(title: title, message: content, preferredStyle: .alert)
        
        let okBtn = UIAlertAction(title: "ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.callingHttppApi();
        })
        AC.addAction(okBtn)
        self.parent!.present(AC, animated: true, completion: { })
    }
    
    @objc func pushNotificationReceivedOrderTap(_ note: Notification) {
        let root = note.userInfo;
        let viewController = OrderDetailsDataViewController.instantiate(fromAppStoryboard: .customer)
        viewController.orderId = root?["incrementId"] as? String ?? ""
        let nav = UINavigationController(rootViewController: viewController)
        //nav.navigationBar.tintColor = AppStaticColors.accentColor
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}


extension ViewController: CLLocationManagerDelegate {
    func fetchLocation() {
        DispatchQueue.main.async {

//            self.locationManager = CLLocationManager()
//            self.locationManager?.delegate = self
//            self.locationManager?.distanceFilter = 1;
//            self.locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
//            self.buildings = [[NSMutableArray alloc] init];

            self.locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation//kCLLocationAccuracyBest
            self.locationManager?.delegate = self
            self.locationManager?.distanceFilter = 1
            self.locationManager?.requestWhenInUseAuthorization()
            self.locationManager?.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
        let latestLocation = locations.last
        let g = CLGeocoder()
        var p:CLPlacemark?
        g.reverseGeocodeLocation(latestLocation!, completionHandler: {
            (placemarks, error) in
            let pm = placemarks
            if ((pm != nil) && (pm?.count)! > 0){
                // p = CLPlacemark()
                p = CLPlacemark(placemark: (pm?[0])!)

                var addressDict = [String: Any]()
                var streetArray = [String]()
                if let names = Defaults.customerName?.components(separatedBy: " "), names.count > 1 {
                    addressDict["firstname"] = names[0]
                    addressDict["lastname"] = names[names.count - 1]
                } else {
                    addressDict["firstname"] = Defaults.customerName
                    addressDict["lastname"] = ""
                }
                // addressDict["firstname"] = Defaults.customerName
                // addressDict["lastname"] = Defaults.customerName
                addressDict["postcode"] = p?.postalCode
                addressDict["country_id"] = p?.isoCountryCode
                addressDict["city"] = p?.subAdministrativeArea

                if let subLocality = p?.subLocality {
                    streetArray.append(subLocality)
                }
                if let locality = p?.locality {
                    streetArray.append(locality)
                }
                addressDict["street"] = streetArray
                let jsonData = JSON(addressDict)
                NetworkManager.addressData = StoredAddressData(json: jsonData)
            }
        })
        }
    }
}
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        
        if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            
            
            dismiss(animated: false) {
                DispatchQueue.main.async {
                    let vc = CustomWallpaperViewController()
                    vc.selectedImage = pickedImage
                    self.navigationController?.pushViewController(vc, animated: false)
                    
                    
                }
            }
            
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 32, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.socialIcons[indexPath.row]
        if let url = URL(string: item.url) {
          UIApplication.shared.open(url)
      }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.socialIcons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SocialIconsCell", for: indexPath) as! SocialCollectionViewCell
        let social = self.socialIcons[indexPath.row]
        let imageUrl = social.icon
        
     
        let editedUrl = imageUrl.replacingOccurrences(of: "//", with: "/" )
        let editedUrlfinal = imageUrl.replacingOccurrences(of: "media/", with: "media/social" )
            
       
        if let url = URL(string: editedUrlfinal) {
                   cell.iconImageView.af_setImage(withURL: url)
        }
 
        return cell
    }
    

    
    
    private func getSocialIcons(completionHandler: @escaping () -> ()){
        let url: String = API_ROOT_DOMAIN + "rest/V1/get-socials"
              var request = URLRequest(url:  NSURL(string: url)! as URL)

              // Your request method type Get or post etc according to your requirement
              request.httpMethod = "GET"

              request.setValue("Bearer \(ADMIN_TOKEN)", forHTTPHeaderField: "Authorization")
              request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        
              Alamofire.request(request).responseJSON { (responseObject) -> Void in
                print(responseObject)
                if let data =  responseObject.result.value {
                   let json = JSON(data)
                    print(json)
                    if let first = json.array?.first{
                        let response = first["response"]
                        let data = response["data"]
                        let socials = data["socials"]
                        
                        if let socialIcons = socials.array {
                            
                            for social in socialIcons {
                                print(social)
                                if let new = try? JSONDecoder().decode(SocialIconModel.self, from: social.rawData()){
                                    self.socialIcons.append(new)
                                }
                               
                            }
                            self.socialCollectionView?.reloadData()
                            completionHandler()
                        }
                        
                    }
                    
                    
                }
                
            }
            
    }
    
}



extension ViewController {
    
    func setupRefreshHome() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshHomeData), name: NSNotification.Name(rawValue: "refreshHome"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshHomeApiData), name: NSNotification.Name(rawValue: "refreshHomeApiData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateRecentlyViewed), name: NSNotification.Name(rawValue: "updateRecentlyViewed"), object: nil)
    }
    
    @objc func updateRecentlyViewed() {
        self.homeViewModel.updateRecentlyViewed(recentViewData: self.getProductDataFromDB()) {(section: Int?) in
            self.homeViewModel.homeTableviewheight = self.tableviewHeight
            self.homeTableView.reloadDataWithAutoSizingCellWorkAround()
//            if let section = section {
//                self.homeTableView.reloadSections(IndexSet(arrayLiteral: section), with: .none)
//            } else {
//                self.homeTableView.reloadData()
//            }
        }
    }
    
    @objc func refreshHomeApiData() {
     //   self.refreshingView.isHidden = false
        self.refreshHomePageData()
    }
    
    @objc func refreshHomeData() {
        (self.tabBarController?.viewControllers?[0] as? UINavigationController)?.popToRootViewController(animated: true)
        (self.tabBarController?.viewControllers?[1] as? UINavigationController)?.popToRootViewController(animated: true)
        //(self.tabBarController?.viewControllers?[2] as? UINavigationController)?.popToRootViewController(animated: true)
        //(self.tabBarController?.viewControllers?[3] as? UINavigationController)?.popToRootViewController(animated: true)
        (self.tabBarController?.viewControllers?[4] as? UINavigationController)?.popToRootViewController(animated: true)
      //  self.refreshingView.isHidden = false
        self.refreshHomePageData()
    }
    
    func refreshHomePageData() {
        DispatchQueue.main.async {
            var requstParams = [String: Any]()
            requstParams["storeId"] = Defaults.storeId
            requstParams["customerToken"] = Defaults.customerToken
            requstParams["quoteId"] = Defaults.quoteId
            requstParams["currency"] = Defaults.currency
            requstParams["websiteId"] = UrlParams.defaultWebsiteId
            requstParams["width"] = UrlParams.width
            requstParams["eTag"] = DBManager.sharedInstance.geteTagFromDataBase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "homedata"))
            NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .get, apiname: .loadHome, currentView: self) {success, responseObject in
               // self.refreshingView.isHidden = true
                if success == 1 {
                    self.view.isUserInteractionEnabled = true
                    let jsonResponse = JSON(responseObject as? NSDictionary ?? [:])
                    if jsonResponse["success"].boolValue == true {
                        if jsonResponse["storeId"] != JSON.null {
                            let storeId: String = String(format: "%@", jsonResponse["storeId"].stringValue)
                            if storeId != "0"{
                                self.defaults .set(storeId, forKey: "storeId")
                            }
                        }
                        if jsonResponse["defaultCurrency"] != JSON.null {
                            if self.defaults.object(forKey: "currency") == nil {
                                self.defaults .set(jsonResponse["defaultCurrency"].stringValue, forKey: "currency")
                            }
                        }
                        let dict =  JSON(responseObject as? NSDictionary ?? [:])
                        if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]) {
                            DBManager.sharedInstance.storeDataToDataBase(data: data, eTag: dict["eTag"].stringValue, hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "homedata"))
                        }
                        self.homeViewModel.getData(jsonData: dict, recentViewData: self.getProductDataFromDB()) {(data: Bool) in
                            if data {
                                Defaults.eTag = dict["eTag"].stringValue
                                //self.processDataForHomeController()
                                self.refreshControl.endRefreshing()
                                self.homeViewModel.homeTableviewheight = self.tableviewHeight
                                self.homeTableView.reloadDataWithAutoSizingCellWorkAround()                                
                            }
                        }
                    } else {
                        self.showErrorSnackBar(msg: "somethingWentWrong".localized)
                    }
                } else if success == 2 {   // Retry in case of error
                    self.refreshHomePageData()
                } else if success == 3 {   // No Changes
                    let data =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "homedata"))
                    print(data)
                    if let products = self.getProductDataFromDB() {
                        self.homeViewModel.getDataFromDB(data: data, recentViewData: products, completion: { (data: Bool) in
                            if data {
                                self.processDataForHomeController()
                            }
                        })
                    }
                }
            }
        }
    }
}


struct SocialIconModel: Codable {
    let id: String
    let icon: String
    let name: String
    let url: String
}

public extension UICollectionView {
    
    func centerContentHorizontalyByInsetIfNeeded(minimumInset: UIEdgeInsets) {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout,
            layout.scrollDirection == .horizontal else {
                assertionFailure("\(#function): layout.scrollDirection != .horizontal")
                return
        }

        if layout.collectionViewContentSize.width > frame.size.width {
            contentInset = minimumInset
        } else {
            contentInset = UIEdgeInsets(top: minimumInset.top,
                                        left: (frame.size.width - layout.collectionViewContentSize.width) / 2,
                                        bottom: minimumInset.bottom,
                                        right: 0)
        }
    }
}
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
            return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
        }

        // Helper function inserted by Swift 4.2 migrator.
        fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
            return input.rawValue
        }
