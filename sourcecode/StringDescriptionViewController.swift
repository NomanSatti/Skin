//
//  StringDescriptionViewController.swift
//  Mobikul Single App
//
//  Created by akash on 08/08/19.
//  Copyright © 2019 Webkul. All rights reserved.
//

import UIKit

class StringDescriptionViewController: UIViewController {
    
    @IBOutlet weak var descriptionLbl: UILabel!
    var descriptionValue: String?
    var titleValue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = titleValue
        self.descriptionLbl.text = descriptionValue
        // Do any additional setup after loading the view.
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
