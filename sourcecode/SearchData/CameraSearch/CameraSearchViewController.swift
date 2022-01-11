//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: CameraSearchViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class CameraSearchViewController: UIViewController {
    
    @IBOutlet weak var scanAsProductLabel: UILabel!
    @IBOutlet weak var scanAsTextLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Search by Scanning".localized
        scanAsProductLabel.text = "Scan as Product".localized
        scanAsTextLabel.text = "Scan as Text".localized
        // Do any additional setup after loading the view.
    }
    
    @IBAction func crossClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapScanTextBtn(_ sender: Any) {
        let vc = DetectorViewController.instantiate(fromAppStoryboard: .search)
        vc.detectorType = .text
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapScanProductBtn(_ sender: Any) {
        let vc = DetectorViewController.instantiate(fromAppStoryboard: .search)
        vc.detectorType = .image
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
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

extension CameraSearchViewController: SuggestionDataHandlerDelegate {
    func suggestedData(data: String) {
        let nextController = CategoryProductsViewController.instantiate(fromAppStoryboard: .product)
        nextController.categoryId = ""
        nextController.titleName = data
        nextController.categoryId = data
        nextController.searchText = data
        nextController.categoryType = "search"
        self.navigationController?.pushViewController(nextController, animated: true)
    }
}
