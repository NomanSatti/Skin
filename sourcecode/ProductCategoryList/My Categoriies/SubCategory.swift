import UIKit

class SubCategory: UIViewController, UITableViewDelegate, UITableViewDataSource {
    public  var subCategoryData: NSDictionary = [:]
    public var categoryName = " "
    var subCategoryMenuData: NSMutableArray = []
    var categoryId: String = " "
    
    @IBOutlet weak var subCategoryTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.isNavigationBarHidden = false
        self.title = categoryName
        
        self.subCategoryMenuData.add("viewall".localized.uppercased()+" "+(subCategoryData["name"] as? String ?? "").uppercased())
        
        let childArray: NSArray? = subCategoryData .object(forKey: "children") as? NSArray
        if let itemsArray = childArray {
            for (item) in itemsArray {
                if let childStoreData: NSDictionary = item as? NSDictionary {
                    self.subCategoryMenuData.add(childStoreData["name"] as? String ?? "empty")
                }
            }
        }
        self.showOfflineBar()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return subCategoryMenuData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = subCategoryMenuData [indexPath.row] as? String
        let imageFilter = UIImageView(frame: CGRect(x: AppDimensions.screenWidth - 60, y: 10, width: 30, height: 30))
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.textColor = UIColor.black
        cell.addSubview(imageFilter)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let childArray: NSArray? = subCategoryData .object(forKey: "children") as? NSArray
        if indexPath.row == 0 {
            categoryName =  subCategoryData["name"] as? String ?? ""
            categoryId =   subCategoryData["category_id"] as? String ?? ""
            self.performSegue(withIdentifier: "subCategoryToProductCategory", sender: self)
        } else {
            if let childDict: NSDictionary = childArray? .object(at: indexPath.row - 1) as? NSDictionary {
                if let childrenArray = childDict.object(forKey: "children") as? NSArray, childrenArray.count>0 {
                    let sb = UIStoryboard(name: "Main", bundle: nil)
                    let initViewController: SubCategory? = (sb.instantiateViewController(withIdentifier: "subCategory") as? SubCategory)
                    initViewController?.subCategoryData = childDict
                    initViewController?.categoryName = childDict.object(forKey: "name") as? String ?? ""
                    initViewController?.modalTransitionStyle = .flipHorizontal
                    self.navigationController?.pushViewController(initViewController!, animated: true)
                } else {
                    categoryName = childDict .object(forKey: "name") as? String ?? ""
                    categoryId = childDict .object(forKey: "category_id") as? String ?? ""
                    self.performSegue(withIdentifier: "subCategoryToProductCategory", sender: self)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifier = segue.identifier else { return }
        if segueIdentifier == "subCategoryToProductCategory"{
            //            let viewController:Productcategory = segue.destination as UIViewController as? Productcategory
            //            viewController.categoryType = ""
            //            viewController.categoryName = self.categoryName
            //            viewController.categoryId = self.categoryId
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        animateTable()
    }
    
    func animateTable() {
        self.subCategoryTable.reloadData()
        
        let cells = subCategoryTable.visibleCells
        let tableHeight: CGFloat = subCategoryTable.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: nil)
            
            index += 1
        }
    }
}
