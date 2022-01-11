import UIKit

class AdvanceSearchDataViewController: UIViewController {
    
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var advanceSearchModel: AdvanceSearchViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationItem.title = "Advance Search".localized
        self.prepareSubViews()
        advanceSearchModel = AdvanceSearchViewModel()
        advanceSearchModel?.tableView = tableView
        tableView.delegate = advanceSearchModel
        tableView.dataSource = advanceSearchModel
        searchBtn.setTitle("Search".localized, for: .normal)
        advanceSearchModel?.callingHttppApi()
        //        self.callingHttppApi()
        // Do any additional setup after loading the view.
    }
    
    private func prepareSubViews() {
        //Prepare tableView
        FormItemCellType.registerCells(for: self.tableView)
        self.tableView.allowsSelection = false
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
    
    @IBAction func searchClicked(_ sender: Any) {
        advanceSearchModel?.advanceSearchClicked { getData in
            let nextController = CategoryProductsViewController.instantiate(fromAppStoryboard: .product)
            nextController.categoryId = getData
            nextController.titleName = "Products".localized
            nextController.categoryType = "advSearch"
            self.navigationController?.pushViewController(nextController, animated: true)
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
    
}
