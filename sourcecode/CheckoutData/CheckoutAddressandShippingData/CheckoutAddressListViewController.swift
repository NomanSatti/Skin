//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: CheckoutAddressListViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class CheckoutAddressListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var address = [Address]()
    var addressId = ""
    weak var delegate: CheckoutSelectAddress?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Addresses".localized
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
}

extension CheckoutAddressListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return address.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = address[indexPath.row].value
        if address[indexPath.row].id == addressId {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addressId = address[indexPath.row].id
        delegate?.checkoutSelectAddress(address: addressId)
        self.navigationController?.popViewController(animated: true)
    }
}
