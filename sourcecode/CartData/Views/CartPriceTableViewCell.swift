//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: CartPriceTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class CartPriceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dropIcon: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var priceDetailsLabel: UILabel!
    @IBOutlet weak var orderTotalPrice: UILabel!
    @IBOutlet weak var orderTotalLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: HeaderViewDelegate?
    var totalsData = [TotalsData]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        priceDetailsLabel.text = "Price Detailssss".localized.uppercased()
        orderTotalLabel.text = "Order Total".localized
        tableView.register(cellType: CartFormatTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        topView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
        // Initialization code
    }
    
    @objc private func didTapHeader() {
        
        delegate?.toggleSection(view: self, section: 3)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var item: [TotalsData]! {
        didSet {
            self.totalsData = item
            tableViewHeight.constant = CGFloat(totalsData.count * 44)
            //            if !openView {
            //                tableViewHeight.constant = 0
            //            } else {
            //                tableViewHeight.constant = CGFloat(totalsData.count * 44)
            //            }
            
            tableView.delegate = self
            tableView.dataSource = self
            tableView.reloadData()
        }
    }
    
}

extension CartPriceTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: CartFormatTableViewCell = tableView.dequeueReusableCell(with: CartFormatTableViewCell.self, for: indexPath) {
            cell.item = totalsData[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
}
