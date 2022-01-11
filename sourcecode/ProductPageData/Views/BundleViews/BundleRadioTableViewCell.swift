//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: BundleRadioTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class BundleRadioTableViewCell: UITableViewCell {
    
    @IBOutlet weak var qtyViewHeight: NSLayoutConstraint!
    @IBOutlet weak var qtyView: UIView!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var radioTableView: UITableView!
    @IBOutlet weak var headingLabel: UILabel!
    var options = [OptionValues]()
    var bundleQtyDict = [String: Any]()
    var value = ""
    var qtyEnable = true
    var bundleDict = [String: Any]()
    var parentID = ""
    weak var delegate: GettingBundleData?
    weak var imagedelegate: GettingImageOptions?
    var valuedelegate: GetradioData?
    var customDict = [String: Any]()
    
    weak var customDelegate: GettingCustomData?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var items: [OptionValues]! {
        didSet {
            self.options = items
            self.tableViewHeight.constant = CGFloat(options.count * 44)
            self.radioTableView.delegate = self
            self.radioTableView.dataSource = self
            self.radioTableView.reloadData()
        }
    }
    
    @IBAction func plusClcked(_ sender: Any) {
        if qtyEnable {
            var val = Int(self.qtyLabel.text ?? "1") ?? 1
            val += 1
            self.qtyLabel.text = String(val)
        }
        bundleQtyDict[value] = self.qtyLabel.text
        delegate?.gettingBundleData(data: bundleDict, qtyDict: bundleQtyDict, selectedItem: 0)
    }
    @IBAction func minusClicked(_ sender: Any) {
        if qtyEnable {
            var val = Int(self.qtyLabel.text ?? "1") ?? 1
            if val > 1 {
                val -=  1
                self.qtyLabel.text = String(val)
            }
        }
        bundleQtyDict[value] = self.qtyLabel.text
        delegate?.gettingBundleData(data: bundleDict, qtyDict: bundleQtyDict, selectedItem: 0)
    }
    
}

extension BundleRadioTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.imageView?.image = UIImage(named: "icon-radio-off")
        if  value == options[indexPath.row].optionValueId {
            cell.imageView?.image = UIImage(named: "icon-radio-on")
            self.qtyLabel.text = options[indexPath.row].defaultQty
            if options[indexPath.row].isQtyUserDefined == "1" {
                self.qtyEnable = true
            } else {
                self.qtyEnable = false
            }
            if let qtyValue =  bundleQtyDict[value] as? String {
                self.qtyLabel.text = qtyValue
            }
        } else {
            cell.imageView?.image = UIImage(named: "icon-radio-off")
        }
        cell.textLabel?.text = options[indexPath.row].title
        cell.selectionStyle = .none
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        value = options[indexPath.row].optionValueId
        self.qtyLabel.text = options[indexPath.row].defaultQty
        if options[indexPath.row].isQtyUserDefined == "1" {
            //            minusBtn.isUserInteractionEnabled = false
            //            plusBtn.isEnabled = false
            //            minusBtn.isEnabled = false
            //            plusBtn.isUserInteractionEnabled = false
            self.qtyEnable = true
        } else {
            self.qtyEnable = false
        }
        self.valuedelegate?.getradiovalue(value: true, valueNumber: value)

        self.customDict[self.parentID] = value
        self.customDelegate?.gettingCustomData(data: self.customDict)
        
        bundleDict[parentID] = value
        bundleQtyDict[value] = self.qtyLabel.text
        
        print(value)
        
        /*if value == "42"{
              imagedelegate?.gettingBundleData(visible: true)
        }else if value == "43"{
              imagedelegate?.gettingBundleData(visible: false)
        }*/
        
        delegate?.gettingBundleData(data: bundleDict, qtyDict: bundleQtyDict, selectedItem: 0)
        

        self.radioTableView.reloadData()
    }
}

protocol GetradioData{
    func getradiovalue(value: Bool, valueNumber: String)
}
