import UIKit

class CategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    var tempCategoryData: NSMutableArray = []
    var tempCategoryId: NSMutableArray = []
    var categoryMenuData: NSMutableArray = []
    var headingTitleData: NSMutableArray = []
    var categoryDict: NSDictionary = [:]
    var categoryName: String!
    var categoryId: String!
    var categoryChildData: NSArray!
    
    var homeViewModel: HomeViewModel? {
        get {
            guard let navigationController = self.tabBarController?.viewControllers?[0] as? UINavigationController else { return nil }
            guard let viewControllerHome = navigationController.viewControllers[0] as? ViewController else { return nil }
            return viewControllerHome.homeViewModel
        }
        set {
            guard let navigationController = self.tabBarController?.viewControllers?[0] as? UINavigationController else { return }
            guard let viewControllerHome = navigationController.viewControllers[0] as? ViewController else { return }
            viewControllerHome.homeViewModel = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Categories".localized
        categoryTableView.register(UINib(nibName: "CategoryListTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryListTableViewCell")
        categoryMenuData = tempCategoryData
        
        //        if let patternImage = UIImage(named: "Pattern") {
        //            //view.backgroundColor = UIColor(patternImage: patternImage)
        //        }
        
        categoryTableView!.backgroundColor = UIColor.clear
        //collectionView!.decelerationRate = UIScrollViewDecelerationRateFast
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.reloadData()
        
        let refreshControl = UIRefreshControl()
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let attributedTitle = NSAttributedString(string: "refreshing".localized, attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            //            categoriesTableView.refreshControl = refreshControl
        } else {
            //            categoriesTableView.backgroundView = refreshControl
        }
        
        self.showOfflineBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        NetworkManager.sharedInstance.dismissLoader()
        NetworkManager.sharedInstance.removePreviousNetworkCall()
    }
    @IBAction func searchClicked(_ sender: Any) {
        let viewController = SearchDataViewController.instantiate(fromAppStoryboard: .search)
        viewController.categories = homeViewModel?.categories ?? []
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let categories = self.homeViewModel?.categories, categories.count != 0 else { return 0 }
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryListTableViewCell", for: indexPath)as? CategoryListTableViewCell {
            guard let categories = self.homeViewModel?.categories, categories.count != 0 else { return UITableViewCell() }
            cell.categoryNameLbl.text = categories[indexPath.row].name ?? ""
            cell.categoryImg.setImage(fromURL: categories[indexPath.row].thumbnail ?? "", placeholder:  UIImage(named: "placeholder"))
            cell.categoryImg.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let categories = self.homeViewModel?.categories, categories.count != 0 else { return }
        
        if categories[indexPath.row].hasChildren {
            let viewController = SubCategoriesViewController.instantiate(fromAppStoryboard: .product)
            viewController.categoryId = categories[indexPath.row].id
            viewController.categoryName = categories[indexPath.row].name
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            let nextController = CategoryProductsViewController.instantiate(fromAppStoryboard: .product)
            nextController.categoryId = categories[indexPath.row].id
            nextController.titleName = categories[indexPath.row].name
            nextController.categoryType = "category"
            //            nextController.categories = self.homeViewModel.categories
            self.navigationController?.pushViewController(nextController, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }
    
}

extension CategoriesViewController: MoveController {
    func moveController(id: String, name: String, dict: DictType, jsonData: JSON, type: String, controller: AllControllers) {
        self.navigationController?.navigationBar.isHidden = false
        
        switch controller {
        case .productcategory:
            print()
            //            let nextController = Productcategory.instantiate(fromAppStoryboard: .main)
            //            nextController.categoryId = id
            //            nextController.categoryName = name
            //            nextController.categoryType = type
            //            self.navigationController?.pushViewController(nextController, animated: true)
            
        default:
            break
        }
    }
}
