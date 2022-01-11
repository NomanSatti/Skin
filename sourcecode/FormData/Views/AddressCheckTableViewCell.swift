//
//  AddressCheckTableViewCell.swift
//  MobikulOpencart
//
//  Created by bhavuk.chawla on 20/11/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import UIKit
import Reusable

@objcMembers
class AddressCheckTableViewCell: UITableViewCell, FormConformity, NibReusable {
    
    @IBOutlet weak var addressSwitch: UISwitch!
    //    @IBOutlet weak var imagev: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    var formItem: FormItem?
    override func awakeFromNib() {
        super.awakeFromNib()
        //  imagev.applyBorder(colours: UIColor().HexToColor(hexString: LIGHTGREY))
        addressSwitch.setOn(false, animated: true)
        // Initialization code
    }
    
    @IBAction func swichChanged(_ sender: UISwitch) {
        if let form = formItem {
            if form.value as? String == "1" {
                form.value = "0"
                addressSwitch.setOn(false, animated: true)
            } else {
                form.value = "1"
                addressSwitch.setOn(true, animated: true)
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension AddressCheckTableViewCell: FormUpdatable {
    func update(with formItem: FormItem) {
        self.formItem = formItem
        self.label.text = formItem.placeholder
        if formItem.value as? String == "1" {
            addressSwitch.setOn(true, animated: true)
        } else {
            addressSwitch.setOn(false, animated: true)
        }
    }
}
