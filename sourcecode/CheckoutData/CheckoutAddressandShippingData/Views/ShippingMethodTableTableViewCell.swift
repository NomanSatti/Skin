//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: ShippingMethodTableTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class ShippingMethodTableTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shippingMethodHeading: UILabel!
    private var shippingMethods = [ShippingMethods]()
    var shippingId = ""
    weak var delegate: SendShippingId?
    override func awakeFromNib() {
        super.awakeFromNib()
        shippingMethodHeading.text = "Shipping Method".localized
        tableView.register(cellType: SelectionMethodTableViewCell.self)
        tableView.separatorStyle = .none
        // Initialization code
        
        
        
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var shippingMethod: [ShippingMethods]! {
        didSet {
            self.shippingMethods = shippingMethod
            var totalCount = 0
            var internalCount = 0
            for value in 0..<shippingMethods.count {
                totalCount += 1
                for _ in 0..<shippingMethods[value].method.count {
                    internalCount += 1
                }
            }
            
            self.tableViewHeight.constant = CGFloat(44 * totalCount)
            self.tableViewHeight.constant += CGFloat(56 * internalCount)
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
            
        }
    }
    
}

extension ShippingMethodTableTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return shippingMethods.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shippingMethods[section].method.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: SelectionMethodTableViewCell = tableView.dequeueReusableCell(with: SelectionMethodTableViewCell.self, for: indexPath) {
            cell.methodName.text = shippingMethods[indexPath.section].method[indexPath.row].label + " - " + shippingMethods[indexPath.section].method[indexPath.row].price
            if shippingId == shippingMethods[indexPath.section].method[indexPath.row].code {
                cell.internalImageView.backgroundColor = AppStaticColors.accentColor
            } else {
                cell.internalImageView.backgroundColor = UIColor.white
            }
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return shippingMethods[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        shippingId = shippingMethods[indexPath.section].method[indexPath.row].code
        delegate?.sendShippingId(shippingId: shippingId)
        self.tableView.reloadData()
    }
    
   
    
}

protocol SendShippingId: NSObjectProtocol {
    func sendShippingId(shippingId: String)
}
