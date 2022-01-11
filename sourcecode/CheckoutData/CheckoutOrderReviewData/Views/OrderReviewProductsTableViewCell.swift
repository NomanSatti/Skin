//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: OrderReviewProductsTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class OrderReviewProductsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var itemsLabel: UILabel!
    
    var products = [OrderReviewProducts]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.register(cellType: OrderItemsTableViewCell.self)
        tableView.isScrollEnabled = false
        //        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var item: [OrderReviewProducts]! {
        didSet {
            self.products = item
            if item.count == 1 {
                self.itemsLabel.text = String(item.count) + " " + "Item"
            } else {
                self.itemsLabel.text = String(item.count) + " " + "Item(s)"
            }
            self.tableViewHeight.constant = CGFloat(184 * item.count)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.reloadData()
            
        }
    }
    
}

extension OrderReviewProductsTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: OrderItemsTableViewCell = tableView.dequeueReusableCell(with: OrderItemsTableViewCell.self, for: indexPath) {
            cell.item = products[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
}
