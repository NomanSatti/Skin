//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: WishlistOptionsViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */


import UIKit

class WishlistOptionsViewController: UIViewController {
    
    
    
    var optionsData = [CartOptions]()
    @IBOutlet weak var sortListTableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CGFloat((optionsData.count + 1) * 60) < AppDimensions.screenHeight {
            self.sortListTableView.isScrollEnabled = false
            self.tableHeight.constant = CGFloat((optionsData.count + 1) * 60)
        } else {
            self.sortListTableView.isScrollEnabled = true
            self.tableHeight.constant = AppDimensions.screenHeight
        }
        self.sortListTableView.register(cellType: CartFormatTableViewCell.self)
        self.sortListTableView.delegate = self
        self.sortListTableView.dataSource = self
        self.sortListTableView.reloadData()
        
        // Do any additional setup after loading the view.
    }
    //
    
    @IBAction func tapDismissBtn(_ sender: Any) {
        //NetworkManager.sharedInstance.dissmissView(Duration: 1.0, direction: .bottom, animateView: self.sortListTableView, dissmissView: self.view)
        self.dismiss(animated: true, completion: nil)
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

extension WishlistOptionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let lbl = UILabel(frame: CGRect(x: 15, y: 0, width: AppDimensions.screenWidth - 15, height: 60))
        lbl.text = "More Information".localized
        lbl.font = UIFont.boldSystemFont(ofSize: 17.0)
        view.addSubview(lbl)
        view.backgroundColor = .white
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.optionsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: CartFormatTableViewCell = tableView.dequeueReusableCell(with: CartFormatTableViewCell.self, for: indexPath) {
            cell.options = optionsData[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
}
