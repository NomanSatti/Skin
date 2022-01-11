//
//  CustomSelectDeviceViewController.swift
//  sourcecode
//
//  Created by Work on 5/1/20.
//  Copyright © 2020 ranjit. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit
import SwiftMessages
import SwiftyJSON

class CustomSelectDeviceViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var deviceOptions = [DeviceOption]()
    
    var parameters = [String: Any]()
    
    
    
    
    var customImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Artboard"))
              imageView.contentMode = UIView.ContentMode.scaleAspectFit
              self.setTitleView(imageView, showBackButton: true)
              self.view.backgroundColor = .white
              self.tableView.dataSource = self
              self.tableView.delegate = self
              getAllDevices()
      
    }
    
    private func getAllDevices(){
             NetworkManager.sharedInstance.showLoader()
           let url: String = API_ROOT_DOMAIN + "rest/V1/wallpaper/get-options"
                 var request = URLRequest(url:  NSURL(string: url)! as URL)

                 // Your request method type Get or post etc according to your requirement
                 request.httpMethod = "GET"

                 request.setValue("Bearer \(ADMIN_TOKEN)", forHTTPHeaderField: "Authorization")
                 request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                   
           
                 Alamofire.request(request).responseJSON { (responseObject) -> Void in

                   print(responseObject)
                   if let data =  responseObject.result.value {
                       
                       let json = JSON(responseObject.result.value)
                       
                       if let firstItem =  json.arrayValue.first {
                           let response = firstItem["response"]
                           let data = response["data"]
                           let mobiles = data["mobiles"]
                           for mobile in mobiles.arrayValue{
                               let new = try? JSONDecoder().decode(DeviceOption.self, from: mobile.rawData())
                               if new!.name.count != 0 {
                                    self.deviceOptions.append(new!)
                               }
                              
                           }
                        NetworkManager.sharedInstance.dismissLoader()
                        self.tableView.reloadData()
                    }
                    
                    }
                    
        }
    }
    
    
    
}


extension CustomSelectDeviceViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Select Device Option "
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let lan =  Defaults.language{
            if lan == "ar"{
                let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
                header.textLabel?.textAlignment = NSTextAlignment.center
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.deviceOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomDeviceSelectionCell", for: indexPath) as! CustomDeviceSelectionCell
        cell.label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.label.font = UIFont.boldSystemFont(ofSize: 18)
        cell.label.text = self.deviceOptions[indexPath.row].name
        
        
        if let lan =  Defaults.language{
            if lan == "ar"{
                cell.leadingConstraintForArabic?.isActive = true
                cell.leadingConstraintForEnglish?.isActive = false
            } else {
                cell.leadingConstraintForArabic?.isActive = false
                cell.leadingConstraintForEnglish?.isActive = true
            }
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let deviceSelected = self.deviceOptions[indexPath.row].name
     
        let device = self.deviceOptions[indexPath.row]
        
        let vc = R.StoryboardRef.Main.instantiateViewController(withIdentifier: R.ViewControllerIds.customDispaly) as! CustomDisplayViewController
        vc.deviceImageUrl = device.image
        vc.deviceSelected = device.name
        vc.wallpaperImage = self.customImage!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


class CustomDeviceSelectionCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var leadingConstraintForEnglish: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraintForArabic: NSLayoutConstraint!
}
