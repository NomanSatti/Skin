//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: BundleCheckboxTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class BundleCheckboxTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var radioTableView: UITableView!
    @IBOutlet weak var headingLabel: UILabel!
    var options = [OptionValues]()
    var value = [String]()
    var bundleDict = [String: Any]()
    var bundleQtyDict = [String: Any]()
    var parentID = ""
    var customDict = [String: Any]()
    weak var customDelegate: GettingCustomData?
    weak var delegate: GettingBundleData?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var items: [OptionValues]! {
        didSet {
            self.options = items
            self.tableViewHeight.constant = CGFloat(options.count * 48)
            self.radioTableView.delegate = self
            self.radioTableView.dataSource = self
            self.radioTableView.reloadData()
        }
    }
}

extension BundleCheckboxTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.imageView?.image = UIImage(named: "icon-radio-off")
        if  value.contains(options[indexPath.row].optionValueId) {
            cell.imageView?.image = UIImage(named: "icon-radio-on")
        }
        cell.textLabel?.text = options[indexPath.row].title
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = value.firstIndex(of: options[indexPath.row].optionValueId) {
            value.remove(at: index)
        } else {
            value.append(options[indexPath.row].optionValueId)
        }
        
        self.customDict[self.parentID] = value
        self.customDelegate?.gettingCustomData(data: self.customDict)
        bundleDict[parentID] = value
        delegate?.gettingBundleData(data: bundleDict, qtyDict: bundleQtyDict, selectedItem: 0)
        self.radioTableView.reloadData()
    }
}
