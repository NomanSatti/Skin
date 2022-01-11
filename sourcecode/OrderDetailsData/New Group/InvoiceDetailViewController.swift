//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: InvoiceDetailViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class InvoiceDetailViewController: UIViewController {
    var viewModel: InvoiceViewModel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var printBarBtnItem: UIBarButtonItem!
    var invoiceId: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        printBarBtnItem.tintColor = AppStaticColors.itemTintColor
        self.navigationItem.title = "Invoice".localized + " - #" + invoiceId
        tableView.register(cellType: InvoiceProductListTableViewCell.self)
        tableView.register(cellType: CartPriceTableViewCell.self)
        tableView.register(ProductSectionHeading.nib, forHeaderFooterViewReuseIdentifier: ProductSectionHeading.identifier)
        viewModel = InvoiceViewModel(invoiceId: invoiceId)
        tableView.tableFooterView = UIView()
        //        tableView.separatorStyle = .none
        self.callRequest()
        // Do any additional setup after loading the view.
    }
    
    func callRequest() {
        viewModel?.callingHttppApi { [weak self] success in
            guard let self = self else { return }
            if success {
                self.tableView.delegate = self.viewModel
                self.tableView.dataSource = self.viewModel
                self.tableView.reloadData()
                //                self.priceLabel.text = self.cartViewModalObject?.cartModel.grandtotal?.value
            } else {
            }
        }
    }
    
    @IBAction func crossClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func printerClick(_ sender: UIBarButtonItem) {
        let pdffile = self.tableView.exportAsPdfFromTable()
        print(pdffile)
        let printController = UIPrintInteractionController.shared
        
        if let documrntURL =  pdffile{
            if UIPrintInteractionController.canPrint(documrntURL) {
                let printInfo = UIPrintInfo(dictionary: nil)
                printInfo.jobName = "PDF File"
                printInfo.outputType = .photo
                printController.printInfo = printInfo
                printController.showsNumberOfCopies = true
                printController.showsPageRange = true
                printController.printingItem = documrntURL
                printController.present(animated: true, completionHandler: nil)
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
}
