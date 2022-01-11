//
//  ChangeTableViewCell.swift
//  Odoo iOS
//
//  Created by Bhavuk on 01/11/17.
//  Copyright © 2017 Bhavuk. All rights reserved.
//

import UIKit
import SwiftyJSON
import Reusable

class ChangeTableViewCell: UITableViewCell, FormConformity, NibReusable {
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var Switchh: UISwitch!
    var delegate: changeDelegate?
    var tableView: UITableView?
    var formItem: FormItem?
    @IBOutlet weak var changePasswordLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        Switchh.isOn = false
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func SwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            formItem?.selectedIndex = 1
            delegate?.passdata(index : self.formItem?.id ?? 0, actionData : 1)
        } else {
            formItem?.selectedIndex = 0
            delegate?.passdata(index : self.formItem?.id ?? 0, actionData : 0)
        }
        
    }
    
}
extension ChangeTableViewCell: FormUpdatable {
    func update(with formItem: FormItem) {
        self.formItem = formItem
        self.headingLabel.text = formItem.placeholder
        Switchh.isOn = formItem.selectedIndex == 1 ? true : false
        changePasswordLabel.text = formItem.placeholder
    }
}
